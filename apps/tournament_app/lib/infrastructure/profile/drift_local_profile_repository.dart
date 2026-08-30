import 'dart:convert';

import 'package:drift/drift.dart';

import '../../application/bootstrap/errors/app_session_read_failure.dart';
import '../../application/bootstrap/models/active_tournament_projection.dart';
import '../../application/bootstrap/models/app_actor.dart';
import '../../application/bootstrap/models/local_profile_projection.dart';
import '../../application/bootstrap/models/tournament_lifecycle_projection.dart';
import '../../application/bootstrap/ports/app_session_reader.dart';
import '../../application/profile/ports/local_profile_repository.dart';
import '../../domain/profile/local_profile.dart' as domain;
import '../database/tournament_hub_database.dart';

final class DriftLocalProfileRepository
    implements LocalProfileRepository, AppSessionReader {
  DriftLocalProfileRepository(this._database);

  final Future<TournamentHubDatabase> _database;

  @override
  Future<void> validateAvailability() async {
    try {
      await (await _database).customSelect('SELECT 1').getSingle();
    } on Object {
      throw const AppSessionReadFailure(
        code: AppSessionReadFailureCode.dependencyUnavailable,
        recoverable: true,
      );
    }
  }

  @override
  Future<domain.LocalProfile?> read() async {
    final database = await _database;
    final row = await (database.select(
      database.localProfiles,
    )..where((table) => table.singletonId.equals(1))).getSingleOrNull();
    if (row == null) return null;
    if (row.schemaVersion != 1) {
      throw const FormatException('Unsupported local profile schema.');
    }
    return domain.LocalProfile(id: row.profileId, nickname: row.nickname);
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
  }) async {
    try {
      final database = await _database;
      final row = await database
          .select(database.activeTournamentSnapshots)
          .getSingleOrNull();
      if (row == null) return null;
      final payload = PersistedPayload.decode(row.payload);
      final ownerId = payload['localProfileId'];
      if (ownerId is! String) {
        throw const FormatException('Missing localProfileId.');
      }
      return ActiveTournamentProjection(
        id: row.tournamentId,
        localProfileId: ownerId,
        actor: AppActor.host,
        lifecycle: _lifecycle(row.lifecycle),
      );
    } on Object {
      throw const AppSessionReadFailure(
        code: AppSessionReadFailureCode.activeTournamentReadFailed,
        recoverable: true,
      );
    }
  }

  TournamentLifecycleProjection _lifecycle(String value) => switch (value) {
    'draft' => TournamentLifecycleProjection.draft,
    'open' => TournamentLifecycleProjection.open,
    'distribution' => TournamentLifecycleProjection.distribution,
    'running' => TournamentLifecycleProjection.running,
    _ => throw const FormatException('Terminal snapshot cannot be active.'),
  };

  @override
  Future<void> save(domain.LocalProfile profile) async {
    final database = await _database;
    final existing = await database
        .select(database.localProfiles)
        .getSingleOrNull();
    if (existing == null) {
      await database
          .into(database.localProfiles)
          .insert(
            LocalProfilesCompanion.insert(
              profileId: profile.id,
              nickname: profile.nickname,
              schemaVersion: 1,
            ),
          );
      return;
    }
    if (existing.profileId != profile.id) {
      throw StateError('Local profile identity cannot be replaced.');
    }
    await (database.update(
      database.localProfiles,
    )..where((table) => table.singletonId.equals(1))).write(
      LocalProfilesCompanion(
        nickname: Value(profile.nickname),
        schemaVersion: const Value(1),
      ),
    );
  }

  @override
  Future<void> resetOwnedData() async {
    final database = await _database;
    await database.transaction(() async {
      await database.delete(database.tournamentHistoryEntries).go();
      await database.delete(database.processedCommands).go();
      await database.delete(database.activeTournamentEvents).go();
      await database.delete(database.activeTournamentSnapshots).go();
      await database.delete(database.localProfiles).go();
    });
  }
}

abstract final class PersistedPayload {
  static Map<String, Object?> decode(String source) =>
      // Kept here to avoid exposing database rows to application bootstrap.
      _decode(source);
}

Map<String, Object?> _decode(String source) {
  final value = jsonDecode(source);
  if (value is! Map<String, Object?>) {
    throw const FormatException('Invalid payload.');
  }
  return value;
}
