import 'package:drift/drift.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_drafts_table.dart';

@DataClassName('TournamentFighterAssignmentRow')
class TournamentFighterAssignments extends Table {
  TextColumn get tournamentId =>
      text().references(TournamentDrafts, #id, onDelete: KeyAction.cascade)();
  TextColumn get participantId => text()();
  TextColumn get fighterId => text()();

  @override
  Set<Column<Object>> get primaryKey => {tournamentId, participantId};
}
