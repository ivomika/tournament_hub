import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/domain/domain.dart';

final class TestFormatSettings extends TournamentFormatSettings {
  const TestFormatSettings(super.formatId);
}

void main() {
  final formatId = TournamentFormatId('single_elimination');
  final formatKey = TournamentFormatKey(
    id: formatId,
    rulesetVersion: RulesetVersion('1'),
  );

  Tournament draft() => Tournament.draft(
    id: TournamentId('tournament-1'),
    title: TournamentTitle('Домашний турнир'),
    gameId: GameId('mk11'),
    rosterVersion: '1',
    formatKey: formatKey,
    formatSettings: TestFormatSettings(formatId),
    createdAtUtc: DateTime.utc(2026),
  );

  test('Draft открывается и увеличивает revision', () {
    final tournament = draft();

    final opened = tournament.open(changedAtUtc: DateTime.utc(2026, 1, 2));

    expect(opened.lifecycle, TournamentLifecycle.open);
    expect(opened.revision, 1);
  });

  test('Distribution требует минимум двух Participant', () {
    final opened = draft().open(changedAtUtc: DateTime.utc(2026, 1, 2));

    expect(
      () => opened.beginDistribution(changedAtUtc: DateTime.utc(2026, 1, 3)),
      throwsStateError,
    );
  });
}
