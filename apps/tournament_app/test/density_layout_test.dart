import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/screen_registry.dart';

void main() {
  testWidgets('density roles меняют ритм, но сохраняют fighter identity', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 900);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                for (final density in DsDensity.values)
                  HistorySnapshotCard(
                    key: Key('density-${density.name}'),
                    density: density,
                    tournamentName: 'Friday Fight Night',
                    summary: 'Double Elimination · 8 участников',
                    champion: previewParticipants.first,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final compact = tester
        .getSize(find.byKey(const Key('density-compact')))
        .height;
    final comfortable = tester
        .getSize(find.byKey(const Key('density-comfortable')))
        .height;
    final presentation = tester
        .getSize(find.byKey(const Key('density-presentation')))
        .height;
    expect(compact, lessThan(comfortable));
    expect(comfortable, lessThan(presentation));
    expect(find.text('Scorpion'), findsNWidgets(3));
    expect(find.text('Иван'), findsNWidgets(3));
    expect(find.text('ЗАВЕРШЁН'), findsNWidgets(3));
  });

  testWidgets('archive screens используют archive preset и compact rows', (
    tester,
  ) async {
    await _pumpScreen(tester, ScreenPreviewKind.history);

    expect(
      tester.widget<PageLayout>(find.byType(PageLayout)).preset,
      PageLayoutPreset.archive,
    );
    expect(
      tester
          .widgetList<HistorySnapshotCard>(find.byType(HistorySnapshotCard))
          .every((card) => card.density == DsDensity.compact),
      isTrue,
    );

    await _pumpScreen(tester, ScreenPreviewKind.historyDetail);
    expect(find.byType(ChampionHero), findsNothing);
    expect(find.byType(ParticipantIdentity), findsWidgets);
    expect(find.byType(TournamentStandings), findsOneWidget);
  });

  testWidgets('short и read-only screens используют semantic composition', (
    tester,
  ) async {
    await _pumpScreen(tester, ScreenPreviewKind.profile);
    expect(
      tester.widget<PageLayout>(find.byType(PageLayout)).preset,
      PageLayoutPreset.focused,
    );

    await _pumpScreen(tester, ScreenPreviewKind.settings);
    expect(
      tester.widget<PageLayout>(find.byType(PageLayout)).preset,
      PageLayoutPreset.split,
    );

    await _pumpScreen(tester, ScreenPreviewKind.participantDistribution);
    final presentationSurface = tester
        .widgetList<DsSurface>(find.byType(DsSurface))
        .singleWhere((surface) => surface.density == DsDensity.presentation);
    expect(presentationSurface.tone, DsSurfaceTone.elevated);
    expect(find.byType(ActionDock), findsNothing);
  });
}

Future<void> _pumpScreen(WidgetTester tester, ScreenPreviewKind kind) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = const Size(1200, 900);
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    MaterialApp(
      theme: TournamentTheme.dark,
      home: TournamentScreenPreview(kind: kind),
    ),
  );
  await tester.pumpAndSettle();
  expect(tester.takeException(), isNull, reason: kind.name);
}
