import 'package:flutter/widgets.dart';

import 'bootstrap/bootstrap_screen.dart';
import 'history/history_screen.dart';
import 'history_detail/history_detail_screen.dart';
import 'host_cancelled/host_cancelled_screen.dart';
import 'host_distribution/host_distribution_screen.dart';
import 'host_draft/host_draft_screen.dart';
import 'host_finished/host_finished_screen.dart';
import 'host_open/host_open_screen.dart';
import 'host_result_entry/host_result_entry_screen.dart';
import 'host_running/host_running_screen.dart';
import 'join/join_screen.dart';
import 'main/main_screen.dart';
import 'participant_distribution/participant_distribution_screen.dart';
import 'participant_finished/participant_finished_screen.dart';
import 'participant_lobby/participant_lobby_screen.dart';
import 'participant_running/participant_running_screen.dart';
import 'profile/profile_screen.dart';
import 'recoverable_error/recoverable_error_screen.dart';
import 'registration/registration_screen.dart';
import 'settings/settings_screen.dart';

enum ScreenPreviewKind {
  bootstrap('Bootstrap'),
  registration('Registration'),
  main('Main'),
  profile('Profile'),
  history('History'),
  historyDetail('History detail'),
  settings('Settings'),
  hostDraft('Host / Draft'),
  hostOpen('Host / Open'),
  hostDistribution('Host / Distribution'),
  hostRunning('Host / Running'),
  hostResultEntry('Host / Result entry'),
  hostFinished('Host / Finished'),
  hostCancelled('Host / Cancelled'),
  join('Participant / Join'),
  participantLobby('Participant / Lobby'),
  participantDistribution('Participant / Distribution'),
  participantRunning('Participant / Running'),
  participantFinished('Participant / Finished'),
  recoverableError('Recoverable error');

  const ScreenPreviewKind(this.catalogName);

  final String catalogName;
}

class TournamentScreenPreview extends StatelessWidget {
  const TournamentScreenPreview({required this.kind, super.key});

  final ScreenPreviewKind kind;

  @override
  Widget build(BuildContext context) => switch (kind) {
    ScreenPreviewKind.bootstrap => const BootstrapScreenPreview(),
    ScreenPreviewKind.registration => const RegistrationScreenPreview(),
    ScreenPreviewKind.main => const MainScreenPreview(),
    ScreenPreviewKind.profile => const ProfileScreenPreview(),
    ScreenPreviewKind.history => const HistoryScreenPreview(),
    ScreenPreviewKind.historyDetail => const HistoryDetailScreenPreview(),
    ScreenPreviewKind.settings => const SettingsScreenPreview(),
    ScreenPreviewKind.hostDraft => const HostDraftScreenPreview(),
    ScreenPreviewKind.hostOpen => const HostOpenScreenPreview(),
    ScreenPreviewKind.hostDistribution => const HostDistributionScreenPreview(),
    ScreenPreviewKind.hostRunning => const HostRunningScreenPreview(),
    ScreenPreviewKind.hostResultEntry => const HostResultEntryScreenPreview(),
    ScreenPreviewKind.hostFinished => const HostFinishedScreenPreview(),
    ScreenPreviewKind.hostCancelled => const HostCancelledScreenPreview(),
    ScreenPreviewKind.join => const JoinScreenPreview(),
    ScreenPreviewKind.participantLobby => const ParticipantLobbyScreenPreview(),
    ScreenPreviewKind.participantDistribution =>
      const ParticipantDistributionScreenPreview(),
    ScreenPreviewKind.participantRunning =>
      const ParticipantRunningScreenPreview(),
    ScreenPreviewKind.participantFinished =>
      const ParticipantFinishedScreenPreview(),
    ScreenPreviewKind.recoverableError => const RecoverableErrorScreenPreview(),
  };
}
