import 'package:drift/drift.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_drafts_table.dart';

@DataClassName('TournamentMatchRow')
class TournamentMatches extends Table {
  TextColumn get tournamentId =>
      text().references(TournamentDrafts, #id, onDelete: KeyAction.cascade)();
  TextColumn get matchId => text()();
  IntColumn get roundNumber => integer()();
  IntColumn get position => integer()();
  TextColumn get firstParticipantId => text()();
  TextColumn get secondParticipantId => text()();
  TextColumn get technicalWinnerId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {tournamentId, matchId};
}
