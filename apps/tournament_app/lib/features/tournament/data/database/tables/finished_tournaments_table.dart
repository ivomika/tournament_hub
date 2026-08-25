import 'package:drift/drift.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_drafts_table.dart';

@DataClassName('FinishedTournamentRow')
class FinishedTournaments extends Table {
  TextColumn get tournamentId =>
      text().references(TournamentDrafts, #id, onDelete: KeyAction.cascade)();
  TextColumn get rulesetId => text()();
  IntColumn get rulesetVersion => integer()();
  TextColumn get championId => text()();

  @override
  Set<Column<Object>> get primaryKey => {tournamentId};
}
