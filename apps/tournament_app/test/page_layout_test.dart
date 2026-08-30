import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/host_open/host_open_screen.dart';
import 'package:tournament_hub_app/presentation/screens/join/join_screen.dart';
import 'package:tournament_hub_app/presentation/screens/participant_finished/participant_finished_screen.dart';
import 'package:tournament_hub_app/presentation/screens/participant_lobby/participant_lobby_screen.dart';
import 'package:tournament_hub_app/presentation/screens/participant_running/participant_running_screen.dart';
import 'package:tournament_hub_app/presentation/screens/registration/registration_screen.dart';

void main() {
  testWidgets('compact сохраняет порядок primary, secondary, supporting', (
    tester,
  ) async {
    await _pumpLayout(tester, width: 600, preset: PageLayoutPreset.workspace);

    final primary = find.byKey(const Key('page-layout-primary'));
    final secondary = find.byKey(const Key('page-layout-secondary'));
    final supporting = find.byKey(const Key('page-layout-supporting'));

    expect(
      tester.getTopLeft(primary).dy,
      lessThan(tester.getTopLeft(secondary).dy),
    );
    expect(
      tester.getTopLeft(secondary).dy,
      lessThan(tester.getTopLeft(supporting).dy),
    );
    expect(tester.getSize(primary).width, tester.getSize(secondary).width);
  });

  for (final entry in const <PageLayoutPreset, double>{
    PageLayoutPreset.split: 2,
    PageLayoutPreset.workspace: 1.5,
    PageLayoutPreset.archive: 3,
    PageLayoutPreset.hero: 2,
    PageLayoutPreset.flow: 2,
  }.entries) {
    testWidgets('${entry.key.name} использует semantic expanded ratio', (
      tester,
    ) async {
      await _pumpLayout(tester, width: 1200, preset: entry.key);

      final primaryWidth = tester
          .getSize(find.byKey(const Key('page-layout-primary')))
          .width;
      final secondaryWidth = tester
          .getSize(find.byKey(const Key('page-layout-secondary')))
          .width;

      expect(
        primaryWidth / secondaryWidth,
        moreOrLessEquals(entry.value, epsilon: 0.05),
      );
      expect(
        tester.getSize(find.byKey(const Key('page-layout-supporting'))).width,
        greaterThan(primaryWidth),
      );
    });
  }

  testWidgets('focused ограничивает readable width без secondary rail', (
    tester,
  ) async {
    await _pumpLayout(tester, width: 1200, preset: PageLayoutPreset.focused);

    expect(find.byKey(const Key('page-layout-secondary')), findsNothing);
    expect(
      tester.getSize(find.byKey(const Key('page-layout-primary'))).width,
      lessThanOrEqualTo(599),
    );
    expect(
      tester.getTopLeft(find.byKey(const Key('page-layout-primary'))).dx,
      0,
    );
  });

  testWidgets(
    'flow поддерживает primary без secondary и продолжает supporting',
    (tester) async {
      await _pumpLayout(
        tester,
        width: 1200,
        preset: PageLayoutPreset.flow,
        includeSecondary: false,
      );

      final primary = find.byKey(const Key('page-layout-primary'));
      final supporting = find.byKey(const Key('page-layout-supporting'));

      expect(find.byKey(const Key('page-layout-secondary')), findsNothing);
      expect(tester.getSize(primary).width, tester.getSize(supporting).width);
      expect(
        tester.getTopLeft(primary).dy,
        lessThan(tester.getTopLeft(supporting).dy),
      );
    },
  );

  testWidgets('экраны используют PageLayout как page-level композицию', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    for (final size in const [Size(390, 844), Size(1280, 960)]) {
      for (final scenario in const [
        (screen: HostOpenScreenPreview(), preset: PageLayoutPreset.flow),
        (
          screen: ParticipantRunningScreenPreview(),
          preset: PageLayoutPreset.flow,
        ),
        (
          screen: ParticipantFinishedScreenPreview(),
          preset: PageLayoutPreset.flow,
        ),
        (
          screen: ParticipantLobbyScreenPreview(),
          preset: PageLayoutPreset.flow,
        ),
        (
          screen: RegistrationScreenPreview(),
          preset: PageLayoutPreset.workspace,
        ),
        (screen: JoinScreenPreview(), preset: PageLayoutPreset.workspace),
      ]) {
        tester.view.physicalSize = size;
        await tester.pumpWidget(
          MaterialApp(theme: TournamentTheme.dark, home: scenario.screen),
        );
        await tester.pumpAndSettle();

        final layout = tester.widget<PageLayout>(find.byType(PageLayout));
        expect(layout.preset, scenario.preset);
        expect(find.byType(AdaptiveSplit), findsNothing);
        expect(tester.takeException(), isNull);
      }
    }
  });
}

Future<void> _pumpLayout(
  WidgetTester tester, {
  required double width,
  required PageLayoutPreset preset,
  bool includeSecondary = true,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, 900);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });

  await tester.pumpWidget(
    MaterialApp(
      theme: TournamentTheme.dark,
      home: Scaffold(
        body: PageLayout(
          preset: preset,
          primary: const SizedBox(height: 80),
          secondary: preset == PageLayoutPreset.focused || !includeSecondary
              ? null
              : const SizedBox(height: 80),
          supporting: const SizedBox(height: 80),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull);
}
