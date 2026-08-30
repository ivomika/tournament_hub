import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';

part 'tournament_hub_database.g.dart';

class LocalProfiles extends Table {
  IntColumn get singletonId =>
      integer().named('singleton_id').withDefault(const Constant(1))();
  TextColumn get profileId => text().named('profile_id').unique()();
  TextColumn get nickname => text()();
  IntColumn get schemaVersion => integer().named('schema_version')();
  @override
  String get tableName => 'local_profile';
  @override
  Set<Column<Object>> get primaryKey => {singletonId};
}

class ActiveTournamentSnapshots extends Table {
  IntColumn get singletonId =>
      integer().named('singleton_id').withDefault(const Constant(1))();
  TextColumn get tournamentId => text().named('tournament_id').unique()();
  IntColumn get schemaVersion => integer().named('schema_version')();
  IntColumn get revision => integer()();
  TextColumn get formatId => text().named('format_id')();
  IntColumn get rulesetVersion => integer().named('ruleset_version')();
  TextColumn get lifecycle => text()();
  TextColumn get createdAtUtc => text().named('created_at_utc')();
  TextColumn get updatedAtUtc => text().named('updated_at_utc')();
  TextColumn get payload => text()();
  @override
  Set<Column<Object>> get primaryKey => {singletonId};
}

class ActiveTournamentEvents extends Table {
  TextColumn get eventId => text().named('event_id')();
  TextColumn get tournamentId => text().named('tournament_id')();
  IntColumn get sequence => integer()();
  IntColumn get revision => integer()();
  IntColumn get eventVersion => integer().named('event_version')();
  TextColumn get type => text()();
  TextColumn get timestampUtc => text().named('timestamp_utc')();
  TextColumn get payload => text()();
  @override
  Set<Column<Object>> get primaryKey => {eventId};
  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {tournamentId, sequence},
  ];
}

class ProcessedCommands extends Table {
  TextColumn get commandId => text().named('command_id')();
  TextColumn get tournamentId => text().named('tournament_id')();
  IntColumn get revision => integer()();
  TextColumn get resultPayload => text().named('result_payload')();
  @override
  Set<Column<Object>> get primaryKey => {commandId};
}

class TournamentHistoryEntries extends Table {
  TextColumn get tournamentId => text().named('tournament_id')();
  IntColumn get schemaVersion => integer().named('schema_version')();
  IntColumn get revision => integer()();
  TextColumn get lifecycle => text()();
  TextColumn get finishedAtUtc => text().named('finished_at_utc')();
  TextColumn get payload => text()();
  @override
  Set<Column<Object>> get primaryKey => {tournamentId};
}

@DriftDatabase(
  tables: [
    LocalProfiles,
    ActiveTournamentSnapshots,
    ActiveTournamentEvents,
    ProcessedCommands,
    TournamentHistoryEntries,
  ],
)
class TournamentHubDatabase extends _$TournamentHubDatabase {
  TournamentHubDatabase(super.executor);

  factory TournamentHubDatabase.memory() =>
      TournamentHubDatabase(NativeDatabase.memory());

  static Future<TournamentHubDatabase> production() async {
    final directory = await getApplicationSupportDirectory();
    await directory.create(recursive: true);
    return TournamentHubDatabase(
      NativeDatabase(
        File('${directory.path}${Platform.pathSeparator}tournament_hub.sqlite'),
      ),
    );
  }

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) => migrator.createAll(),
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(activeTournamentSnapshots);
        await migrator.createTable(activeTournamentEvents);
        await migrator.createTable(processedCommands);
        await migrator.createTable(tournamentHistoryEntries);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
