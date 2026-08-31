import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../../application/tournament/models/host_tournament_projection.dart';
import '../../application/spectator/models/spectator_server_state.dart';
import '../../presentation/design_system/design_system.dart';
import '../../presentation/screens/host_cancelled/host_cancelled_screen.dart';
import '../../presentation/screens/host_distribution/host_distribution_screen.dart';
import '../../presentation/screens/host_draft/host_draft_screen.dart';
import '../../presentation/screens/host_finished/host_finished_screen.dart';
import '../../presentation/screens/host_open/host_open_screen.dart';
import '../../presentation/screens/host_result_entry/host_result_entry_screen.dart';
import '../../presentation/screens/host_running/host_running_screen.dart';
import '../../presentation/screens/main/main_screen.dart';
import '../../presentation/screens/history/history_screen.dart';
import '../../presentation/screens/history_detail/history_detail_screen.dart';
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
    this.historyRuntime,
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
  final AppHistoryRuntime? historyRuntime;

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
        statistics: _profileStatistics,
        onSave: onRenameProfile,
      ),
      AppRouteId.history => _historyScreen(),
      AppRouteId.historyDetail => _historyDetailScreen(),
      AppRouteId.settings => SettingsScreenPreview(
        onClearHistory: historyRuntime?.clearHistory,
        onReset: onResetAccount,
      ),
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

  Widget _historyScreen() => HistoryScreenPreview(
    entries: historyRuntime?.historyProjection?.entries
        .map(
          (entry) => HistoryListItemViewData(
            id: entry.tournament.id,
            title: entry.tournament.title,
            summary:
                '${_formatLabel(entry.tournament.formatId)} · ${entry.tournament.participants.length} участников · ${entry.finishedAtUtc.toLocal()}',
            isCancelled: entry.tournament.lifecycle == 'cancelled',
            champion: entry.tournament.championId == null
                ? null
                : _historyParticipant(
                    entry.tournament,
                    entry.tournament.championId!,
                  ),
          ),
        )
        .toList(),
    onOpen: historyRuntime?.openHistoryDetail,
  );

  Widget _historyDetailScreen() {
    final id = projection.snapshotId;
    final entry = id == null
        ? null
        : historyRuntime?.historyProjection?.byId(id);
    if (entry == null) {
      return HistoryDetailScreenPreview(
        isNotFound: historyRuntime?.historyProjection != null,
      );
    }
    final tournament = entry.tournament;
    final cancelled = tournament.lifecycle == 'cancelled';
    return HistoryDetailScreenPreview(
      data: HistoryDetailViewData(
        title: tournament.title,
        subtitle: 'Immutable snapshot · ${entry.finishedAtUtc.toLocal()}',
        formatLabel: _formatLabel(tournament.formatId),
        participantCount: tournament.participants.length,
        matchCount: tournament.matches.length,
        isCancelled: cancelled,
        champion: tournament.championId == null
            ? null
            : _historyParticipant(tournament, tournament.championId!),
        cancellationReason: tournament.cancellationReason,
        standings: [
          for (final placement in tournament.ranking)
            StandingRowViewData(
              placeLabel: placement.from == placement.to
                  ? '${placement.from}'
                  : '${placement.from}–${placement.to}',
              participant: _historyParticipant(
                tournament,
                placement.participantId,
              ),
              resultLabel: placement.from == 1 ? 'Чемпион' : 'Итоговое место',
            ),
        ],
        structure: cancelled ? null : _historyStructure(tournament),
      ),
    );
  }

  ProfileStatisticsViewData? get _profileStatistics {
    final statistics = historyRuntime?.historyProjection?.statistics;
    return statistics == null
        ? null
        : ProfileStatisticsViewData(
            tournaments: statistics.tournamentCount,
            victories: statistics.tournamentWins,
            tournamentWinRate: statistics.tournamentWinRate,
            normalMatches: statistics.normalMatchCount,
            normalMatchWins: statistics.normalMatchWins,
            normalMatchWinRate: statistics.normalMatchWinRate,
            bestPlace: statistics.bestPlace,
          );
  }

  Widget _mainScreen() {
    final session = hostRuntime?.hostTournamentProjection;
    final matchup = session == null ? null : _mainMatchup(session);
    final last = historyRuntime?.historyProjection?.entries.firstOrNull;
    return MainScreenPreview(
      activeTournamentName: session?.title,
      activeStage: session?.lifecycle,
      onContinue: session == null ? null : hostRuntime?.continueTournament,
      activeFirst: matchup == null ? previewIvan : _participant(matchup.$1),
      activeSecond: matchup == null ? previewMira : _participant(matchup.$2),
      showMatchupSummary: session == null || matchup != null,
      lastTournament: last == null
          ? null
          : MainLastTournamentViewData(
              id: last.tournament.id,
              title: last.tournament.title,
              summary:
                  '${_formatLabel(last.tournament.formatId)} · ${last.tournament.participants.length} участников · ${last.finishedAtUtc.toLocal()}',
              isCancelled: last.tournament.lifecycle == 'cancelled',
              champion: last.tournament.championId == null
                  ? null
                  : _historyParticipant(
                      last.tournament,
                      last.tournament.championId!,
                    ),
            ),
      onOpenLastTournament: historyRuntime?.openHistoryDetail,
      onCreate: hostRuntime == null
          ? null
          : () => hostRuntime!.createTournament(),
    );
  }

  Widget _draftScreen() => HostDraftScreenPreview(
    title: _session.title,
    formatId: _session.formatId,
    onSave: ({required title, required formatId}) =>
        hostRuntime!.updateDraft(title: title, formatId: formatId),
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
    spectatorProjection: _spectatorConnection,
    onCopySpectatorAddress: _spectatorEndpoint == null
        ? null
        : () => Clipboard.setData(ClipboardData(text: _spectatorEndpoint!)),
    onRetrySpectator: hostRuntime?.retrySpectatorServer,
  );

  String? get _spectatorEndpoint {
    final state = hostRuntime!.spectatorServerState;
    return state.endpoint?.toString();
  }

  HostOpenConnectionViewData get _spectatorConnection {
    final state = hostRuntime!.spectatorServerState;
    return switch (state.status) {
      SpectatorServerStatus.stopped => const HostOpenConnectionViewData(
        state: ConnectionQrState.unavailable,
        connectedSpectators: 0,
        statusLabel: 'Зрительский экран остановлен',
        detail: 'Запустите сервер повторно',
        kind: StatusKind.neutral,
      ),
      SpectatorServerStatus.starting => HostOpenConnectionViewData(
        state: ConnectionQrState.starting,
        connectedSpectators: state.connectedSpectators,
        statusLabel: 'Зрительский экран запускается',
        detail: 'Подготавливаем локальный адрес',
        kind: StatusKind.info,
      ),
      SpectatorServerStatus.serving => HostOpenConnectionViewData(
        state: ConnectionQrState.ready,
        connectedSpectators: state.connectedSpectators,
        statusLabel: 'Зрительский экран доступен',
        detail:
            '${state.connectedSpectators} подключено · QR открывается по кнопке',
        kind: StatusKind.success,
        localEndpoint: state.endpoint?.toString(),
      ),
      SpectatorServerStatus.degraded => HostOpenConnectionViewData(
        state: _spectatorEndpoint == null
            ? ConnectionQrState.unavailable
            : ConnectionQrState.stale,
        connectedSpectators: state.connectedSpectators,
        statusLabel: 'Зрительский экран ограничен',
        detail: _spectatorErrorLabel(state.safeErrorCode),
        kind: StatusKind.warning,
        localEndpoint: _spectatorEndpoint,
      ),
      SpectatorServerStatus.failed => HostOpenConnectionViewData(
        state: ConnectionQrState.error,
        connectedSpectators: state.connectedSpectators,
        statusLabel: 'Зрительский экран недоступен',
        detail: _spectatorErrorLabel(state.safeErrorCode),
        kind: StatusKind.danger,
      ),
    };
  }

  String _spectatorErrorLabel(String? code) => switch (code) {
    'STATIC_BUNDLE_MISSING' => 'Web-интерфейс ещё не собран',
    'LAN_ADDRESS_UNAVAILABLE' => 'Нет доступного адреса локальной сети',
    'PROJECTION_TOO_LARGE' => 'Данные турнира превышают безопасный лимит',
    _ => 'Проверьте локальную сеть и повторите запуск',
  };

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

  PreviewParticipant _historyParticipant(
    HostTournamentProjection tournament,
    String participantId,
  ) {
    final participant = tournament.participants.singleWhere(
      (value) => value.id == participantId,
    );
    return PreviewParticipant(
      nickname: participant.nickname,
      fighterId: participant.fighterId ?? 'unknown',
      fighterName: participant.fighterName ?? 'Боец не назначен',
      isGuest: participant.isGuest,
    );
  }

  BracketViewData _historyStructure(HostTournamentProjection state) =>
      BracketViewData(
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
              first: _historyParticipant(state, match.firstParticipantId),
              second: _historyParticipant(state, match.secondParticipantId),
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
