import 'package:drift/drift.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_drafts_table.dart';

@DataClassName('MatchUpdateRow')
class MatchUpdates extends Table {
  TextColumn get tournamentId =>
      text().references(TournamentDrafts, #id, onDelete: KeyAction.cascade)();
  TextColumn get matchId => text()();
  TextColumn get updateId => text()();

  @override
  Set<Column<Object>> get primaryKey => {tournamentId, matchId, updateId};
}
