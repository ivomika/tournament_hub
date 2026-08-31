import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';

void main() {
  const rows = [
    StandingRowViewData(
      placeLabel: '1',
      participant: previewIvan,
      resultLabel: 'Чемпион',
    ),
    StandingRowViewData(
      placeLabel: '3–4',
      participant: previewGuest,
      resultLabel: 'Диапазон места',
    ),
    StandingRowViewData(
      placeLabel: '10–11',
      participant: PreviewParticipant(
        nickname: 'Очень длинное имя гостевого участника',
        fighterId: 'raiden',
        fighterName: 'Raiden',
        isGuest: true,
      ),
      resultLabel: 'Итоговое место подтверждено',
    ),
  ];

  for (final size in const [Size(390, 1800), Size(1280, 1000)]) {
    testWidgets('place labels stay atomic at 200 percent on $size', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        MaterialApp(
          theme: TournamentTheme.dark,
          home: const MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(2)),
            child: Scaffold(
              body: SingleChildScrollView(
                child: TournamentStandings(rows: rows),
              ),
            ),
          ),
        ),
      );
      await tester.pump();

      for (final label in const ['1', '3–4', '10–11']) {
        expect(find.text(label), findsOneWidget);
        expect(tester.widget<Text>(find.text(label)).maxLines, 1);
      }
      if (size.width >= 600) {
        expect(tester.widget<Text>(find.text('МЕСТО')).maxLines, 1);
      }
      expect(
        find.bySemanticsLabel(RegExp('Место 10–11.*Raiden.*Очень длинное')),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });
  }
}
