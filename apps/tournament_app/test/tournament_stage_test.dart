import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/screen_registry.dart';

void main() {
  testWidgets('strip компактнее panel и сохраняет текстовый status', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const Scaffold(
          body: Column(
            children: [
              TournamentStageHeader(
                key: Key('panel'),
                stage: 'Турнир идёт',
                progress: 'МАТЧ 7 ИЗ 15',
                detail: 'Полный контекст.',
              ),
              TournamentStageHeader(
                key: Key('strip'),
                variant: TournamentStageVariant.strip,
                stage: 'Турнир идёт',
                progress: 'МАТЧ 7 ИЗ 15',
                detail: 'Компактный контекст.',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getSize(find.byKey(const Key('strip'))).height,
      lessThan(tester.getSize(find.byKey(const Key('panel'))).height),
    );
    final stripSurface = tester.widget<DsSurface>(
      find.descendant(
        of: find.byKey(const Key('strip')),
        matching: find.byType(DsSurface),
      ),
    );
    expect(stripSurface.tone, DsSurfaceTone.base);
    expect(find.text('МАТЧ 7 ИЗ 15'), findsNWidgets(2));
    expect(tester.takeException(), isNull);
  });

  for (final kind in const [
    ScreenPreviewKind.hostDraft,
    ScreenPreviewKind.hostOpen,
    ScreenPreviewKind.hostDistribution,
    ScreenPreviewKind.hostRunning,
    ScreenPreviewKind.hostResultEntry,
    ScreenPreviewKind.hostFinished,
    ScreenPreviewKind.hostCancelled,
    ScreenPreviewKind.participantLobby,
    ScreenPreviewKind.participantDistribution,
    ScreenPreviewKind.participantRunning,
    ScreenPreviewKind.participantFinished,
  ]) {
    testWidgets('${kind.name} использует compact stage context', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 844);
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

      final stages = tester.widgetList<TournamentStageHeader>(
        find.byType(TournamentStageHeader),
      );
      expect(stages, isNotEmpty);
      expect(
        stages.every((stage) => stage.variant == TournamentStageVariant.strip),
        isTrue,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
