import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/bootstrap/bootstrap_screen.dart';
import 'package:tournament_hub_app/presentation/screens/history/history_screen.dart';
import 'package:tournament_hub_app/presentation/screens/history_detail/history_detail_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_finished/host_finished_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_cancelled/host_cancelled_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_distribution/host_distribution_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_draft/host_draft_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_open/host_open_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_result_entry/host_result_entry_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_running/host_running_screen.dart';
import 'package:tournament_hub_app/presentation/screens/join/join_screen.dart';
import 'package:tournament_hub_app/presentation/screens/main/main_screen.dart';
import 'package:tournament_hub_app/presentation/screens/participant_distribution/participant_distribution_screen.dart';
import 'package:tournament_hub_app/presentation/screens/participant_finished/participant_finished_screen.dart';
import 'package:tournament_hub_app/presentation/screens/participant_lobby/participant_lobby_screen.dart';
import 'package:tournament_hub_app/presentation/screens/participant_running/participant_running_screen.dart';
import 'package:tournament_hub_app/presentation/screens/profile/profile_screen.dart';
import 'package:tournament_hub_app/presentation/screens/registration/registration_screen.dart';
import 'package:tournament_hub_app/presentation/screens/recoverable_error/recoverable_error_screen.dart';
import 'package:tournament_hub_app/presentation/screens/settings/settings_screen.dart';

void main() {
  final screens = <String, Widget>{
    'bootstrap': const BootstrapScreenPreview(),
    'registration': const RegistrationScreenPreview(),
    'main': const MainScreenPreview(),
    'profile': const ProfileScreenPreview(),
    'history': const HistoryScreenPreview(),
    'history_detail': const HistoryDetailScreenPreview(),
    'settings': const SettingsScreenPreview(),
    'host_draft': const HostDraftScreenPreview(),
    'host_open': const HostOpenScreenPreview(),
    'host_distribution': const HostDistributionScreenPreview(),
    'host_running': const HostRunningScreenPreview(),
    'host_result_entry': const HostResultEntryScreenPreview(),
    'host_finished': const HostFinishedScreenPreview(),
    'host_cancelled': const HostCancelledScreenPreview(),
    'join': const JoinScreenPreview(),
    'participant_lobby': const ParticipantLobbyScreenPreview(),
    'participant_distribution': const ParticipantDistributionScreenPreview(),
    'participant_running': const ParticipantRunningScreenPreview(),
    'participant_finished': const ParticipantFinishedScreenPreview(),
    'recoverable_error': const RecoverableErrorScreenPreview(),
  };

  for (final viewport in const [
    (name: 'mobile', size: Size(390, 844)),
    (name: 'desktop', size: Size(1280, 960)),
  ]) {
    for (final entry in screens.entries) {
      testWidgets('${entry.key} сохраняет ${viewport.name} visual contract', (
        tester,
      ) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = viewport.size;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: TournamentTheme.dark,
            home: entry.value,
          ),
        );
        if (entry.key == 'bootstrap') {
          await tester.pump();
        } else {
          await tester.pumpAndSettle();
        }

        expect(tester.takeException(), isNull);
        await expectLater(
          find.byType(MaterialApp),
          matchesGoldenFile(
            'goldens/visual_language/${entry.key}_${viewport.name}.png',
          ),
        );
      });
    }
  }
}
