import '../lifecycle/app_state_source.dart';
import '../navigation/ports/app_route_source.dart';
import '../navigation/ports/navigation_intent_sink.dart';
import '../../application/tournament/models/host_tournament_projection.dart';
import '../../application/history/models/history_projection.dart';
import '../../application/spectator/models/spectator_server_state.dart';

abstract interface class AppRuntime {
  AppStateSource get appStateSource;

  AppRouteSource get appRouteSource;

  NavigationIntentSink get navigation;

  Future<void> start();

  Future<void> retry();

  void dispose();
}

abstract interface class AppProfileRuntime {
  Future<void> createProfile(String nickname);

  Future<void> renameProfile(String nickname);

  Future<void> resetAccount();
}

abstract interface class AppHostTournamentRuntime {
  HostTournamentProjection? get hostTournamentProjection;
  Stream<HostTournamentProjection?> get hostTournamentProjectionChanges;
  SpectatorServerState get spectatorServerState;
  Stream<SpectatorServerState> get spectatorServerStateChanges;
  String? get resultEntryMatchId;

  Future<void> createTournament({String formatId = 'double-elimination'});
  Future<void> updateDraft({required String title, required String formatId});
  void continueTournament();
  Future<void> openTournament();
  Future<void> addGuest(String nickname);
  Future<void> removeParticipant(String participantId);
  Future<void> startDistribution();
  Future<void> backToOpen();
  Future<void> rerollAll();
  Future<void> startTournament();
  void openCurrentResult();
  void openLastResultCorrection();
  void closeResultEntry();
  Future<void> selectWinner(String participantId, {int loserScore = 0});
  Future<void> withdrawParticipant(String participantId);
  Future<void> finishTournament();
  Future<void> cancelTournament();
  Future<void> leaveTerminalTournament();
  Future<void> retrySpectatorServer();
  Future<void> suspendSpectatorServer();
  Future<void> resumeSpectatorServer();
}

abstract interface class AppHistoryRuntime {
  HistoryProjection? get historyProjection;

  Future<void> loadHistory();
  void openHistoryDetail(String tournamentId);
  Future<void> clearHistory();
}
