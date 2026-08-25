import 'package:drift/drift.dart';

@DataClassName('ActiveDoubleEliminationTournamentRow')
class ActiveDoubleEliminationTournaments extends Table {
  TextColumn get tournamentId => text()();
  TextColumn get payload => text()();

  @override
  Set<Column<Object>> get primaryKey => {tournamentId};
}
