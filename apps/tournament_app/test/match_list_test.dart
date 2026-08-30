import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';

void main() {
  testWidgets('показывает три последних completed и раскрывает старые', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            child: MatchList(data: _completedData(5), completedPreviewCount: 3),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Матч 01'), findsNothing);
    expect(find.text('Матч 02'), findsNothing);
    expect(find.text('Матч 03'), findsOneWidget);
    expect(find.text('Матч 05'), findsOneWidget);
    expect(find.text('Показать ещё (2)'), findsOneWidget);

    await tester.tap(find.text('Показать ещё (2)'));
    await tester.pumpAndSettle();

    expect(find.text('Матч 01'), findsOneWidget);
    expect(find.text('Матч 02'), findsOneWidget);
    expect(find.text('Матч 05'), findsOneWidget);
    expect(find.text('Скрыть старые матчи'), findsOneWidget);
  });

  testWidgets('current и upcoming не сворачиваются', (tester) async {
    final data = BracketViewData(
      format: TournamentStructureFormat.doubleElimination,
      matches: [
        _match(1, BracketMatchState.current),
        _match(2, BracketMatchState.pending),
        ..._completedData(4).matches,
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: Scaffold(
          body: SingleChildScrollView(
            child: MatchList(data: data, completedPreviewCount: 3),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.byKey(const ValueKey('match-list-phase-current')),
      findsOneWidget,
    );
    expect(
      find.byKey(const ValueKey('match-list-phase-upcoming')),
      findsOneWidget,
    );
    expect(find.text('Матч 01'), findsOneWidget);
    expect(find.text('Матч 02'), findsNWidgets(2));
    expect(find.text('Показать ещё (1)'), findsOneWidget);
  });
}

BracketViewData _completedData(int count) => BracketViewData(
  format: TournamentStructureFormat.doubleElimination,
  matches: [
    for (var index = 1; index <= count; index++)
      _match(index, BracketMatchState.won),
  ],
);

BracketMatchViewData _match(
  int index,
  BracketMatchState state,
) => BracketMatchViewData(
  id: 'match-$index-${state.name}',
  title: 'Матч ${index.toString().padLeft(2, '0')}',
  lane: BracketLane.winners,
  round: 1,
  order: index,
  first: previewParticipants.first,
  second: previewParticipants[1],
  state: state,
  resultLabel: state == BracketMatchState.won
      ? 'Победитель: ${previewParticipants.first.fighterName} · ${previewParticipants.first.nickname}'
      : null,
);
