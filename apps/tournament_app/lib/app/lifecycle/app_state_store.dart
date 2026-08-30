import 'dart:async';

import 'app_lifecycle_policy.dart';
import 'app_state.dart';
import 'app_state_source.dart';
import 'app_state_writer.dart';

final class AppStateStore implements AppStateSource, AppStateWriter {
  factory AppStateStore({
    AppLifecyclePolicy policy = const AppLifecyclePolicy(),
    AppState initialState = const AppBootstrapping(
      stage: AppBootstrapStage.dependencies,
      generation: 0,
    ),
  }) => AppStateStore._(policy, initialState);

  AppStateStore._(this._policy, this._current);

  final AppLifecyclePolicy _policy;
  final StreamController<AppState> _changes = StreamController.broadcast(
    sync: true,
  );
  AppState _current;
  bool _isDisposed = false;

  @override
  AppState get current => _current;

  @override
  Stream<AppState> get changes => _changes.stream;

  @override
  void publish(AppState state) {
    if (_isDisposed) return;
    if (state == _current) return;
    if (!_policy.canTransition(_current, state)) {
      throw StateError(
        'Invalid app lifecycle transition: '
        '${_current.kind.name} -> ${state.kind.name}',
      );
    }
    _current = state;
    _changes.add(state);
  }

  Future<void> dispose() async {
    if (_isDisposed) return;
    _isDisposed = true;
    await _changes.close();
  }
}
