import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/domain/game/fighter.dart';
import 'package:tournament_hub_app/domain/tournament/fighter_assignment.dart';
import 'package:tournament_hub_app/domain/tournament/host_tournament.dart';
import 'package:tournament_hub_app/domain/tournament/tournament_failure.dart';
import 'package:tournament_hub_app/domain/tournament/tournament_ids.dart';
import 'package:tournament_hub_app/domain/tournament/tournament_models.dart';

void main() {
  final startedAt = DateTime.utc(2026, 8, 30);
  DateTime at(int minute) => startedAt.add(Duration(minutes: minute));

  HostTournament openTournament() => HostTournament.createDraft(
    id: 't1',
    title: 'Friday Fatality',
    formatId: 'double-elimination',
    nowUtc: at(0),
  ).open(nowUtc: at(1));

  HostTournament withRoster() => openTournament()
      .addGuest(guestId: GuestId('t1', 'g1'), nickname: 'Иво', nowUtc: at(2))
      .addGuest(guestId: GuestId('t1', 'g2'), nickname: 'Мика', nowUtc: at(3));

  HostTournament assign(HostTournament tournament) => tournament.assignFighters(
    assignmentSet: FighterAssignmentSet([
      for (var index = 0; index < tournament.participants.length; index++)
        FighterAssignment(
          participantId: tournament.participants[index].id,
          fighter: Fighter(
            id: FighterId('fighter-$index'),
            displayName: 'Fighter $index',
            assetPath: 'assets/fighters/fighter-$index.png',
          ),
        ),
    ]),
    nowUtc: at(5),
  );

  test('lifecycle follows explicit domain commands and revision', () {
    final open = openTournament();
    final distribution = withRoster().startDistribution(nowUtc: at(4));
    final running = assign(distribution).startRunning(nowUtc: at(6));
    expect(open.lifecycle, TournamentLifecycle.open);
    expect(distribution.lifecycle, TournamentLifecycle.distribution);
    expect(running.lifecycle, TournamentLifecycle.running);
    expect(running.revision, 6);
  });

  test('invalid transition returns typed failure', () {
    final draft = HostTournament.createDraft(
      id: 't1',
      title: 'Cup',
      formatId: 'round-robin',
      nowUtc: at(0),
    );
    expect(
      () => draft.startDistribution(nowUtc: at(1)),
      throwsA(
        isA<TournamentFailure>().having(
          (error) => error.code,
          'code',
          TournamentFailureCode.invalidLifecycle,
        ),
      ),
    );
  });

  test('distribution requires at least two participants', () {
    expect(
      () => openTournament().startDistribution(nowUtc: at(2)),
      throwsA(
        isA<TournamentFailure>().having(
          (error) => error.code,
          'code',
          TournamentFailureCode.insufficientParticipants,
        ),
      ),
    );
  });

  test('running requires complete assignment and keeps it immutable', () {
    final distribution = withRoster().startDistribution(nowUtc: at(4));
    expect(
      () => distribution.startRunning(nowUtc: at(5)),
      throwsA(
        isA<TournamentFailure>().having(
          (error) => error.code,
          'code',
          TournamentFailureCode.invalidAssignments,
        ),
      ),
    );
    final assigned = assign(distribution);
    final running = assigned.startRunning(nowUtc: at(6));
    expect(running.assignments, assigned.assignments);
  });

  test('back to open clears all assignments', () {
    final assigned = assign(withRoster().startDistribution(nowUtc: at(4)));
    expect(assigned.assignments, isNotNull);
    expect(assigned.backToOpen(nowUtc: at(6)).assignments, isNull);
  });

  test('guest id is tournament scoped', () {
    expect(
      () => openTournament().addGuest(
        guestId: GuestId('other', 'g1'),
        nickname: 'Иво',
        nowUtc: at(2),
      ),
      throwsA(isA<TournamentFailure>()),
    );
  });

  test('duplicate local profile participant is rejected', () {
    final tournament = openTournament().addLocalProfile(
      profileId: 'p1',
      nickname: 'Иво',
      nowUtc: at(2),
    );
    expect(
      () => tournament.addLocalProfile(
        profileId: 'p1',
        nickname: 'Новое имя',
        nowUtc: at(3),
      ),
      throwsA(
        isA<TournamentFailure>().having(
          (error) => error.code,
          'code',
          TournamentFailureCode.duplicateProfile,
        ),
      ),
    );
  });

  test('cancelled outcome has no champion and is immutable', () {
    final cancelled = openTournament().cancel(
      reason: 'Организатор отменил турнир',
      nowUtc: at(2),
    );
    expect(cancelled.lifecycle, TournamentLifecycle.cancelled);
    expect(cancelled.finalOutcome, isNull);
    expect(
      () => cancelled.cancel(reason: 'again', nowUtc: at(3)),
      throwsA(
        isA<TournamentFailure>().having(
          (error) => error.code,
          'code',
          TournamentFailureCode.terminalImmutable,
        ),
      ),
    );
  });

  test('finished validates champion and ranking then becomes immutable', () {
    final running = assign(withRoster().startDistribution(nowUtc: at(4)))
        .startRunning(nowUtc: at(6));
    final ids = running.participants
        .map((participant) => participant.id)
        .toList();
    final finished = running.finish(
      outcome: TournamentFinalOutcome(championId: ids.first, ranking: ids),
      nowUtc: at(6),
    );
    expect(finished.finalOutcome?.championId, ids.first);
    expect(
      () => finished.removeParticipant(participantId: ids.last, nowUtc: at(7)),
      throwsA(
        isA<TournamentFailure>().having(
          (error) => error.code,
          'code',
          TournamentFailureCode.terminalImmutable,
        ),
      ),
    );
  });
}
