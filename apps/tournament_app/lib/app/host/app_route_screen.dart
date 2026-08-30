import 'package:flutter/widgets.dart';

import '../../application/tournament/models/host_tournament_projection.dart';
import '../../presentation/design_system/design_system.dart';
import '../../presentation/screens/host_cancelled/host_cancelled_screen.dart';
import '../../presentation/screens/host_distribution/host_distribution_screen.dart';
import '../../presentation/screens/host_draft/host_draft_screen.dart';
import '../../presentation/screens/host_finished/host_finished_screen.dart';
import '../../presentation/screens/host_open/host_open_screen.dart';
import '../../presentation/screens/host_result_entry/host_result_entry_screen.dart';
import '../../presentation/screens/host_running/host_running_screen.dart';
import '../../presentation/screens/main/main_screen.dart';
import '../../presentation/screens/recoverable_error/recoverable_error_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/registration/registration_screen.dart';
import '../../presentation/screens/screen_registry.dart';
import '../../presentation/screens/settings/settings_screen.dart';
import '../lifecycle/app_state.dart';
import '../navigation/models/app_route_id.dart';
import '../navigation/models/app_route_projection.dart';
import '../runtime/app_runtime.dart';

final class AppRouteScreen extends StatelessWidget {
  const AppRouteScreen({
    required this.projection,
    required this.onDestinationSelected,
    this.appState = const AppProfileRequired(),
    this.onCreateProfile,
    this.onRenameProfile,
    this.onResetAccount,
    this.onRetry,
    this.hostRuntime,
    super.key,
  });

  final AppRouteProjection projection;
  final AppState appState;
  final ValueChanged<AppDestination> onDestinationSelected;
  final Future<void> Function(String nickname)? onCreateProfile;
  final Future<void> Function(String nickname)? onRenameProfile;
  final Future<void> Function()? onResetAccount;
  final VoidCallback? onRetry;
  final AppHostTournamentRuntime? hostRuntime;

  @override
  Widget build(BuildContext context) {
    final screen = switch (projection.route) {
      AppRouteId.fatalError => const RecoverableErrorScreenPreview(
        isFatal: true,
      ),
      AppRouteId.recoverableError => RecoverableErrorScreenPreview(
        onRetry: onRetry,
      ),
      AppRouteId.registration => RegistrationScreenPreview(
        onSubmit: onCreateProfile,
      ),
      AppRouteId.profile => ProfileScreenPreview(
        nickname: _profileNickname,
        onSave: onRenameProfile,
      ),
      AppRouteId.settings => SettingsScreenPreview(onReset: onResetAccount),
      AppRouteId.main => _mainScreen(),
      AppRouteId.hostDraft =>
        _hasHostSession ? _draftScreen() : const HostDraftScreenPreview(),
      AppRouteId.hostOpen =>
        _hasHostSession ? _openScreen() : const HostOpenScreenPreview(),
      AppRouteId.hostDistribution =>
        _hasHostSession
            ? _distributionScreen()
            : const HostDistributionScreenPreview(),
      AppRouteId.hostRunning =>
        _hasHostSession ? _runningScreen() : const HostRunningScreenPreview(),
      AppRouteId.hostResultEntry =>
        _hasHostSession
            ? _resultScreen()
            : const HostResultEntryScreenPreview(),
      AppRouteId.hostFinished =>
        _hasHostSession ? _finishedScreen() : const HostFinishedScreenPreview(),
      AppRouteId.hostCancelled =>
        _hasHostSession
            ? _cancelledScreen()
            : const HostCancelledScreenPreview(),
      _ => TournamentScreenPreview(kind: _previewKind(projection.route)),
    };
    return AppNavigationScope(
      onDestinationSelected: onDestinationSelected,
      child: screen,
    );
  }

  String get _profileNickname => switch (appState) {
    AppOperational(:final session) => session.profile.nickname,
    _ => '',
  };

  bool get _hasHostSession => hostRuntime?.hostTournamentProjection != null;

  Widget _mainScreen() {
    final session = hostRuntime?.hostTournamentProjection;
    final matchup = session == null ? null : _mainMatchup(session);
    return MainScreenPreview(
      activeTournamentName: session?.title,
      activeStage: session?.lifecycle,
      onContinue: session == null ? null : hostRuntime?.continueTournament,
      activeFirst: matchup == null ? previewIvan : _participant(matchup.$1),
      activeSecond: matchup == null ? previewMira : _participant(matchup.$2),
      showMatchupSummary: session == null || matchup != null,
      onCreate: hostRuntime == null
          ? null
          : () => hostRuntime!.createTournament(),
      onCreateSingleElimination: hostRuntime == null
          ? null
          : () => hostRuntime!.createTournament(formatId: 'single-elimination'),
      onCreateRoundRobin: hostRuntime == null
          ? null
          : () => hostRuntime!.createTournament(formatId: 'round-robin'),
    );
  }

