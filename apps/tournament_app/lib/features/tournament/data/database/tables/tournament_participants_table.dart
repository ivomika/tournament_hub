import 'package:drift/drift.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_drafts_table.dart';

@DataClassName('TournamentParticipantRow')
class TournamentParticipants extends Table {
  TextColumn get tournamentId =>
      text().references(TournamentDrafts, #id, onDelete: KeyAction.cascade)();

  TextColumn get participantId => text()();

  TextColumn get nickname => text()();

  TextColumn get source => text()();

  IntColumn get position => integer()();

  @override
  Set<Column<Object>> get primaryKey => {tournamentId, participantId, source};
}
