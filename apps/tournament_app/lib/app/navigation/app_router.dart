import 'dart:async';

import '../lifecycle/app_state_source.dart';
import 'app_route_policy.dart';
import 'models/app_route_projection.dart';
import 'models/navigation_intent.dart';
import 'navigation_intent_store.dart';
import 'ports/app_route_source.dart';
import 'ports/navigation_intent_sink.dart';

final class AppRouter implements AppRouteSource, NavigationIntentSink {
  AppRouter({
    required AppStateSource stateSource,
    required NavigationIntentStore intentStore,
    AppRoutePolicy routePolicy = const AppRoutePolicy(),
  }) : _stateSource = stateSource,
       _intentStore = intentStore,
       _routePolicy = routePolicy,
       _current = routePolicy.project(stateSource.current, intentStore.current);

  final AppStateSource _stateSource;
  final NavigationIntentStore _intentStore;
  final AppRoutePolicy _routePolicy;
  final StreamController<AppRouteProjection> _changes =
      StreamController.broadcast(sync: true);
  final List<StreamSubscription<Object?>> _subscriptions = [];
  AppRouteProjection _current;
  bool _isStarted = false;
  bool _isDisposed = false;

  @override
  AppRouteProjection get current => _current;

  @override
  Stream<AppRouteProjection> get changes => _changes.stream;

  void start() {
    if (_isDisposed || _isStarted) return;
    _isStarted = true;
    _subscriptions
      ..add(_stateSource.changes.listen((_) => _refresh()))
      ..add(_intentStore.changes.listen((_) => _refresh()));
    _refresh();
  }

  @override
  void go(NavigationIntent intent) => _intentStore.go(intent);

  @override
  void back() => _intentStore.back();

  void _refresh() {
    if (_isDisposed) return;
    final next = _routePolicy.project(
      _stateSource.current,
      _intentStore.current,
    );
    if (next == _current) return;
    _current = next;
    _changes.add(next);
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    await _changes.close();
  }
}
