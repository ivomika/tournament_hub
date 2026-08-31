import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';

void main() {
  testWidgets('assignment grid keeps participant order across width classes', (
    tester,
  ) async {
    await _pumpGrid(tester, width: 1100);

    final positions = [
      for (var index = 0; index < previewParticipants.length; index++)
        tester.getTopLeft(
          find.byKey(
            ValueKey(
              'assignment-${previewParticipants[index].nickname}-$index',
            ),
          ),
        ),
    ];

    expect(positions[0].dy, positions[1].dy);
    expect(positions[1].dy, positions[2].dy);
    expect(positions[3].dy, greaterThan(positions[0].dy));
    expect(positions[0].dx, lessThan(positions[1].dx));
    expect(positions[1].dx, lessThan(positions[2].dx));
  });

  testWidgets('assignment grid uses one column on compact width', (
    tester,
  ) async {
    await _pumpGrid(tester, width: 420);

    final positions = [
      for (var index = 0; index < previewParticipants.length; index++)
        tester.getTopLeft(
          find.byKey(
            ValueKey(
              'assignment-${previewParticipants[index].nickname}-$index',
            ),
          ),
        ),
    ];

    expect(positions.map((position) => position.dx).toSet(), hasLength(1));
    expect(positions[0].dy, lessThan(positions[1].dy));
    expect(positions[1].dy, lessThan(positions[2].dy));
  });

  testWidgets('long assignment identity survives 200 percent text scale', (
    tester,
  ) async {
    const participant = PreviewParticipant(
      nickname: 'Очень длинное имя гостевого участника турнира',
      fighterId: 'scorpion',
      fighterName: 'Scorpion с очень длинным именем персонажа',
      isGuest: true,
    );
    await _pumpGrid(
      tester,
      width: 620,
      textScaler: const TextScaler.linear(2),
      participants: const [participant, previewMira],
    );

    expect(tester.takeException(), isNull);
    expect(
      find.bySemanticsLabel(RegExp('Scorpion.*Очень длинное.*Гость')),
      findsOneWidget,
    );
  });

  testWidgets('assignment grid exposes explicit non-data states', (
    tester,
  ) async {
    await _pumpGrid(tester, width: 420, participants: const []);
    expect(find.text('Назначений пока нет'), findsOneWidget);

    await _pumpGrid(
      tester,
      width: 420,
      state: ParticipantAssignmentGridState.loading,
    );
    expect(find.text('Назначаем персонажей'), findsOneWidget);

    await _pumpGrid(
      tester,
      width: 420,
      state: ParticipantAssignmentGridState.error,
    );
    expect(find.text('Не удалось показать назначения'), findsOneWidget);
  });
}

Future<void> _pumpGrid(
  WidgetTester tester, {
  required double width,
  TextScaler textScaler = TextScaler.noScaling,
  List<PreviewParticipant> participants = previewParticipants,
  ParticipantAssignmentGridState state = ParticipantAssignmentGridState.data,
}) async {
  tester.view.physicalSize = Size(width + 100, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
  await tester.pumpWidget(
    MaterialApp(
      theme: TournamentTheme.dark,
      home: MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: width,
              child: ParticipantAssignmentGrid(
                participants: participants,
                state: state,
              ),
            ),
          ),
        ),
      ),
    ),
  );
}
