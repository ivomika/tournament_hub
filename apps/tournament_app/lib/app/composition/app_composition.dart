import 'dart:async';

import 'package:flutter/services.dart';

import '../../application/bootstrap/models/active_tournament_projection.dart';
import '../../application/bootstrap/models/app_actor.dart';
import '../../application/bootstrap/models/app_session_projection.dart';
import '../../application/bootstrap/models/tournament_lifecycle_projection.dart';
import '../../application/profile/profile_service.dart';
import '../../application/tournament/host_tournament_service.dart';
import '../../application/tournament/models/host_tournament_session.dart';
import '../../application/tournament/models/host_tournament_projection.dart';
import '../../domain/profile/local_profile.dart';
import '../../domain/tournament/engine/tournament_engines.dart';
import '../../domain/tournament/tournament_models.dart';
import '../../infrastructure/database/tournament_hub_database.dart'
    hide LocalProfile;
import '../../infrastructure/game/mk11_roster_manifest_parser.dart';
import '../../infrastructure/persistence/drift_active_tournament_store.dart';
import '../../infrastructure/persistence/drift_tournament_history_store.dart';
import '../../infrastructure/profile/drift_local_profile_repository.dart';
import '../../infrastructure/settings/shared_preferences_app_settings_repository.dart';
import '../bootstrap/app_bootstrap.dart';
import '../lifecycle/app_state_source.dart';
import '../lifecycle/app_state_store.dart';
import '../lifecycle/app_state.dart';
import '../navigation/app_router.dart';
import '../navigation/models/navigation_intent.dart';
import '../navigation/navigation_intent_store.dart';
import '../navigation/ports/app_route_source.dart';
import '../navigation/ports/navigation_intent_sink.dart';
import '../runtime/app_runtime.dart';

