import 'dart:async';

import '../../infrastructure/bootstrap/empty_app_session_reader.dart';
import '../bootstrap/app_bootstrap.dart';
import '../lifecycle/app_state_source.dart';
import '../lifecycle/app_state_store.dart';
import '../runtime/app_runtime.dart';

final class AppComposition implements AppRuntime {
  AppComposition._(this._bootstrap, this._stateStore);

  factory AppComposition.production() {
    final stateStore = AppStateStore();
    final bootstrap = AppBootstrap(const EmptyAppSessionReader(), stateStore);
    return AppComposition._(bootstrap, stateStore);
  }

  final AppBootstrap _bootstrap;
  final AppStateStore _stateStore;
  bool _isDisposed = false;

  @override
  AppStateSource get appStateSource => _stateStore;

  @override
  Future<void> start() => _bootstrap.start();

  @override
  Future<void> retry() => _bootstrap.retry();

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _bootstrap.dispose();
    unawaited(_stateStore.dispose());
  }
}
