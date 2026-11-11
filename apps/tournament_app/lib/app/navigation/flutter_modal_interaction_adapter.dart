import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tournament_app/app/navigation/date_picker_interaction_options.dart';
import 'package:tournament_app/app/navigation/interaction_presentation.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/presentation/navigation/interaction_outcome.dart';

final class FlutterModalInteractionAdapter {
  FlutterModalInteractionAdapter({
    required this.navigatorKey,
    required this.scaffoldKey,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final _pending = <Future<void> Function(InteractionCancellationReason)>{};
  Future<void>? _closing;
  Future<void> Function(InteractionCancellationReason)? _sheetCancel;

  InteractionPresentation<Result> dialog<Result extends Object>({
    required NavigationEntryId entryId,
    required WidgetBuilder builder,
  }) {
    final presentation = _create<Result>(entryId);
    final navigator = navigatorKey.currentState;
    if (_closing != null || navigator == null) {
      presentation.failUnavailable();
      return presentation;
    }
    try {
      final route = DialogRoute<Result>(
        context: navigator.context,
        builder: builder,
      );
      presentation.bindClose((value) => _closeRoute(route, value));
      _openRoute(navigator, route, presentation);
    } catch (_) {
      presentation.failUnavailable();
    }
    return presentation;
  }

  InteractionPresentation<Result> modalBottomSheet<Result extends Object>({
    required NavigationEntryId entryId,
    required WidgetBuilder builder,
  }) {
    final presentation = _create<Result>(entryId);
    final navigator = navigatorKey.currentState;
    if (_closing != null || navigator == null) {
      presentation.failUnavailable();
      return presentation;
    }
    try {
      final route = ModalBottomSheetRoute<Result>(
        builder: builder,
        isScrollControlled: true,
        barrierLabel: MaterialLocalizations.of(navigator.context)
            .modalBarrierDismissLabel,
      );
      presentation.bindClose((value) => _closeRoute(route, value));
      _openRoute(navigator, route, presentation);
    } catch (_) {
      presentation.failUnavailable();
    }
    return presentation;
  }

  InteractionPresentation<Result> bottomSheet<Result extends Object>({
    required NavigationEntryId entryId,
    required WidgetBuilder builder,
  }) {
    final presentation = _create<Result>(entryId);
    final scaffold = scaffoldKey.currentState;
    if (_closing != null || scaffold == null) {
      presentation.failUnavailable();
      return presentation;
    }
    final ready = Completer<PersistentBottomSheetController?>();
    presentation.bindClose((_) async {
      final controller = await ready.future;
      if (controller != null && scaffold.mounted) {
        controller.close();
        await controller.closed;
      }
    });
    final previous = _sheetCancel;
    _sheetCancel = presentation.cancel;
    unawaited(_openSheet(scaffold, builder, presentation, ready, previous));
    return presentation;
  }

  Future<void> _openSheet<Result extends Object>(
    ScaffoldState scaffold,
    WidgetBuilder builder,
    InteractionPresentation<Result> presentation,
    Completer<PersistentBottomSheetController?> ready,
    Future<void> Function(InteractionCancellationReason)? previous,
  ) async {
    PersistentBottomSheetController? controller;
    try {
      if (previous != null) {
        await previous(InteractionCancellationReason.dismissed);
      }
      if (_closing != null || presentation.isClosing) return;
      if (!scaffold.mounted) {
        presentation.failUnavailable();
        return;
      }
      controller = scaffold.showBottomSheet(builder);
      presentation.observe(controller.closed.then<Result?>((_) => null));
      WidgetsBinding.instance.ensureVisualUpdate();
      await WidgetsBinding.instance.endOfFrame;
      presentation.markOpened();
    } catch (_) {
      presentation.failUnavailable();
    } finally {
      ready.complete(controller);
    }
  }

  InteractionPresentation<DateTime> datePicker({
    required NavigationEntryId entryId,
    required DatePickerInteractionOptions options,
  }) => dialog<DateTime>(
    entryId: entryId,
    builder: _DatePickerBuilder(options).build,
  );

  InteractionPresentation<Result> _create<Result extends Object>(
    NavigationEntryId entryId,
  ) {
    late final InteractionPresentation<Result> presentation;
    presentation = InteractionPresentation<Result>(
      entryId,
      onSettled: () {
        _pending.remove(presentation.cancel);
        if (_sheetCancel == presentation.cancel) _sheetCancel = null;
      },
    );
    _pending.add(presentation.cancel);
    return presentation;
  }

  void _openRoute<Result extends Object>(
    NavigatorState navigator,
    ModalRoute<Result> route,
    InteractionPresentation<Result> presentation,
  ) {
    final popped = navigator.push<Result>(route);
    presentation.observe(
      popped.then((value) async {
        await route.completed;
        return value;
      }),
    );
    presentation.markOpened();
  }

  Future<void> _closeRoute<Result extends Object>(
    ModalRoute<Result> route,
    Result? value,
  ) async {
    final navigator = route.navigator;
    if (navigator != null && route.isActive) {
      navigator.removeRoute(route, value);
    }
    await route.completed;
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

final class _DatePickerBuilder {
  const _DatePickerBuilder(this.options);

  final DatePickerInteractionOptions options;

  Widget build(BuildContext context) => DatePickerDialog(
    initialDate: options.initialDate,
    currentDate: options.currentDate,
    firstDate: options.firstDate,
    lastDate: options.lastDate,
  );
}
