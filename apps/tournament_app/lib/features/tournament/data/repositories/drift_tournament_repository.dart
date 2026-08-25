import 'package:drift/drift.dart';
import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/history/data/mappers/finished_tournament_snapshot_mapper.dart';
import 'package:tournament_app/features/tournament/data/mappers/finished_double_elimination_snapshot_mapper.dart';
import 'package:tournament_app/features/history/domain/entities/tournament_history_summary.dart';
import 'package:tournament_app/features/history/domain/repositories/tournament_history_repository.dart';
import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/standings/domain/entities/standings_row.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_outcome.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_standings.dart';
import 'package:tournament_app/features/standings/domain/repositories/tournament_completion_repository.dart';
import 'package:tournament_app/features/tournament/data/mappers/tournament_draft_mapper.dart';
import 'package:tournament_app/features/tournament/data/mappers/active_tournament_mapper.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/technical_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_storage_exception.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class DriftTournamentRepository
    implements
        TournamentRepository,
        TournamentCompletionRepository,
        TournamentHistoryRepository {
  const DriftTournamentRepository(this._database);

  final AppDatabase _database;
  static const _mapper = TournamentDraftMapper();
  static const _activeMapper = ActiveTournamentMapper();
  static const _snapshotMapper = FinishedTournamentSnapshotMapper();
  static const _doubleEliminationSnapshotMapper =
      FinishedDoubleEliminationSnapshotMapper();

  @override
  Future<FinishedTournamentSnapshot?> getFinishedTournament() async {
    try {
      await _ensureLegacyHistoryMigrated();
      final record =
          await (_database.select(_database.tournamentHistoryRecords)
                ..where(
                  (table) =>
                      table.format.equals(TournamentFormat.roundRobin.name),
                )
                ..orderBy([(table) => OrderingTerm.desc(table.completionOrder)])
                ..limit(1))
              .getSingleOrNull();
      return record == null
          ? null
          : _snapshotMapper.decode(record.snapshotPayload);
    } on TournamentStorageException {
      rethrow;
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось загрузить завершённый турнир.',
        error,
      );
    }
  }

  @override
  Future<List<TournamentHistorySummary>> getHistory() async {
    try {
      await _ensureLegacyHistoryMigrated();
      final rows = await (_database.select(
        _database.tournamentHistoryRecords,
      )..orderBy([(table) => OrderingTerm.desc(table.completionOrder)])).get();
      return rows
          .map((row) {
            final format = TournamentFormat.values.byName(row.format);
            late final String championFighterName;
            if (format == TournamentFormat.doubleElimination) {
              final snapshot = _doubleEliminationSnapshotMapper.decode(
                row.snapshotPayload,
              );
              final assignment = snapshot.tournament.fighterAssignments
                  .firstWhere(
                    (item) => item.participantId == snapshot.championId,
                  );
              championFighterName =
                  snapshot.fighterNamesById[assignment.fighterId] ??
                  assignment.fighterId.value;
            } else {
              final snapshot = _snapshotMapper.decode(row.snapshotPayload);
              final assignment = snapshot.tournament.setup.fighterAssignments
                  .firstWhere(
                    (item) => item.participantId == snapshot.outcome.championId,
                  );
              championFighterName =
                  snapshot.fighterNamesById[assignment.fighterId] ??
                  assignment.fighterId.value;
            }
            return TournamentHistorySummary(
              tournamentId: TournamentId(row.tournamentId),
              name: row.name,
              championNickname: row.championNickname,
              championFighterName: championFighterName,
              participantCount: row.participantCount,
              rulesetId: row.rulesetId,
              rulesetVersion: row.rulesetVersion,
              completionOrder: row.completionOrder,
              format: format,
            );
          })
          .toList(growable: false);
    } on TournamentStorageException {
      rethrow;
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось загрузить историю турниров.',
        error,
      );
    }
  }

  @override
  Future<FinishedTournamentSnapshot?> getTournamentById(TournamentId id) async {
    try {
      await _ensureLegacyHistoryMigrated();
      final record =
          await (_database.select(_database.tournamentHistoryRecords)..where(
                (table) =>
                    table.tournamentId.equals(id.value) &
                    table.format.equals(TournamentFormat.roundRobin.name),
              ))
              .getSingleOrNull();
      return record == null
          ? null
          : _snapshotMapper.decode(record.snapshotPayload);
    } on TournamentStorageException {
      rethrow;
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось загрузить турнир из истории.',
        error,
      );
    }
  }

  Future<FinishedTournamentSnapshot?> _loadLegacyFinishedTournament() async {
    final marker = await (_database.select(
      _database.finishedTournaments,
    )..limit(1)).getSingleOrNull();
    if (marker == null) return null;
    final draft = await getActiveDraft();
    if (draft == null || draft.id.value != marker.tournamentId) return null;
    final tournament = await _loadTournament(
      draft,
      rulesetId: marker.rulesetId,
      rulesetVersion: marker.rulesetVersion,
    );
    final standingRows = await (_database.select(
      _database.finishedStandings,
    )..orderBy([(table) => OrderingTerm.asc(table.position)])).get();
    final standings = TournamentStandings(
      rows: standingRows.map(
        (row) => StandingsRow(
          participantId: TournamentParticipantId(row.participantId),
          position: row.position,
          matchesPlayed: row.matchesPlayed,
          wins: row.wins,
          losses: row.losses,
          gamesWon: row.gamesWon,
          gamesLost: row.gamesLost,
          points: row.points,
        ),
      ),
      completedMatchCount: tournament.matches.length,
      requiredMatchCount: tournament.matches.length,
    );
    return FinishedTournamentSnapshot(
      tournament: tournament,
      outcome: TournamentOutcome(
        rulesetId: marker.rulesetId,
        rulesetVersion: marker.rulesetVersion,
        standings: standings,
        championId: TournamentParticipantId(marker.championId),
      ),
    );
  }

  @override
  Future<void> saveFinishedTournament(
    FinishedTournamentSnapshot snapshot,
  ) async {
    try {
      await _ensureLegacyHistoryMigrated();
      final existing =
          await (_database.select(_database.tournamentHistoryRecords)..where(
                (table) => table.tournamentId.equals(
                  snapshot.tournament.draft.id.value,
                ),
              ))
              .getSingleOrNull();
      if (existing != null) return;
      await _database.transaction(() async {
        await _insertHistoryRecord(snapshot);
        await (_database.delete(_database.activeTournaments)..where(
              (table) =>
                  table.tournamentId.equals(snapshot.tournament.draft.id.value),
            ))
            .go();
      });
    } on Object catch (error) {
      throw TournamentStorageException('Не удалось завершить турнир.', error);
    }
  }

  @override
  Future<ActiveTournament?> getActiveTournament() async {
    try {
      final marker = await (_database.select(
        _database.activeTournaments,
      )..limit(1)).getSingleOrNull();
      if (marker == null) return null;
      final draft = await getActiveDraft();
      if (draft == null || draft.id.value != marker.tournamentId) return null;
      final assignments = await _database
          .select(_database.tournamentFighterAssignments)
          .get();
      final rounds = await (_database.select(
        _database.tournamentRounds,
      )..orderBy([(table) => OrderingTerm.asc(table.roundNumber)])).get();
      final matches =
          await (_database.select(_database.tournamentMatches)..orderBy([
                (table) => OrderingTerm.asc(table.roundNumber),
                (table) => OrderingTerm.asc(table.position),
              ]))
              .get();
      final bouts = await _database.select(_database.matchBouts).get();
      final updates = await _database.select(_database.matchUpdates).get();
      return _activeMapper.toDomain(
        draft: draft,
        assignmentRows: assignments,
        roundRows: rounds,
        matchRows: matches,
        boutRows: bouts,
        updateRows: updates,
        rulesetId: marker.rulesetId,
        rulesetVersion: marker.rulesetVersion,
      );
    } on TournamentStorageException {
      rethrow;
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось загрузить активный турнир.',
        error,
      );
    }
  }

  @override
  Future<TournamentDraft?> getActiveDraft() async {
    try {
      final draftRow = await (_database.select(
        _database.tournamentDrafts,
      )..limit(1)).getSingleOrNull();
      if (draftRow == null) return null;

      final participantRows =
          await (_database.select(_database.tournamentParticipants)
                ..where((table) => table.tournamentId.equals(draftRow.id))
                ..orderBy([(table) => OrderingTerm.asc(table.position)]))
              .get();
      return _mapper.toDomain(_mapper.fromRows(draftRow, participantRows));
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось загрузить черновик турнира.',
        error,
      );
    }
  }

  @override
  Future<void> saveActiveDraft(TournamentDraft draft) async {
    final data = _mapper.fromDomain(draft);
    try {
      await _ensureLegacyHistoryMigrated();
      await _database.transaction(() async {
        await _clearCurrentTournamentState();
        await _database
            .into(_database.tournamentDrafts)
            .insert(_mapper.toCompanion(data));
        await _database.batch((batch) {
          batch.insertAll(
            _database.tournamentParticipants,
            _mapper.participantsToCompanions(data),
          );
        });
      });
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось сохранить черновик турнира.',
        error,
      );
    }
  }

  @override
  Future<void> saveActiveTournament(ActiveTournament tournament) async {
    final tournamentId = tournament.draft.id.value;
    try {
      await _ensureLegacyHistoryMigrated();
      await _database.transaction(() async {
        await _clearCurrentTournamentState();
        await _replaceDraft(tournament.draft);
        await _database
            .into(_database.activeTournaments)
            .insert(
              ActiveTournamentsCompanion.insert(
                tournamentId: tournamentId,
                rulesetId: Value(tournament.rulesetId),
                rulesetVersion: Value(tournament.rulesetVersion),
              ),
            );
        await _database.batch((batch) {
          batch.insertAll(
            _database.tournamentFighterAssignments,
            tournament.setup.fighterAssignments
                .map(
                  (assignment) => TournamentFighterAssignmentsCompanion.insert(
                    tournamentId: tournamentId,
                    participantId: assignment.participantId.value,
                    fighterId: assignment.fighterId.value,
                  ),
                )
                .toList(),
          );
          batch.insertAll(
            _database.tournamentRounds,
            tournament.setup.schedule.rounds
                .map(
                  (round) => TournamentRoundsCompanion.insert(
                    tournamentId: tournamentId,
                    roundNumber: round.number,
                    byeParticipantId: Value(round.byeParticipantId?.value),
                  ),
                )
                .toList(),
          );
          for (final round in tournament.setup.schedule.rounds) {
            for (final entry in round.matches.indexed) {
              final match = tournament.matches.firstWhere(
                (item) => item.scheduledMatch.id == entry.$2.id,
              );
              final technicalWinner = match.result is TechnicalMatchResult
                  ? match.result!.winnerId.value
                  : null;
              batch.insert(
                _database.tournamentMatches,
                TournamentMatchesCompanion.insert(
                  tournamentId: tournamentId,
                  matchId: entry.$2.id.value,
                  roundNumber: round.number,
                  position: entry.$1,
                  firstParticipantId: entry.$2.firstParticipantId.value,
                  secondParticipantId: entry.$2.secondParticipantId.value,
                  technicalWinnerId: Value(technicalWinner),
                ),
              );
              batch.insertAll(
                _database.matchBouts,
                match.bouts
                    .map(
                      (bout) => MatchBoutsCompanion.insert(
                        tournamentId: tournamentId,
                        matchId: entry.$2.id.value,
                        boutNumber: bout.number,
                        winnerId: bout.winnerId.value,
                      ),
                    )
                    .toList(),
              );
              batch.insertAll(
                _database.matchUpdates,
                match.appliedUpdateIds
                    .map(
                      (updateId) => MatchUpdatesCompanion.insert(
                        tournamentId: tournamentId,
                        matchId: entry.$2.id.value,
                        updateId: updateId.value,
                      ),
                    )
                    .toList(),
              );
            }
          }
        });
      });
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось сохранить активный турнир.',
        error,
      );
    }
  }

  Future<void> _replaceDraft(TournamentDraft draft) async {
    final data = _mapper.fromDomain(draft);
    await _database.delete(_database.tournamentParticipants).go();
    await _database.delete(_database.tournamentDrafts).go();
    await _database
        .into(_database.tournamentDrafts)
        .insert(_mapper.toCompanion(data));
    await _database.batch((batch) {
      batch.insertAll(
        _database.tournamentParticipants,
        _mapper.participantsToCompanions(data),
      );
    });
  }

  Future<void> _clearCurrentTournamentState() async {
    await _database.delete(_database.activeDoubleEliminationTournaments).go();
    await _database.delete(_database.matchUpdates).go();
    await _database.delete(_database.matchBouts).go();
    await _database.delete(_database.tournamentMatches).go();
    await _database.delete(_database.tournamentRounds).go();
    await _database.delete(_database.tournamentFighterAssignments).go();
    await _database.delete(_database.activeTournaments).go();
    await _database.delete(_database.tournamentParticipants).go();
    await _database.delete(_database.tournamentDrafts).go();
  }

  Future<void> _ensureLegacyHistoryMigrated() async {
    final hasHistory =
        await (_database.selectOnly(_database.tournamentHistoryRecords)
              ..addColumns([
                _database.tournamentHistoryRecords.completionOrder.count(),
              ]))
            .map(
              (row) =>
                  row.read(
                    _database.tournamentHistoryRecords.completionOrder.count(),
                  ) ??
                  0,
            )
            .getSingle();
    if (hasHistory > 0) return;
    final legacy = await _loadLegacyFinishedTournament();
    if (legacy != null) await _insertHistoryRecord(legacy);
  }

  Future<void> _insertHistoryRecord(FinishedTournamentSnapshot snapshot) async {
    final championId = snapshot.outcome.championId!;
    final champion = snapshot.tournament.draft.participants.firstWhere(
      (participant) => participant.id == championId,
    );
    await _database
        .into(_database.tournamentHistoryRecords)
        .insert(
          TournamentHistoryRecordsCompanion.insert(
            tournamentId: snapshot.tournament.draft.id.value,
            name: snapshot.tournament.draft.name.value,
            championNickname: champion.nickname.value,
            participantCount: snapshot.tournament.draft.participants.length,
            rulesetId: snapshot.outcome.rulesetId,
            rulesetVersion: snapshot.outcome.rulesetVersion,
            snapshotPayload: _snapshotMapper.encode(snapshot),
            format: Value(TournamentFormat.roundRobin.name),
          ),
          mode: InsertMode.insertOrIgnore,
        );
  }

  Future<ActiveTournament> _loadTournament(
    TournamentDraft draft, {
    required String rulesetId,
    required int rulesetVersion,
  }) async {
    final assignments = await _database
        .select(_database.tournamentFighterAssignments)
        .get();
    final rounds = await (_database.select(
      _database.tournamentRounds,
    )..orderBy([(table) => OrderingTerm.asc(table.roundNumber)])).get();
    final matches =
        await (_database.select(_database.tournamentMatches)..orderBy([
              (table) => OrderingTerm.asc(table.roundNumber),
              (table) => OrderingTerm.asc(table.position),
            ]))
            .get();
    final bouts = await _database.select(_database.matchBouts).get();
    final updates = await _database.select(_database.matchUpdates).get();
    return _activeMapper.toDomain(
      draft: draft,
      assignmentRows: assignments,
      roundRows: rounds,
      matchRows: matches,
      boutRows: bouts,
      updateRows: updates,
      rulesetId: rulesetId,
      rulesetVersion: rulesetVersion,
    );
  }
}
