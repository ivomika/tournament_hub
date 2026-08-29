import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/screen_registry.dart';

void main() {
  final focusMap = <ScreenPreviewKind, Finder Function()>{
    ScreenPreviewKind.main: () => find.byType(TournamentSummary),
    ScreenPreviewKind.hostDraft: () => find.text('Параметры'),
    ScreenPreviewKind.hostOpen: () => find.text('Участники'),
    ScreenPreviewKind.hostDistribution: () => find.text('Назначения'),
    ScreenPreviewKind.hostRunning: () => find.byType(TournamentMatchCard).first,
    ScreenPreviewKind.hostResultEntry: () => find.byType(OutcomePicker),
    ScreenPreviewKind.hostFinished: () => find.byType(ChampionHero),
    ScreenPreviewKind.hostCancelled: () => find.text('Турнир не состоялся'),
    ScreenPreviewKind.history: () => find.byType(HistorySnapshotCard).first,
    ScreenPreviewKind.historyDetail: () => find.byType(ChampionHero),
    ScreenPreviewKind.profile: () => find.byType(ProfileSummary),
    ScreenPreviewKind.join: () => find.byType(ParticipantJoinPanel),
    ScreenPreviewKind.participantLobby: () => find.text('Вы в турнире'),
    ScreenPreviewKind.participantDistribution: () =>
        find.byType(ParticipantIdentity).first,
    ScreenPreviewKind.participantRunning: () =>
        find.byType(TournamentMatchCard).first,
    ScreenPreviewKind.participantFinished: () => find.byType(ChampionHero),
    ScreenPreviewKind.recoverableError: () =>
        find.text('Не удалось загрузить турнир'),
  };

  for (final entry in focusMap.entries) {
    testWidgets(
      '${entry.key.name}: dominant object находится в первом viewport',
      (tester) async {
        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = const Size(390, 844);
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          MaterialApp(
            theme: TournamentTheme.dark,
            home: TournamentScreenPreview(kind: entry.key),
          ),
        );
        await tester.pumpAndSettle();

        final dominant = entry.value();
        expect(dominant, findsOneWidget);
        expect(
          tester.getTopLeft(dominant).dy,
          lessThan(560),
          reason: '${entry.key.name}: главный объект слишком далеко от начала',
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('Host Open ставит roster выше participant QR', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: const TournamentScreenPreview(kind: ScreenPreviewKind.hostOpen),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      tester.getTopLeft(find.text('Участники')).dy,
      lessThan(tester.getTopLeft(find.byType(ParticipantInviteCard)).dy),
    );
  });

  testWidgets(
    'Participant показывает спортивный объект выше freshness banner',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: const TournamentScreenPreview(
            kind: ScreenPreviewKind.participantRunning,
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.byType(TournamentMatchCard).first).dy,
        lessThan(tester.getTopLeft(find.byType(ConnectionBanner)).dy),
      );
    },
  );
}