  Widget _draftScreen() => HostDraftScreenPreview(
    title: _session.title,
    formatLabel: _formatLabel(_session.formatId),
    onOpen: hostRuntime?.openTournament,
    onCancel: hostRuntime?.cancelTournament,
  );

  Widget _openScreen() => HostOpenScreenPreview(
    participants: [
      for (final participant in _session.participants)
        HostLobbyParticipantViewData(
          id: participant.id,
          nickname: participant.nickname,
          isGuest: participant.isGuest,
        ),
    ],
    onAddGuest: hostRuntime?.addGuest,
    onRemoveParticipant: hostRuntime?.removeParticipant,
    onStartDistribution: hostRuntime?.startDistribution,
    onCancel: hostRuntime?.cancelTournament,
  );

  Widget _distributionScreen() => HostDistributionScreenPreview(
    participants: [
      for (final participant in _session.participants)
        _participant(participant.id),
    ],
    onReroll: hostRuntime?.rerollAll,
    onBackToOpen: hostRuntime?.backToOpen,
    onStart: hostRuntime?.startTournament,
  );

  Widget _runningScreen() {
    final state = _session;
    final current = state.currentMatch;
    final displayMatch = current ?? state.matches.last;
    final hasFinished = state.matches.any(
      (match) => match.status == 'finished',
    );
    return HostRunningScreenPreview(
      title: _session.title,
      currentFirst: _participant(displayMatch.firstParticipantId),
      currentSecond: _participant(displayMatch.secondParticipantId),
      currentMatchTitle: _matchTitle(displayMatch),
      progress:
          '${state.matches.where((match) => match.status == 'finished').length} ИЗ ${state.matches.length}',
      structure: _structure(state),
      readyToFinish: state.isReadyToFinish,
      onEnterResult: hostRuntime?.openCurrentResult,
      onCorrectResult: hasFinished
          ? hostRuntime?.openLastResultCorrection
          : null,
      onFinish: hostRuntime?.finishTournament,
      onWithdrawFirst: current == null
          ? null
          : () => hostRuntime?.withdrawParticipant(current.firstParticipantId),
      onWithdrawSecond: current == null
          ? null
          : () => hostRuntime?.withdrawParticipant(current.secondParticipantId),
    );
  }

  Widget _resultScreen() {
    final state = _session;
    final id = hostRuntime?.resultEntryMatchId;
    final match = id == null
        ? state.currentMatch!
        : state.matches.singleWhere((value) => value.id == id);
    return HostResultEntryScreenPreview(
      first: _participant(match.firstParticipantId),
      second: _participant(match.secondParticipantId),
      matchLabel: _matchTitle(match).toUpperCase(),
      firstTo: match.firstTo,
      onFirstSelected: () =>
          hostRuntime?.selectWinner(match.firstParticipantId),
      onSecondSelected: () =>
          hostRuntime?.selectWinner(match.secondParticipantId),
      onFirstScoreSelected: (loserScore) => hostRuntime?.selectWinner(
        match.firstParticipantId,
        loserScore: loserScore,
      ),
      onSecondScoreSelected: (loserScore) => hostRuntime?.selectWinner(
        match.secondParticipantId,
        loserScore: loserScore,
      ),
      onBack: hostRuntime?.closeResultEntry,
    );
  }

  Widget _finishedScreen() {
    final session = _session;
    return HostFinishedScreenPreview(
      title: session.title,
      champion: _participant(session.championId!),
      standings: [
        for (final placement in session.ranking)
          StandingRowViewData(
            placeLabel: placement.from == placement.to
                ? '${placement.from}'
                : '${placement.from}–${placement.to}',
            participant: _participant(placement.participantId),
            resultLabel: placement.from == 1 ? 'Чемпион' : 'Итоговое место',
          ),
      ],
      onMain: hostRuntime?.leaveTerminalTournament,
    );
  }

  Widget _cancelledScreen() => HostCancelledScreenPreview(
    title: _session.title,
    reason: _session.cancellationReason!,
    onMain: hostRuntime?.leaveTerminalTournament,
  );

