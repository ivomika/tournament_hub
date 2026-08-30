import 'dart:async';

import '../../infrastructure/bootstrap/empty_app_session_reader.dart';
import '../bootstrap/app_bootstrap.dart';
import '../lifecycle/app_state_source.dart';
import '../lifecycle/app_state_store.dart';
import '../navigation/app_router.dart';
import '../navigation/navigation_intent_store.dart';
import '../navigation/ports/app_route_source.dart';
import '../navigation/ports/navigation_intent_sink.dart';
import '../runtime/app_runtime.dart';

final class AppComposition implements AppRuntime {
  AppComposition._(
    this._bootstrap,
    this._stateStore,
    this._intentStore,
    this._router,
  );

  factory AppComposition.production() {
    final stateStore = AppStateStore();
    final bootstrap = AppBootstrap(const EmptyAppSessionReader(), stateStore);
    final intentStore = NavigationIntentStore();
    final router = AppRouter(stateSource: stateStore, intentStore: intentStore);
    return AppComposition._(bootstrap, stateStore, intentStore, router);
  }

  final AppBootstrap _bootstrap;
  final AppStateStore _stateStore;
  final NavigationIntentStore _intentStore;
  final AppRouter _router;
  bool _isDisposed = false;

  @override
  AppStateSource get appStateSource => _stateStore;

  @override
  AppRouteSource get appRouteSource => _router;

  @override
  NavigationIntentSink get navigation => _router;

  @override
  Future<void> start() async {
    _router.start();
    await _bootstrap.start();
  }

  @override
  Future<void> retry() => _bootstrap.retry();

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _bootstrap.dispose();
    unawaited(_router.dispose());
    unawaited(_intentStore.dispose());
    unawaited(_stateStore.dispose());
  }
}
