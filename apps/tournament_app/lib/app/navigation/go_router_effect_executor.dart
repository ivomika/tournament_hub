import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/navigation/navigation_effect.dart';
import 'package:tournament_app/app/navigation/navigation_effect_executor.dart';
import 'package:tournament_app/app/navigation/navigation_execution_result.dart';

class GoRouterEffectExecutor implements NavigationEffectExecutor {
  GoRouterEffectExecutor(this.router, this.readContext);
  final GoRouter router;
  final NavigationContext Function() readContext;
  NavigationEffect? activeEffect;
  @override
  Future<NavigationExecutionResult> execute(NavigationEffect effect) async {
    activeEffect = effect;
    try {
      switch (effect) {
        case PushRouteEffect():
          // push completion belongs to route dismissal, not transition execution.
          unawaited(router.push<void>(effect.route.location));
        case GoToRouteEffect():
          router.go(effect.route.location);
        case PopRouteEffect():
          if (readContext().entryId != effect.entryId || !router.canPop()) {
            return const NavigationExecutionFailed(
              NavigationExecutionFailure.routerUnavailable,
            );
          }
          router.pop();
      }
      WidgetsBinding.instance.ensureVisualUpdate();
      await WidgetsBinding.instance.endOfFrame;
      return const NavigationExecutionSucceeded();
    } on Exception {
      return const NavigationExecutionFailed(
        NavigationExecutionFailure.routerUnavailable,
      );
    } finally {
      activeEffect = null;
    }
  }
}
