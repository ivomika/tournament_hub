import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/application/start_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';

import '../../../support/fake_tournament_repository.dart';

void main() {
  test('не позволяет заменить ruleset после старта турнира', () async {
    final repository = FakeTournamentRepository();
    final useCase = StartTournament(repository);
    final draft = _draft();
    final setup = _setup(draft);

    final started = await useCase.execute(
      draft: draft,
      setup: setup,
      rulesetId: 'mvp-round-robin',
      rulesetVersion: 1,
    );

    expect(
      () => useCase.execute(
        draft: draft,
        setup: setup,
        rulesetId: 'future-rules',
        rulesetVersion: 2,
      ),
      throwsA(isA<TournamentValidationException>()),
    );
    expect(repository.activeTournament, started);
    expect(repository.activeTournamentSaveCalls, 1);
  });
}

TournamentDraft _draft() {
  final owner = LocalProfile.create(id: 'player-1', nickname: 'Первый');
  final guest = GuestProfile.create(id: 'player-2', nickname: 'Второй');
  return TournamentDraft(
    id: TournamentId('tournament-1'),
    name: TournamentName('Кубок'),
    participants: [
      TournamentParticipant.fromLocalProfile(owner),
      TournamentParticipant.fromGuestProfile(guest),
    ],
  );
}

TournamentSetup _setup(TournamentDraft draft) {
  return TournamentSetup(
    tournamentId: draft.id,
    schedule: const RoundRobinTournamentRules().createSchedule(
      draft.participants.map((participant) => participant.id),
    ),
    fighterAssignments: [
      for (final (index, participant) in draft.participants.indexed)
        FighterAssignment(
          participantId: participant.id,
          fighterId: FighterId('fighter-$index'),
        ),
    ],
  );
}
