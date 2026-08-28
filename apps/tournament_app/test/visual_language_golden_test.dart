import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/host_finished/host_finished_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_result_entry/host_result_entry_screen.dart';
import 'package:tournament_hub_app/presentation/screens/host_running/host_running_screen.dart';
import 'package:tournament_hub_app/presentation/screens/main/main_screen.dart';

void main() {
  final screens = <String, Widget>{
    'main': const MainScreenPreview(),
    'host_running': const HostRunningScreenPreview(),
    'host_result_entry': const HostResultEntryScreenPreview(),
    'host_finished': const HostFinishedScreenPreview(),
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
        await tester.pumpAndSettle();

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
