import 'package:drift/drift.dart';

@DataClassName('TournamentHistoryRecordRow')
class TournamentHistoryRecords extends Table {
  IntColumn get completionOrder => integer().autoIncrement()();
  TextColumn get tournamentId => text().unique()();
  TextColumn get name => text()();
  TextColumn get championNickname => text()();
  IntColumn get participantCount => integer()();
  TextColumn get rulesetId => text()();
  TextColumn get format => text().withDefault(const Constant('roundRobin'))();
  IntColumn get rulesetVersion => integer()();
  TextColumn get snapshotPayload => text()();
}
