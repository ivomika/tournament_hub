import 'package:drift/drift.dart';

@DataClassName('TournamentDraftRow')
class TournamentDrafts extends Table {
  TextColumn get id => text()();

  TextColumn get name => text()();

  TextColumn get status => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}
