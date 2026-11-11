import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/app/routing/screen_route_builders.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/navigation/navigation_coordinator.dart';
import 'package:tournament_app/app/navigation/navigation_guard.dart';
import 'package:tournament_app/app/navigation/navigation_decision.dart';
import 'package:tournament_app/app/navigation/navigation_effect.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';
import 'package:tournament_app/app/navigation/go_router_effect_executor.dart';
import 'package:tournament_app/presentation/navigation/screen_navigation_controller.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen_state.dart';

class AppNavigationSession {
  AppNavigationSession({
    AppRoute initialRoute = const HomeRoute(),
    this.initialized = true,
    this.screens = const ScreenRouteBuilders(),
  }) : _currentRoute = initialRoute {
    router = GoRouter(
      routes: $appRoutes,
      initialLocation: initialRoute.location,
      onEnter: _onEnter,
      errorBuilder: _navigationError,
    );
    _executor = GoRouterEffectExecutor(router, readContext);
    coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: readContext,
      executor: _executor,
    );
    router.routerDelegate.addListener(_routerChanged);
  }
  final bool initialized;
  final ScreenRouteBuilders screens;
  late final GoRouter router;
  late final NavigationCoordinator coordinator;
  late final GoRouterEffectExecutor _executor;
  AppRoute _currentRoute;
  NavigationEntryId _currentEntry = const NavigationEntryId(1);
  int _nextEntry = 1;
  int _revision = 1;
  final _entries = <ValueKey<String>, NavigationEntryId>{};
  final _routes = <ValueKey<String>, AppRoute>{};
  final _controllers = <ValueKey<String>, ScreenNavigationController>{};
  AppRoute get currentRoute => _currentRoute;
  Widget _navigationError(BuildContext context, GoRouterState state) =>
      const BootstrapScreen(
        state: BootstrapScreenState(phase: BootstrapPhase.error),
        onRetry: null,
      );
  OnEnterResult _onEnter(
    BuildContext context,
    GoRouterState current,
    GoRouterState next,
    GoRouter router,
  ) {
    try {
      final route = AppRoute.decode(next);
      final snapshot = NavigationContext(
        currentRoute: _currentRoute,
        entryId: _currentEntry,
        revision: _revision,
        initialized: initialized,
        canPop: false,
      );
      if (!const NavigationGuard().canEnter(route, snapshot)) {
        return const Block.stop();
      }
      return const Allow();
    } on FormatException {
      return const Block.stop();
    } on ArgumentError {
      return const Block.stop();
    }
  }
  bool allowExit() {
    final effect = _executor.activeEffect;
    if (effect is PopRouteEffect) return effect.entryId == _currentEntry;
    if (effect is GoToRouteEffect) return true;
    if (coordinator.hasPendingRequests) return false;
    return const NavigationGuard().evaluate(
      const BackRequestedIntent(),
      readContext(),
    ) is NavigationAllowed;
  }
  ScreenNavigationController bind(AppRoute route, ValueKey<String> key) {
    _routes[key] = route;
    _entries.putIfAbsent(key, _allocateEntry);
    _routerChanged();
    return _controllers.putIfAbsent(
      key,
      () => ScreenNavigationController(coordinator.bindToEntry(_entries[key]!)),
    );
  }
  NavigationEntryId _allocateEntry() => NavigationEntryId(++_nextEntry);
  void _routerChanged() {
    final matches = router.routerDelegate.currentConfiguration.matches;
    if (matches.isEmpty) return;
    final activeKeys = matches.map((match) => match.pageKey).toSet();
    _entries.removeWhere((key, entry) => !activeKeys.contains(key));
    _routes.removeWhere((key, route) => !activeKeys.contains(key));
    _controllers.removeWhere((key, controller) => !activeKeys.contains(key));
    final key = matches.last.pageKey;
    final route = _routes[key];
    final entry = _entries[key];
    if (route == null || entry == null || entry == _currentEntry) return;
    _currentRoute = route;
    _currentEntry = entry;
    _revision++;
  }
  NavigationContext readContext() => NavigationContext(
    currentRoute: _currentRoute,
    entryId: _currentEntry,
    revision: _revision,
    initialized: initialized,
    canPop: router.canPop(),
  );
  void dispose() {
    coordinator.dispose();
    router.routerDelegate.removeListener(_routerChanged);
    router.dispose();
  }
}

class AppNavigationScope extends InheritedWidget {
  const AppNavigationScope({
    required this.session,
    required super.child,
    super.key,
  });
  final AppNavigationSession session;
  static AppNavigationSession of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppNavigationScope>()!.session;
  @override
  bool updateShouldNotify(AppNavigationScope oldWidget) =>
      oldWidget.session != session;
}
