import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/application/update_active_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';

import '../../../support/fake_tournament_repository.dart';

void main() {
  late FakeTournamentRepository repository;
  late UpdateActiveTournamentMatch useCase;
  late ActiveTournament tournament;

  setUp(() {
    repository = FakeTournamentRepository();
    useCase = UpdateActiveTournamentMatch(repository);
    tournament = _activeTournament();
  });

  test('возвращает изменение только после сохранения', () async {
    repository.activeTournament = tournament;
    repository.saveCompleter = Completer<void>();
    final match = tournament.matches.single;

    final future = useCase.recordBout(
      tournament: tournament,
      matchId: match.scheduledMatch.id,
      winnerId: match.scheduledMatch.firstParticipantId,
      updateId: MatchUpdateId('bout-1'),
    );

    var completed = false;
    future.then((_) => completed = true);
    await Future<void>.delayed(Duration.zero);
    expect(completed, isFalse);

    repository.saveCompleter!.complete();
    final updated = await future;
    expect(updated.matches.single.bouts, hasLength(1));
    expect(repository.activeTournament, updated);
  });

  test('ошибка persistence не подтверждает новое состояние', () async {
    repository.activeTournament = tournament;
    repository.saveError = StateError('База недоступна');
    final match = tournament.matches.single;

    await expectLater(
      useCase.recordBout(
        tournament: tournament,
        matchId: match.scheduledMatch.id,
        winnerId: match.scheduledMatch.firstParticipantId,
        updateId: MatchUpdateId('bout-1'),
      ),
      throwsStateError,
    );
    expect(repository.activeTournament, same(tournament));
  });
}

ActiveTournament _activeTournament() {
  final owner = LocalProfile.create(id: 'local-1', nickname: 'Владелец');
  final guest = GuestProfile.create(id: 'guest-1', nickname: 'Гость');
  final draft = TournamentDraft(
    id: TournamentId('tournament-1'),
    name: TournamentName('Турнир'),
    participants: [
      TournamentParticipant.fromLocalProfile(owner),
      TournamentParticipant.fromGuestProfile(guest),
    ],
  );
  final schedule = const RoundRobinTournamentRules().createSchedule(
    draft.participants.map((participant) => participant.id),
  );
  final setup = TournamentSetup(
    tournamentId: draft.id,
    schedule: schedule,
    fighterAssignments: [
      FighterAssignment(
        participantId: draft.participants[0].id,
        fighterId: FighterId('fighter-1'),
      ),
      FighterAssignment(
        participantId: draft.participants[1].id,
        fighterId: FighterId('fighter-2'),
      ),
    ],
  );
  return ActiveTournament.fromSetup(draft: draft, setup: setup);
}
