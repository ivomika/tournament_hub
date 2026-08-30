import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqlite3/sqlite3.dart';

import '../../application/bootstrap/errors/app_session_read_failure.dart';
import '../../application/bootstrap/models/active_tournament_projection.dart';
import '../../application/bootstrap/models/local_profile_projection.dart';
import '../../application/bootstrap/ports/app_session_reader.dart';
import '../../application/profile/ports/local_profile_repository.dart';
import '../../domain/profile/local_profile.dart';

final class SqliteLocalProfileRepository
    implements LocalProfileRepository, AppSessionReader {
  SqliteLocalProfileRepository({Future<Database> Function()? openDatabase})
    : _openDatabase = openDatabase ?? _openProductionDatabase;

  final Future<Database> Function() _openDatabase;
  Future<Database>? _database;

  static Future<Database> _openProductionDatabase() async {
    final directory = await getApplicationSupportDirectory();
    await directory.create(recursive: true);
    return sqlite3.open(
      '${directory.path}${Platform.pathSeparator}tournament_hub.sqlite',
    );
  }

  Future<Database> get _db async {
    final database = await (_database ??= _openDatabase());
    _migrate(database);
    return database;
  }

  static void _migrate(Database database) {
    if (database.userVersion >= 1) return;
    database.execute('BEGIN IMMEDIATE');
    try {
      database.execute('''
        CREATE TABLE local_profile (
          singleton_id INTEGER PRIMARY KEY CHECK (singleton_id = 1),
          profile_id TEXT NOT NULL UNIQUE,
          nickname TEXT NOT NULL,
          schema_version INTEGER NOT NULL
        )
      ''');
      database.userVersion = 1;
      database.execute('COMMIT');
    } on Object {
      database.execute('ROLLBACK');
      rethrow;
    }
  }

  @override
  Future<void> validateAvailability() async {
    try {
      await _db;
    } on Object {
      throw const AppSessionReadFailure(
        code: AppSessionReadFailureCode.dependencyUnavailable,
        recoverable: true,
      );
    }
  }

  @override
  Future<LocalProfile?> read() async {
    final rows = (await _db).select(
      'SELECT profile_id, nickname, schema_version FROM local_profile WHERE singleton_id = 1',
    );
    if (rows.isEmpty) return null;
    final row = rows.single;
    if (row['schema_version'] != 1) {
      throw const FormatException('Unsupported local profile schema.');
    }
    return LocalProfile(
      id: row['profile_id'] as String,
      nickname: row['nickname'] as String,
    );
  }

  @override
  Future<LocalProfileProjection?> readLocalProfile() async {
    try {
      final profile = await read();
      if (profile == null) return null;
      return LocalProfileProjection(id: profile.id, nickname: profile.nickname);
    } on Object {
      throw const AppSessionReadFailure(
        code: AppSessionReadFailureCode.profileReadFailed,
        recoverable: true,
      );
    }
  }

  @override
  Future<ActiveTournamentProjection?> readActiveTournament({
    required String localProfileId,
  }) async => null;

  @override
  Future<void> save(LocalProfile profile) async {
    (await _db).execute(
      '''
      INSERT INTO local_profile (singleton_id, profile_id, nickname, schema_version)
      VALUES (1, ?, ?, 1)
      ON CONFLICT(singleton_id) DO UPDATE SET
        profile_id = excluded.profile_id,
        nickname = excluded.nickname,
        schema_version = excluded.schema_version
      ''',
      [profile.id, profile.nickname],
    );
  }

  @override
  Future<void> resetOwnedData() async {
    final database = await _db;
    database.execute('BEGIN IMMEDIATE');
    try {
      database.execute('DELETE FROM local_profile');
      database.execute('COMMIT');
    } on Object {
      database.execute('ROLLBACK');
      rethrow;
    }
  }

  void dispose() {
    final database = _database;
    if (database == null) return;
    database.then((value) => value.close());
  }
}
