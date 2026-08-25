import 'package:drift/drift.dart';
import 'package:tournament_app/features/tournament/data/database/tables/tournament_drafts_table.dart';

@DataClassName('TournamentRoundRow')
class TournamentRounds extends Table {
  TextColumn get tournamentId =>
      text().references(TournamentDrafts, #id, onDelete: KeyAction.cascade)();
  IntColumn get roundNumber => integer()();
  TextColumn get byeParticipantId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {tournamentId, roundNumber};
}
