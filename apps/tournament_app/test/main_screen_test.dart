import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/main/main_screen.dart';

void main() {
  testWidgets('Main сохраняет continue и использует одну карточку создания', (
    tester,
  ) async {
    var continued = false;
    var created = false;

    await tester.pumpWidget(
      _app(
        MainScreenPreview(
          onContinue: () => continued = true,
          onCreate: () => created = true,
        ),
      ),
    );

    expect(find.text('Продолжить турнир'), findsOneWidget);
    expect(find.text('Создать турнир'), findsOneWidget);
    expect(find.textContaining('Создать Double Elimination'), findsNothing);
    expect(find.textContaining('Создать Single Elimination'), findsNothing);
    expect(find.textContaining('Создать Round Robin'), findsNothing);

    await tester.ensureVisible(find.text('Продолжить турнир'));
    await tester.tap(find.text('Продолжить турнир'));
    expect(continued, isTrue);

    final create = tester.widget<DsAction>(
      find.widgetWithText(DsAction, 'Создать турнир'),
    );
    expect(create.onPressed, isNull);
    expect(created, isFalse);
  });

  testWidgets('Main открывает последний турнир и показывает empty state', (
    tester,
  ) async {
    String? openedId;
    await tester.pumpWidget(
      _app(
        MainScreenPreview(
          activeTournamentName: null,
          lastTournament: previewLastTournament,
          onOpenLastTournament: (id) => openedId = id,
        ),
      ),
    );

    await tester.tap(find.byType(HistorySnapshotCard));
    expect(openedId, previewLastTournament.id);

    await tester.pumpWidget(
      _app(
        const MainScreenPreview(
          activeTournamentName: null,
          lastTournament: null,
        ),
      ),
    );
    expect(find.text('История пуста'), findsOneWidget);
  });
}

Widget _app(Widget child) => MaterialApp(
  theme: TournamentTheme.dark,
  home: MediaQuery(
    data: const MediaQueryData(size: Size(1200, 900)),
    child: child,
  ),
);
