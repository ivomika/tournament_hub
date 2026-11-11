import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tournament_app/app/navigation/interaction_presentation.dart';
import 'package:tournament_app/app/navigation/interaction_route_observer.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/presentation/navigation/interaction_outcome.dart';

final class GoRouterPushInteractionAdapter {
  GoRouterPushInteractionAdapter({
    required this.router,
    required this.observer,
  });

  final GoRouter router;
  final InteractionRouteObserver observer;
  final _pending = <Future<void> Function(InteractionCancellationReason)>{};
  Future<void>? _closing;

  InteractionPresentation<Result> open<Result extends Object>(
    AppRoute route, {
    required NavigationEntryId entryId,
  }) {
    late final InteractionPresentation<Result> presentation;
    presentation = InteractionPresentation<Result>(
      entryId,
      onSettled: () => _pending.remove(presentation.cancel),
    );
    _pending.add(presentation.cancel);
    final target = _PushTarget<Result>();
    presentation.bindClose((value) => _close(target, value));
    // Открытие принадлежит presentation; close дожидается target.ready.
    unawaited(_open(route, presentation, target));
    return presentation;
  }

  Future<void> _open<Result extends Object>(
    AppRoute route,
    InteractionPresentation<Result> presentation,
    _PushTarget<Result> target,
  ) async {
    try {
      if (_closing != null ||
          observer.navigator == null ||
          router.routerDelegate.navigatorKey.currentState == null ||
          router.configuration.findMatch(Uri.parse(route.location)).isError) {
        presentation.failUnavailable();
        return;
      }
      final popped = router.push<Result>(route.location);
      final information = router.routeInformationProvider.value.state;
      if (information is RouteInformationState<Result>) {
        target.completer = information.completer;
      }
      presentation.observe(_settledResult(popped, target));
      WidgetsBinding.instance.ensureVisualUpdate();
      await WidgetsBinding.instance.endOfFrame;
      final match = _find(
        router.routerDelegate.currentConfiguration.matches,
        target.completer,
      );
      target.match = match;
      if (match != null) target.nativeRoute = observer.forPage(match.pageKey);
      if (match == null || target.nativeRoute == null) {
        presentation.failUnavailable();
        _completeNative(target, null);
        return;
      }
      presentation.markOpened();
    } catch (_) {
      presentation.failUnavailable();
      _completeNative(target, null);
    } finally {
      target.ready.complete();
    }
  }

  Future<Result?> _settledResult<Result extends Object>(
    Future<Result?> popped,
    _PushTarget<Result> target,
  ) async {
    final value = await popped;
    await target.ready.future;
    final nativeRoute = target.nativeRoute;
    if (nativeRoute is TransitionRoute<Object?>) await nativeRoute.completed;
    return value;
  }

  ImperativeRouteMatch? _find(
    List<RouteMatchBase> matches,
    Completer<Object?>? completer,
  ) {
    for (final match in matches) {
      if (match is ImperativeRouteMatch &&
          identical(match.completer, completer)) {
        return match;
      }
      if (match is ShellRouteMatch) {
        final found = _find(match.matches, completer);
        if (found != null) return found;
      }
    }
    return null;
  }

  Future<void> _close<Result extends Object>(
    _PushTarget<Result> target,
    Result? value,
  ) async {
    await target.ready.future;
    final targetMatch = target.match;
    final nativeRoute = target.nativeRoute;
    if (targetMatch == null || nativeRoute == null) return;
    if (nativeRoute.navigator == null) {
      _completeNative(target, value);
      return;
    }
    final configuration = router.routerDelegate.currentConfiguration;
    if (_find(configuration.matches, target.completer) != null) {
      if (nativeRoute.isCurrent &&
          configuration.last.pageKey == targetMatch.pageKey) {
        router.pop<Result>(value);
      } else {
        // remove() обрезает весь хвост; здесь сохраняем соседние записи.
        router.restore(
          RouteMatchList(
            matches: _without(configuration.matches, targetMatch),
            uri: configuration.uri,
            pathParameters: configuration.pathParameters,
            extra: configuration.extra,
            error: configuration.error,
          ),
        );
        WidgetsBinding.instance.ensureVisualUpdate();
        await WidgetsBinding.instance.endOfFrame;
        if (_find(
              router.routerDelegate.currentConfiguration.matches,
              target.completer,
            ) !=
            null) {
          throw StateError('Owned push was not removed');
        }
        _completeNative(target, value);
      }
    }
    if (nativeRoute is TransitionRoute<Object?>) await nativeRoute.completed;
  }

  List<RouteMatchBase> _without(
    List<RouteMatchBase> matches,
    RouteMatchBase target,
  ) {
    final remaining = <RouteMatchBase>[];
    for (final match in matches) {
      if (identical(match, target)) continue;
      if (match is ShellRouteMatch) {
        final children = _without(match.matches, target);
        if (children.isEmpty) continue;
        remaining.add(
          ShellRouteMatch(
            route: match.route,
            matches: children,
            matchedLocation: match.matchedLocation,
            pageKey: match.pageKey,
            navigatorKey: match.navigatorKey,
          ),
        );
      } else {
        remaining.add(match);
      }
    }
    return remaining;
  }

  void _completeNative<Result extends Object>(
    _PushTarget<Result> target,
    Result? value,
  ) {
    final completer = target.completer;
    if (completer != null && !completer.isCompleted) completer.complete(value);
  }

  Future<void> close() {
    final closing = _closing;
    if (closing != null) return closing;
    final completion = Completer<void>();
    _closing = completion.future;
    completion.complete(
      Future.wait<void>([
        for (final cancel in _pending.toList())
          cancel(InteractionCancellationReason.ownerEnded),
      ]).then<void>((_) {}),
    );
    return completion.future;
  }
}

final class _PushTarget<Result extends Object> {
  final ready = Completer<void>();
  Completer<Result?>? completer;
  ImperativeRouteMatch? match;
  Route<Object?>? nativeRoute;
}
