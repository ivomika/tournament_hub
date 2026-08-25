import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/standings/domain/entities/match_points.dart';
import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/standings/domain/entities/standings_row.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_standings.dart';
import 'package:tournament_app/features/standings/domain/services/champion_selection_policy.dart';
import 'package:tournament_app/features/standings/domain/services/mvp_tournament_ruleset.dart';
import 'package:tournament_app/features/standings/domain/services/mvp_tournament_scoring_policy.dart';
import 'package:tournament_app/features/standings/domain/services/standard_standings_tie_break_policy.dart';
import 'package:tournament_app/features/standings/domain/services/standings_tie_break_policy.dart';
import 'package:tournament_app/features/standings/domain/services/tournament_ruleset.dart';
import 'package:tournament_app/features/standings/domain/services/tournament_scoring_policy.dart';
import 'package:tournament_app/features/standings/domain/services/tournament_standings_calculator.dart';
import 'package:tournament_app/features/standings/domain/services/unique_first_place_champion_policy.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/normal_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/entities/technical_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

void main() {
  test('начисляет очки для всех допустимых счётов', () {
    const policy = MvpTournamentScoringPolicy();
    final first = TournamentParticipantId('first');

    for (final entry in const [
      (2, 0, 3, 0),
      (2, 1, 2, 1),
      (1, 2, 1, 2),
      (0, 2, 0, 3),
    ]) {
      expect(
        policy.pointsFor(
          NormalMatchResult(
            winnerId: first,
            firstParticipantScore: entry.$1,
            secondParticipantScore: entry.$2,
          ),
        ),
        MatchPoints(first: entry.$3, second: entry.$4),
      );
    }
  });

  test('начисляет за technical 2:0 те же очки, сохраняя тип результата', () {
    const policy = MvpTournamentScoringPolicy();
    final first = TournamentParticipantId('first');
    final result = TechnicalMatchResult(
      winnerId: first,
      firstParticipantScore: 2,
      secondParticipantScore: 0,
    );

    expect(policy.pointsFor(result), const MatchPoints(first: 3, second: 0));
    expect(result, isA<TechnicalMatchResult>());
  });

  test('не завершает турнир, пока остались матчи без результата', () {
    final outcome = MvpTournamentRuleset.instance.calculate(
      _activeTournament(),
    );

    expect(outcome.canFinish, isFalse);
    expect(outcome.championId, isNull);
    expect(outcome.standings.completedMatchCount, 0);
  });

  test('finished snapshot отклоняет итог от незавершённых матчей', () {
    final incomplete = _activeTournament();
    final ids = incomplete.draft.participants.map((item) => item.id).toList();
    final completed = _completeByStrength(incomplete, ids);
    final completedOutcome = MvpTournamentRuleset.instance.calculate(completed);

    expect(
      () => FinishedTournamentSnapshot(
        tournament: incomplete,
        outcome: completedOutcome,
      ),
      throwsA(isA<TournamentValidationException>()),
    );
  });

  test('строит уникальную таблицу и выбирает чемпиона', () {
    var tournament = _activeTournament();
    final ids = tournament.draft.participants.map((item) => item.id).toList();
    tournament = _completeByStrength(tournament, ids);

    final outcome = MvpTournamentRuleset.instance.calculate(tournament);

    expect(outcome.canFinish, isTrue);
    expect(outcome.championId, ids[0]);
    expect(outcome.standings.rows.map((row) => row.position), [1, 2, 3]);
    expect(outcome.standings.rows.map((row) => row.points), [6, 3, 0]);
  });

  test('не выбирает чемпиона при неразрешимом равенстве', () {
    var tournament = _activeTournament();
    final ids = tournament.draft.participants.map((item) => item.id).toList();
    final winners = <String, TournamentParticipantId>{
      _pair(ids[0], ids[1]): ids[0],
      _pair(ids[1], ids[2]): ids[1],
      _pair(ids[0], ids[2]): ids[2],
    };
    for (final match in tournament.matches.toList()) {
      final winner =
          winners[_pair(
            match.scheduledMatch.firstParticipantId,
            match.scheduledMatch.secondParticipantId,
          )]!;
      tournament = tournament.replaceMatch(
        match.correctResult(
          boutWinners: [winner, winner],
          updateId: MatchUpdateId('result-${match.scheduledMatch.id.value}'),
        ),
      );
    }

    final outcome = MvpTournamentRuleset.instance.calculate(tournament);

    expect(outcome.canFinish, isFalse);
    expect(outcome.championId, isNull);
    expect(outcome.standings.rows.map((row) => row.position), [1, 1, 1]);
  });

  test('позволяет заменить scoring policy без изменения матчей', () {
    var tournament = _activeTournament();
    final ids = tournament.draft.participants.map((item) => item.id).toList();
    tournament = _completeByStrength(tournament, ids);
    const ruleset = TournamentRuleset(
      'alternative',
      7,
      TournamentStandingsCalculator(
        _WinnerOnlyScoringPolicy(),
        StandardStandingsTieBreakPolicy(),
      ),
      UniqueFirstPlaceChampionPolicy(),
    );

    final outcome = ruleset.calculate(tournament);

    expect(outcome.rulesetId, 'alternative');
    expect(outcome.rulesetVersion, 7);
    expect(outcome.standings.rows.map((row) => row.points), [2, 1, 0]);
    expect(outcome.championId, ids[0]);
  });

  test('пересчёт не зависит от порядка матчей', () {
    var tournament = _activeTournament();
    final ids = tournament.draft.participants.map((item) => item.id).toList();
    tournament = _completeByStrength(tournament, ids);
    final reversed = ActiveTournament(
      draft: tournament.draft,
      setup: tournament.setup,
      matches: tournament.matches.reversed,
    );

    expect(
      MvpTournamentRuleset.instance.calculate(reversed),
      MvpTournamentRuleset.instance.calculate(tournament),
    );
  });

  test('tie-break и champion policies заменяются независимо', () {
    var tournament = _activeTournament();
    final ids = tournament.draft.participants.map((item) => item.id).toList();
    tournament = _completeByStrength(tournament, ids);
    const ruleset = TournamentRuleset(
      'custom-policies',
      1,
      TournamentStandingsCalculator(
        MvpTournamentScoringPolicy(),
        _ReverseTieBreakPolicy(),
      ),
      _LastPlaceChampionPolicy(),
    );

    final outcome = ruleset.calculate(tournament);

    expect(outcome.standings.rows.first.participantId, ids.last);
    expect(outcome.championId, ids.first);
  });
}

