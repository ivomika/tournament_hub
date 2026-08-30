import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/history/history_screen.dart';
import 'package:tournament_hub_app/presentation/screens/history_detail/history_detail_screen.dart';
import 'package:tournament_hub_app/presentation/screens/profile/profile_screen.dart';
import 'package:tournament_hub_app/presentation/screens/settings/settings_screen.dart';

void main() {
  testWidgets('cancelled history не показывает выдуманного победителя', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        const HistoryDetailScreenPreview(
          data: HistoryDetailViewData(
            title: 'Cancelled Cup',
            subtitle: 'Immutable snapshot',
            formatLabel: 'Round Robin',
            participantCount: 2,
            matchCount: 0,
            isCancelled: true,
            standings: [],
            cancellationReason: 'Организатор отменил',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Организатор отменил'), findsOneWidget);
    expect(find.text('Победитель'), findsNothing);
    expect(find.byType(TournamentStandings), findsNothing);
  });

  testWidgets('history empty state и derived statistics отображаются', (
    tester,
  ) async {
    await tester.pumpWidget(_app(const HistoryScreenPreview(entries: [])));
    await tester.pumpAndSettle();
    expect(find.text('История пуста'), findsOneWidget);

    await tester.pumpWidget(
      _app(
        const ProfileScreenPreview(
          statistics: ProfileStatisticsViewData(
            tournaments: 2,
            victories: 1,
            tournamentWinRate: .5,
            normalMatches: 4,
            normalMatchWins: 3,
            normalMatchWinRate: .75,
            bestPlace: 1,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('3 из 4 · 75%'), findsOneWidget);
  });

  testWidgets('clear history требует confirmation', (tester) async {
    var cleared = false;
    await tester.pumpWidget(
      _app(SettingsScreenPreview(onClearHistory: () async => cleared = true)),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Очистить историю').first);
    await tester.tap(find.text('Очистить историю').first);
    await tester.pumpAndSettle();
    expect(cleared, isFalse);

    await tester.tap(find.text('Очистить историю').last);
    await tester.pumpAndSettle();
    expect(cleared, isTrue);
  });
}

Widget _app(Widget child) =>
    MaterialApp(theme: TournamentTheme.dark, home: child);
