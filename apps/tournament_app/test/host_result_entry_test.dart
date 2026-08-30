import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/host_result_entry/host_result_entry_screen.dart';

void main() {
  testWidgets('FT2 позволяет зафиксировать фактический счёт серии', (
    tester,
  ) async {
    int? selectedScore;
    await tester.pumpWidget(
      MaterialApp(
        theme: TournamentTheme.dark,
        home: HostResultEntryScreenPreview(
          firstTo: 2,
          onFirstScoreSelected: (value) => selectedScore = value,
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.ensureVisible(find.text('Победил Scorpion · 2:1'));
    await tester.tap(find.text('Победил Scorpion · 2:1'));

    expect(selectedScore, 1);
  });
}