ActiveTournament _completeByStrength(
  ActiveTournament tournament,
  List<TournamentParticipantId> ids,
) {
  final strength = {for (final entry in ids.indexed) entry.$2: entry.$1};
  var updated = tournament;
  for (final match in tournament.matches) {
    final scheduled = match.scheduledMatch;
    final winner =
        strength[scheduled.firstParticipantId]! <
            strength[scheduled.secondParticipantId]!
        ? scheduled.firstParticipantId
        : scheduled.secondParticipantId;
    updated = updated.replaceMatch(
      match.correctResult(
        boutWinners: [winner, winner],
        updateId: MatchUpdateId('result-${scheduled.id.value}'),
      ),
    );
  }
  return updated;
}

String _pair(TournamentParticipantId first, TournamentParticipantId second) {
  final values = [first.value, second.value]..sort();
  return values.join('|');
}

ActiveTournament _activeTournament() {
  final draft = TournamentDraft(
    id: TournamentId('tournament-1'),
    name: TournamentName('Турнир'),
    participants: [
      TournamentParticipant.fromLocalProfile(
        LocalProfile.create(id: 'player-0', nickname: 'Первый'),
      ),
      for (var index = 1; index < 3; index++)
        TournamentParticipant.fromGuestProfile(
          GuestProfile.create(id: 'player-$index', nickname: 'Игрок $index'),
        ),
    ],
  );
  final schedule = const RoundRobinTournamentRules().createSchedule(
    draft.participants.map((participant) => participant.id),
  );
  return ActiveTournament.fromSetup(
    draft: draft,
    setup: TournamentSetup(
      tournamentId: draft.id,
      schedule: schedule,
      fighterAssignments: [
        for (final entry in draft.participants.indexed)
          FighterAssignment(
            participantId: entry.$2.id,
            fighterId: FighterId('fighter-${entry.$1}'),
          ),
      ],
    ),
  );
}

final class _WinnerOnlyScoringPolicy implements TournamentScoringPolicy {
  const _WinnerOnlyScoringPolicy();

  @override
  MatchPoints pointsFor(MatchResult result) => result.firstParticipantScore == 2
      ? const MatchPoints(first: 1, second: 0)
      : const MatchPoints(first: 0, second: 1);
}

final class _ReverseTieBreakPolicy implements StandingsTieBreakPolicy {
  const _ReverseTieBreakPolicy();

  @override
  List<List<StandingsRow>> rank({
    required Iterable<StandingsRow> rows,
    required Iterable<TournamentMatch> matches,
  }) => rows.toList().reversed.map((row) => [row]).toList();
}

final class _LastPlaceChampionPolicy implements ChampionSelectionPolicy {
  const _LastPlaceChampionPolicy();

  @override
  TournamentParticipantId? select(TournamentStandings standings) =>
      standings.rows.last.participantId;
}
