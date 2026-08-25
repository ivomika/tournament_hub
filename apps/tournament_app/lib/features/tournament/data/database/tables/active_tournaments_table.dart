import 'package:drift/drift.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_drafts_table.dart';

@DataClassName('ActiveTournamentRow')
class ActiveTournaments extends Table {
  TextColumn get tournamentId =>
      text().references(TournamentDrafts, #id, onDelete: KeyAction.cascade)();
  TextColumn get rulesetId =>
      text().withDefault(const Constant('mvp-round-robin'))();
  IntColumn get rulesetVersion => integer().withDefault(const Constant(1))();

  @override
  Set<Column<Object>> get primaryKey => {tournamentId};
}
