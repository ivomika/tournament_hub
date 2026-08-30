import 'dart:convert';

import 'package:drift/drift.dart';

import '../../application/persistence/models/persisted_command_result.dart';
import '../../application/persistence/models/persisted_tournament_event.dart';
import '../../application/persistence/models/persisted_tournament_snapshot.dart';
import '../../application/persistence/ports/active_tournament_store.dart';
import '../database/tournament_hub_database.dart';

final class DriftActiveTournamentStore implements ActiveTournamentStore {
  DriftActiveTournamentStore(this.database);

  final TournamentHubDatabase database;

  @override
  Future<PersistedTournamentSnapshot?> readActive() async {
    final row = await database
        .select(database.activeTournamentSnapshots)
        .getSingleOrNull();
    return row == null ? null : _snapshot(row);
  }

  @override
  Future<List<PersistedTournamentEvent>> readEventsAfter({
    required String tournamentId,
    required int sequence,
  }) async {
    final rows =
        await (database.select(database.activeTournamentEvents)
              ..where(
                (table) =>
                    table.tournamentId.equals(tournamentId) &
                    table.sequence.isBiggerThanValue(sequence),
              )
              ..orderBy([(table) => OrderingTerm.asc(table.sequence)]))
            .get();
    return rows.map(_event).toList(growable: false);
  }

  @override
  Future<ActiveCommitResult> commitMutation({
    required int expectedRevision,
    required PersistedTournamentSnapshot snapshot,
    required List<PersistedTournamentEvent> events,
    required PersistedCommandResult commandResult,
  }) => database.transaction(() async {
    final duplicate =
        await (database.select(database.processedCommands)..where(
              (table) => table.commandId.equals(commandResult.commandId),
            ))
            .getSingleOrNull();
    if (duplicate != null) {
      return ActiveCommitResult(
        status: ActiveCommitStatus.duplicateCommand,
        commandResult: PersistedCommandResult(
          commandId: duplicate.commandId,
          tournamentId: duplicate.tournamentId,
          revision: duplicate.revision,
          payload: _json(duplicate.resultPayload),
        ),
      );
    }

    final current = await database
        .select(database.activeTournamentSnapshots)
        .getSingleOrNull();
    final actualRevision = current?.revision ?? 0;
    if (actualRevision != expectedRevision) {
      throw RevisionConflict(
        expected: expectedRevision,
        actual: current?.revision,
      );
    }
    if (snapshot.revision != expectedRevision + 1) {
      throw RevisionConflict(
        expected: expectedRevision + 1,
        actual: snapshot.revision,
      );
    }
    final lastSequence = await _lastSequence(snapshot.tournamentId);
    for (var index = 0; index < events.length; index++) {
      if (events[index].sequence != lastSequence + index + 1 ||
          events[index].revision != snapshot.revision) {
        throw const FormatException(
          'Events must be contiguous and match snapshot revision.',
        );
      }
    }

    await database
        .into(database.activeTournamentSnapshots)
        .insertOnConflictUpdate(
          ActiveTournamentSnapshotsCompanion.insert(
            tournamentId: snapshot.tournamentId,
            schemaVersion: snapshot.schemaVersion,
            revision: snapshot.revision,
            formatId: snapshot.formatId,
            rulesetVersion: snapshot.rulesetVersion,
            lifecycle: snapshot.lifecycle,
            createdAtUtc: snapshot.createdAtUtc.toUtc().toIso8601String(),
            updatedAtUtc: snapshot.updatedAtUtc.toUtc().toIso8601String(),
            payload: snapshot.encodePayload(),
          ),
        );
    for (final event in events) {
      await database
          .into(database.activeTournamentEvents)
          .insert(
            ActiveTournamentEventsCompanion.insert(
              eventId: event.eventId,
              tournamentId: event.tournamentId,
              sequence: event.sequence,
              revision: event.revision,
              eventVersion: event.eventVersion,
              type: event.type,
              timestampUtc: event.timestampUtc.toUtc().toIso8601String(),
              payload: event.encodePayload(),
            ),
          );
    }
    await database
        .into(database.processedCommands)
        .insert(
          ProcessedCommandsCompanion.insert(
            commandId: commandResult.commandId,
            tournamentId: commandResult.tournamentId,
            revision: commandResult.revision,
            resultPayload: commandResult.encodePayload(),
          ),
        );
    return ActiveCommitResult(
      status: ActiveCommitStatus.committed,
      commandResult: commandResult,
    );
  });

  Future<int> _lastSequence(String tournamentId) async {
    final expression = database.activeTournamentEvents.sequence.max();
    final query = database.selectOnly(database.activeTournamentEvents)
      ..addColumns([expression])
      ..where(
        database.activeTournamentEvents.tournamentId.equals(tournamentId),
      );
    return (await query.getSingle()).read(expression) ?? 0;
  }

  PersistedTournamentSnapshot _snapshot(ActiveTournamentSnapshot row) =>
      PersistedTournamentSnapshot(
        schemaVersion: row.schemaVersion,
        tournamentId: row.tournamentId,
        revision: row.revision,
        formatId: row.formatId,
        rulesetVersion: row.rulesetVersion,
        lifecycle: row.lifecycle,
        createdAtUtc: DateTime.parse(row.createdAtUtc),
        updatedAtUtc: DateTime.parse(row.updatedAtUtc),
        payload: PersistedTournamentSnapshot.decodePayload(row.payload),
      );

  PersistedTournamentEvent _event(ActiveTournamentEvent row) =>
      PersistedTournamentEvent(
        eventId: row.eventId,
        tournamentId: row.tournamentId,
        sequence: row.sequence,
        revision: row.revision,
        eventVersion: row.eventVersion,
        type: row.type,
        timestampUtc: DateTime.parse(row.timestampUtc),
        payload: _json(row.payload),
      );

  Map<String, Object?> _json(String source) {
    final value = jsonDecode(source);
    if (value is! Map<String, Object?>) {
      throw const FormatException('Payload is not an object.');
    }
    return value;
  }
}
