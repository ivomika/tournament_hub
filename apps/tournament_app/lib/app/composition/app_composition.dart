import 'dart:async';

import '../../application/profile/profile_service.dart';
import '../../infrastructure/database/tournament_hub_database.dart';
import '../../infrastructure/profile/drift_local_profile_repository.dart';
import '../../infrastructure/settings/shared_preferences_app_settings_repository.dart';
import '../bootstrap/app_bootstrap.dart';
import '../lifecycle/app_state_source.dart';
import '../lifecycle/app_state_store.dart';
import '../navigation/app_router.dart';
import '../navigation/navigation_intent_store.dart';
import '../navigation/ports/app_route_source.dart';
import '../navigation/ports/navigation_intent_sink.dart';
import '../runtime/app_runtime.dart';

final class AppComposition implements AppRuntime, AppProfileRuntime {
  AppComposition._(
    this._bootstrap,
    this._stateStore,
    this._intentStore,
    this._router,
    this._profiles,
    this._database,
  );

  factory AppComposition.production() {
    final stateStore = AppStateStore();
    final database = TournamentHubDatabase.production();
    final localStore = DriftLocalProfileRepository(database);
    final settings = SharedPreferencesAppSettingsRepository();
    final profiles = ProfileService(localStore, settings);
    final bootstrap = AppBootstrap(localStore, stateStore);
    final intentStore = NavigationIntentStore();
    final router = AppRouter(stateSource: stateStore, intentStore: intentStore);
    return AppComposition._(
      bootstrap,
      stateStore,
      intentStore,
      router,
      profiles,
      database,
    );
  }

  final AppBootstrap _bootstrap;
  final AppStateStore _stateStore;
  final NavigationIntentStore _intentStore;
  final AppRouter _router;
  final ProfileService _profiles;
  final Future<TournamentHubDatabase> _database;
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
  Future<void> createProfile(String nickname) async {
    await _profiles.create(nickname);
    await _bootstrap.retry();
  }

  @override
  Future<void> renameProfile(String nickname) async {
    await _profiles.rename(nickname);
    await _bootstrap.retry();
  }

  @override
  Future<void> resetAccount() async {
    await _profiles.reset();
    await _bootstrap.retry();
  }

  @override
  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _bootstrap.dispose();
    unawaited(_router.dispose());
    unawaited(_intentStore.dispose());
    unawaited(_stateStore.dispose());
    unawaited(_database.then((database) => database.close()));
  }
}