final class AppComposition
    implements AppRuntime, AppProfileRuntime, AppHostTournamentRuntime {
  AppComposition._(
    this._bootstrap,
    this._stateStore,
    this._intentStore,
    this._router,
    this._profiles,
    this._tournaments,
    this._database,
  );

  factory AppComposition.production() {
    return AppComposition._withDatabase(TournamentHubDatabase.production());
  }

  factory AppComposition.memory() {
    return AppComposition._withDatabase(
      Future.value(TournamentHubDatabase.memory()),
    );
  }

  factory AppComposition._withDatabase(Future<TournamentHubDatabase> database) {
    final stateStore = AppStateStore();
    final localStore = DriftLocalProfileRepository(database);
    final settings = SharedPreferencesAppSettingsRepository();
    final profiles = ProfileService(localStore, settings);
    var idCounter = 0;
    final tournaments = database.then((value) async {
      final manifest = await rootBundle.loadString(
        'assets/fighters/manifest.json',
      );
      return HostTournamentService(
        DriftActiveTournamentStore(value),
        DriftTournamentHistoryStore(value),
        createTournamentFormatEngineRegistryV1(),
        const Mk11RosterManifestParser().parse(manifest),
        () => DateTime.now().toUtc(),
        (prefix) =>
            '$prefix-${DateTime.now().microsecondsSinceEpoch}-${++idCounter}',
      );
    });
    final bootstrap = AppBootstrap(localStore, stateStore);
    final intentStore = NavigationIntentStore();
    final router = AppRouter(stateSource: stateStore, intentStore: intentStore);
    return AppComposition._(
      bootstrap,
      stateStore,
      intentStore,
      router,
      profiles,
      tournaments,
      database,
    );
  }

  final AppBootstrap _bootstrap;
  final AppStateStore _stateStore;
  final NavigationIntentStore _intentStore;
  final AppRouter _router;
  final ProfileService _profiles;
  final Future<HostTournamentService> _tournaments;
  final Future<TournamentHubDatabase> _database;
  HostTournamentSession? _hostTournamentSession;
  String? _correctionMatchId;
  int _seed = 100;
  bool _isDisposed = false;

  @override
  AppStateSource get appStateSource => _stateStore;

  @override
  AppRouteSource get appRouteSource => _router;

  @override
  NavigationIntentSink get navigation => _router;

  @override
  Future<void> start() async {
    await _bootstrap.start();
    final state = _stateStore.current;
    if (state case AppOperational(
      session: AppSessionProjection(activeTournament: != null),
    )) {
      _hostTournamentSession = await (await _tournaments).loadActive();
    }
    _router.start();
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
  HostTournamentProjection? get hostTournamentProjection =>
      _hostTournamentSession == null
      ? null
      : HostTournamentProjectionMapper.fromSession(_hostTournamentSession!);

  @override
  String? get resultEntryMatchId => _correctionMatchId;

  @override
  Future<void> createTournament({
    String formatId = 'double-elimination',
  }) async {
    final profile = _profile;
    _hostTournamentSession = await (await _tournaments).createDraft(
      profile: profile,
      title: 'Новый турнир',
      formatId: formatId,
    );
    _publishTournament();
  }

  @override
  void continueTournament() {
    _router.go(
      NavigationIntent.hostTournament(tournamentId: _session.tournament.id),
    );
  }

  @override
  Future<void> openTournament() async {
    var session = await (await _tournaments).open(_session);
    session = await (await _tournaments).addLocalProfile(
      session,
      profile: _profile,
    );
    _hostTournamentSession = session;
    _publishTournament();
  }

  @override
  Future<void> addGuest(String nickname) async {
    _hostTournamentSession = await (await _tournaments).addGuest(
      _session,
      nickname: nickname,
    );
    _publishTournament();
  }

  @override
  Future<void> removeParticipant(String participantId) async {
    final participant = _session.tournament.participants.singleWhere(
      (value) => value.id.value == participantId,
    );
    _hostTournamentSession = await (await _tournaments).removeParticipant(
      _session,
      participantId: participant.id,
    );
    _publishTournament();
  }

  @override
  Future<void> startDistribution() async {
    _hostTournamentSession = await (await _tournaments).startDistribution(
      _session,
      assignmentSeed: ++_seed,
    );
    _publishTournament();
  }

  @override
  Future<void> backToOpen() async {
    _hostTournamentSession = await (await _tournaments).backToOpen(_session);
    _publishTournament();
  }

  @override
  Future<void> rerollAll() async {
    _hostTournamentSession = await (await _tournaments).rerollAll(
      _session,
      assignmentSeed: ++_seed,
    );
    _publishTournament();
  }

  @override
  Future<void> startTournament() async {
    _hostTournamentSession = await (await _tournaments).startRunning(
      _session,
      bracketSeed: ++_seed,
    );
    _publishTournament();
  }

  @override
  void openCurrentResult() {
    _correctionMatchId = null;
    _router.go(
      NavigationIntent.hostResultEntry(tournamentId: _session.tournament.id),
    );
  }

  @override
  void openLastResultCorrection() {
    final finished = _session.engineState!.matches
        .where((match) => match.result != null)
        .toList();
    if (finished.isEmpty) return;
    _correctionMatchId = finished.last.id;
    _router.go(
      NavigationIntent.hostResultEntry(tournamentId: _session.tournament.id),
    );
  }

  @override
  void closeResultEntry() {
    _correctionMatchId = null;
    continueTournament();
  }

  @override
  Future<void> selectWinner(String participantId, {int loserScore = 0}) async {
    final session = _session;
    final state = session.engineState!;
    final match = _correctionMatchId == null
        ? state.currentMatch!
        : state.matches.singleWhere((value) => value.id == _correctionMatchId);
    final winner = [
      match.firstParticipantId,
      match.secondParticipantId,
    ].singleWhere((value) => value.value == participantId);
    final loser = winner == match.firstParticipantId
        ? match.secondParticipantId
        : match.firstParticipantId;
    final result = NormalMatchResult(
      winnerId: winner,
      loserId: loser,
      winnerScore: match.firstTo,
      loserScore: loserScore,
    );
    _hostTournamentSession = _correctionMatchId == null
        ? await (await _tournaments).submitResult(session, result: result)
        : await (await _tournaments).correctResult(
            session,
            matchId: _correctionMatchId!,
            result: result,
          );
    _correctionMatchId = null;
    _publishTournament();
  }

  @override
  Future<void> withdrawParticipant(String participantId) async {
    final participant = _session.tournament.participants.singleWhere(
      (value) => value.id.value == participantId,
    );
    _hostTournamentSession = await (await _tournaments).withdraw(
      _session,
      participantId: participant.id,
    );
    _publishTournament();
  }

  @override
  Future<void> finishTournament() async {
    _hostTournamentSession = await (await _tournaments).finish(_session);
    _publishTournament();
  }

  @override
  Future<void> cancelTournament() async {
    _hostTournamentSession = await (await _tournaments).cancel(
      _session,
      reason: 'Отменено организатором',
    );
    _publishTournament();
  }

  @override
  Future<void> leaveTerminalTournament() async {
    _hostTournamentSession = null;
    final current = _stateStore.current;
    if (current is AppOperational) {
      _stateStore.publish(
        AppOperational(AppSessionProjection(profile: current.session.profile)),
      );
    }
    _router.go(const NavigationIntent.main());
  }

  HostTournamentSession get _session {
    final value = _hostTournamentSession;
    if (value == null) throw StateError('Host tournament is not loaded.');
    return value;
  }

  LocalProfile get _profile {
    final current = _stateStore.current;
    if (current is! AppOperational) {
      throw StateError('Local profile is unavailable.');
    }
    return LocalProfile(
      id: current.session.profile.id,
      nickname: current.session.profile.nickname,
    );
  }

  void _publishTournament() {
    final current = _stateStore.current;
    if (current is! AppOperational) return;
    final session = _session;
    _stateStore.publish(
      AppOperational(
        AppSessionProjection(
          profile: current.session.profile,
          activeTournament: ActiveTournamentProjection(
            id: session.tournament.id,
            localProfileId: session.localProfileId,
            actor: AppActor.host,
            lifecycle: switch (session.tournament.lifecycle) {
              TournamentLifecycle.draft => TournamentLifecycleProjection.draft,
              TournamentLifecycle.open => TournamentLifecycleProjection.open,
              TournamentLifecycle.distribution =>
                TournamentLifecycleProjection.distribution,
              TournamentLifecycle.running =>
                TournamentLifecycleProjection.running,
              TournamentLifecycle.finished =>
                TournamentLifecycleProjection.finished,
              TournamentLifecycle.cancelled =>
                TournamentLifecycleProjection.cancelled,
            },
          ),
        ),
      ),
    );
    _router.go(
      NavigationIntent.hostTournament(tournamentId: session.tournament.id),
    );
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
