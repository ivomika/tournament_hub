import 'package:flutter/widgets.dart';

final class InteractionRouteObserver extends NavigatorObserver {
  final _routes = <LocalKey, Route<Object?>>{};

  Route<Object?>? forPage(LocalKey key) => _routes[key];

  void _remember(Route<Object?> route) {
    final settings = route.settings;
    if (settings is Page) {
      final key = settings.key;
      if (key != null) _routes[key] = route;
    }
  }

  void _forget(Route<Object?> route) {
    _routes.removeWhere((key, candidate) => identical(candidate, route));
  }

  @override
  void didPush(Route<Object?> route, Route<Object?>? previousRoute) =>
      _remember(route);

  @override
  void didPop(Route<Object?> route, Route<Object?>? previousRoute) =>
      _forget(route);

  @override
  void didRemove(Route<Object?> route, Route<Object?>? previousRoute) =>
      _forget(route);

  @override
  void didReplace({Route<Object?>? newRoute, Route<Object?>? oldRoute}) {
    if (oldRoute != null) _forget(oldRoute);
    if (newRoute != null) _remember(newRoute);
  }
}