  HostTournamentProjection get _session {
    final session = hostRuntime?.hostTournamentProjection;
    if (session == null) throw StateError('Host session is unavailable.');
    return session;
  }

  PreviewParticipant _participant(String participantId) {
    final session = _session;
    final participant = session.participants.singleWhere(
      (value) => value.id == participantId,
    );
    return PreviewParticipant(
      nickname: participant.nickname,
      fighterId: participant.fighterId ?? 'scorpion',
      fighterName: participant.fighterName ?? 'Боец не назначен',
      isGuest: participant.isGuest,
    );
  }

  BracketViewData _structure(HostTournamentProjection state) => BracketViewData(
    format: switch (state.formatId) {
      'double-elimination' => TournamentStructureFormat.doubleElimination,
      'single-elimination' => TournamentStructureFormat.singleElimination,
      'round-robin' => TournamentStructureFormat.roundRobin,
      _ => throw StateError('Unsupported tournament format.'),
    },
    matches: [
      for (final match in state.matches)
        BracketMatchViewData(
          id: match.id,
          title: _matchTitle(match),
          lane: switch (match.stage) {
            'winners' => BracketLane.winners,
            'losers' => BracketLane.losers,
            'finalMatch' || 'bracketReset' => BracketLane.finals,
            _ => BracketLane.stage,
          },
          round: match.round,
          order: match.order,
          first: _participant(match.firstParticipantId),
          second: _participant(match.secondParticipantId),
          state: switch (match.status) {
            'upcoming' => BracketMatchState.pending,
            'current' => BracketMatchState.current,
            'finished' => BracketMatchState.won,
            _ => BracketMatchState.locked,
          },
          resultLabel: _resultLabel(match),
        ),
    ],
  );

  String _matchTitle(HostMatchProjection match) =>
      'Матч ${match.order + 1} · раунд ${match.round}';

  (String, String)? _mainMatchup(HostTournamentProjection session) {
    final current = session.currentMatch;
    if (current != null) {
      return (current.firstParticipantId, current.secondParticipantId);
    }
    final assigned = session.participants
        .where((participant) => participant.fighterId != null)
        .take(2)
        .toList();
    return assigned.length == 2 ? (assigned[0].id, assigned[1].id) : null;
  }

  String _formatLabel(String formatId) => switch (formatId) {
    'double-elimination' => 'Double Elimination',
    'single-elimination' => 'Single Elimination',
    'round-robin' => 'Round Robin',
    _ => formatId,
  };

  String? _resultLabel(HostMatchProjection match) {
    if (match.status != 'finished') return null;
    if (match.isTechnical) return 'Техническая победа';
    return '${match.winnerScore}:${match.loserScore}';
  }

  ScreenPreviewKind _previewKind(AppRouteId route) => switch (route) {
    AppRouteId.bootstrap => ScreenPreviewKind.bootstrap,
    AppRouteId.registration => ScreenPreviewKind.registration,
    AppRouteId.main => ScreenPreviewKind.main,
    AppRouteId.profile => ScreenPreviewKind.profile,
    AppRouteId.history => ScreenPreviewKind.history,
    AppRouteId.historyDetail => ScreenPreviewKind.historyDetail,
    AppRouteId.settings => ScreenPreviewKind.settings,
    AppRouteId.hostDraft => ScreenPreviewKind.hostDraft,
    AppRouteId.hostOpen => ScreenPreviewKind.hostOpen,
    AppRouteId.hostDistribution => ScreenPreviewKind.hostDistribution,
    AppRouteId.hostRunning => ScreenPreviewKind.hostRunning,
    AppRouteId.hostResultEntry => ScreenPreviewKind.hostResultEntry,
    AppRouteId.hostFinished => ScreenPreviewKind.hostFinished,
    AppRouteId.hostCancelled => ScreenPreviewKind.hostCancelled,
    AppRouteId.joinTournament => ScreenPreviewKind.join,
    AppRouteId.participantLobby => ScreenPreviewKind.participantLobby,
    AppRouteId.participantDistribution =>
      ScreenPreviewKind.participantDistribution,
    AppRouteId.participantRunning => ScreenPreviewKind.participantRunning,
    AppRouteId.participantFinished => ScreenPreviewKind.participantFinished,
    AppRouteId.recoverableError || AppRouteId.fatalError => throw StateError(
      'Error routes are handled before preview mapping.',
    ),
  };
}
