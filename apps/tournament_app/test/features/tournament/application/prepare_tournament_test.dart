import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/features/fighters/domain/entities/fighter.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_avatar_id.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/application/prepare_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_schedule.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/services/fighter_assignment_strategy.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/services/tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

void main() {
  late TournamentDraft draft;
  late _DelegatingTournamentRules rules;
  late _FixedFighterAssignmentStrategy assignmentStrategy;

  setUp(() {
    draft = TournamentDraft(
      id: TournamentId('tournament-1'),
      name: TournamentName('Кубок'),
      participants: [
        TournamentParticipantId('local-1'),
        TournamentParticipantId('guest-1'),
        TournamentParticipantId('guest-2'),
      ].map(_participant),
    );
    rules = _DelegatingTournamentRules();
    assignmentStrategy = _FixedFighterAssignmentStrategy();
  });

  test('независимо подменяет правила и стратегию назначения', () {
    final useCase = PrepareTournament(
      rules,
      assignmentStrategy,
      _FighterRegistry(3),
    );

    final setup = useCase.execute(draft);

    expect(setup.tournamentId, draft.id);
    expect(setup.schedule.rounds, hasLength(3));
    expect(setup.fighterAssignments, hasLength(3));
    expect(rules.calls, 1);
    expect(assignmentStrategy.calls, 1);
  });

  test('domain отклоняет некорректный результат подменной стратегии', () {
    assignmentStrategy.duplicateFirstFighter = true;
    final useCase = PrepareTournament(
      rules,
      assignmentStrategy,
      _FighterRegistry(3),
    );

    expect(
      () => useCase.execute(draft),
      throwsA(isA<TournamentValidationException>()),
    );
  });
}

TournamentParticipant _participant(TournamentParticipantId id) {
  if (id.value == 'local-1') {
    return TournamentParticipant.fromLocalProfile(
      LocalProfile.create(id: id.value, nickname: 'Владелец'),
    );
  }
  return TournamentParticipant.fromGuestProfile(
    GuestProfile.create(id: id.value, nickname: id.value),
  );
}

final class _DelegatingTournamentRules implements TournamentRules {
  var calls = 0;

  @override
  TournamentSchedule createSchedule(
    Iterable<TournamentParticipantId> participantIds,
  ) {
    calls++;
    return const RoundRobinTournamentRules().createSchedule(participantIds);
  }
}

final class _FixedFighterAssignmentStrategy
    implements FighterAssignmentStrategy {
  var calls = 0;
  var duplicateFirstFighter = false;

  @override
  List<FighterAssignment> assign({
    required Iterable<TournamentParticipantId> participantIds,
    required Iterable<Fighter> fighters,
  }) {
    calls++;
    final fighterList = fighters.toList();
    return participantIds.indexed.map((entry) {
      final fighterIndex = duplicateFirstFighter ? 0 : entry.$1;
      return FighterAssignment(
        participantId: entry.$2,
        fighterId: fighterList[fighterIndex].id,
      );
    }).toList();
  }
}

final class _FighterRegistry implements FighterRegistry {
  _FighterRegistry(int count)
    : fighters = List.unmodifiable(
        List.generate(
          count,
          (index) => Fighter(
            id: FighterId('fighter-$index'),
            displayName: 'Боец $index',
            avatarId: FighterAvatarId('fighter-$index'),
          ),
        ),
      );

  @override
  final List<Fighter> fighters;

  @override
  Fighter? findById(FighterId id) {
    for (final fighter in fighters) {
      if (fighter.id == id) return fighter;
    }
    return null;
  }
}
