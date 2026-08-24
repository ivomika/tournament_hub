import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/services/fighter_assignment_strategy.dart';
import 'package:tournament_app/features/tournament/domain/services/tournament_rules.dart';

final class PrepareTournament {
  const PrepareTournament(
    this._tournamentRules,
    this._fighterAssignmentStrategy,
    this._fighterRegistry,
  );

  final TournamentRules _tournamentRules;
  final FighterAssignmentStrategy _fighterAssignmentStrategy;
  final FighterRegistry _fighterRegistry;

  TournamentSetup execute(TournamentDraft draft) {
    final participantIds = draft.participants.map(
      (participant) => participant.id,
    );
    final schedule = _tournamentRules.createSchedule(participantIds);
    final assignments = _fighterAssignmentStrategy.assign(
      participantIds: participantIds,
      fighters: _fighterRegistry.fighters,
    );
    return TournamentSetup(
      tournamentId: draft.id,
      schedule: schedule,
      fighterAssignments: assignments,
    );
  }
}
