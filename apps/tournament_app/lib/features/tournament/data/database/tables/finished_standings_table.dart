import 'package:drift/drift.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_drafts_table.dart';

@DataClassName('FinishedStandingRow')
class FinishedStandings extends Table {
  TextColumn get tournamentId =>
      text().references(TournamentDrafts, #id, onDelete: KeyAction.cascade)();
  TextColumn get participantId => text()();
  IntColumn get position => integer()();
  IntColumn get matchesPlayed => integer()();
  IntColumn get wins => integer()();
  IntColumn get losses => integer()();
  IntColumn get gamesWon => integer()();
  IntColumn get gamesLost => integer()();
  IntColumn get points => integer()();

  @override
  Set<Column<Object>> get primaryKey => {tournamentId, participantId};
}
