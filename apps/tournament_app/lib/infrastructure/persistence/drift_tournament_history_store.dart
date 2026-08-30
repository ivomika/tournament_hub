import 'dart:convert';

import 'package:drift/drift.dart';

import '../../application/persistence/models/persisted_history_snapshot.dart';
import '../../application/persistence/models/persisted_tournament_event.dart';
import '../../application/persistence/models/persisted_tournament_snapshot.dart';
import '../../application/persistence/ports/tournament_history_store.dart';
import '../database/tournament_hub_database.dart';

final class DriftTournamentHistoryStore implements TournamentHistoryStore {
  DriftTournamentHistoryStore(this.database);

  final TournamentHubDatabase database;

  @override
  Future<List<PersistedHistorySnapshot>> readAll() async {
    final rows = await (database.select(
      database.tournamentHistoryEntries,
    )..orderBy([(table) => OrderingTerm.desc(table.finishedAtUtc)])).get();
    return rows
        .map((row) {
          final payload = _json(row.payload);
          return PersistedHistorySnapshot(
            snapshot: PersistedTournamentSnapshot(
              schemaVersion: row.schemaVersion,
              tournamentId: row.tournamentId,
              revision: row.revision,
              formatId: payload.remove('_formatId')! as String,
              rulesetVersion: payload.remove('_rulesetVersion')! as int,
              lifecycle: row.lifecycle,
              createdAtUtc: DateTime.parse(
                payload.remove('_createdAtUtc')! as String,
              ),
              updatedAtUtc: DateTime.parse(
                payload.remove('_updatedAtUtc')! as String,
              ),
              payload: payload,
            ),
            finishedAtUtc: DateTime.parse(row.finishedAtUtc),
          );
        })
        .toList(growable: false);
  }

  @override
  Future<TerminalCommitResult> commitTerminal({
    required PersistedHistorySnapshot history,
    required PersistedTournamentEvent terminalEvent,
  }) => database.transaction(() async {
    final snapshot = history.snapshot;
    if (snapshot.lifecycle != 'finished' && snapshot.lifecycle != 'cancelled') {
      throw const FormatException('History accepts terminal snapshots only.');
    }
    final existing =
        await (database.select(database.tournamentHistoryEntries)..where(
              (table) => table.tournamentId.equals(snapshot.tournamentId),
            ))
            .getSingleOrNull();
    if (existing == null) {
      final payload = <String, Object?>{
        ...snapshot.payload,
        '_formatId': snapshot.formatId,
        '_rulesetVersion': snapshot.rulesetVersion,
        '_createdAtUtc': snapshot.createdAtUtc.toUtc().toIso8601String(),
        '_updatedAtUtc': snapshot.updatedAtUtc.toUtc().toIso8601String(),
      };
      await database
          .into(database.tournamentHistoryEntries)
          .insert(
            TournamentHistoryEntriesCompanion.insert(
              tournamentId: snapshot.tournamentId,
              schemaVersion: snapshot.schemaVersion,
              revision: snapshot.revision,
              lifecycle: snapshot.lifecycle,
              finishedAtUtc: history.finishedAtUtc.toUtc().toIso8601String(),
              payload: jsonEncode(payload),
            ),
          );
    }
    await (database.delete(
      database.activeTournamentEvents,
    )..where((table) => table.tournamentId.equals(snapshot.tournamentId))).go();
    await (database.delete(
      database.processedCommands,
    )..where((table) => table.tournamentId.equals(snapshot.tournamentId))).go();
    await (database.delete(
      database.activeTournamentSnapshots,
    )..where((table) => table.tournamentId.equals(snapshot.tournamentId))).go();
    return TerminalCommitResult(
      inserted: existing == null,
      event: terminalEvent,
    );
  });

  @override
  Future<void> clearHistory() => database.transaction(
    () => database.delete(database.tournamentHistoryEntries).go(),
  );

  Map<String, Object?> _json(String source) {
    final value = jsonDecode(source);
    if (value is! Map<String, Object?>) {
      throw const FormatException('History payload is invalid.');
    }
    return Map<String, Object?>.from(value);
  }
}
