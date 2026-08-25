import 'package:drift/drift.dart';
import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/tournament/data/mappers/double_elimination_tournament_mapper.dart';
import 'package:tournament_app/features/tournament/data/mappers/finished_double_elimination_snapshot_mapper.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_storage_exception.dart';
import 'package:tournament_app/features/tournament/domain/repositories/double_elimination_tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';

final class DriftDoubleEliminationTournamentRepository
    implements DoubleEliminationTournamentRepository {
  const DriftDoubleEliminationTournamentRepository(this._database);

  final AppDatabase _database;
  static const _tournamentMapper = DoubleEliminationTournamentMapper();
  static const _snapshotMapper = FinishedDoubleEliminationSnapshotMapper();

  @override
  Future<DoubleEliminationTournament?>
  getActiveDoubleEliminationTournament() async {
    try {
      final row = await (_database.select(
        _database.activeDoubleEliminationTournaments,
      )..limit(1)).getSingleOrNull();
      return row == null ? null : _tournamentMapper.decode(row.payload);
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось загрузить Double Elimination турнир.',
        error,
      );
    }
  }

  @override
  Future<void> saveActiveDoubleEliminationTournament(
    DoubleEliminationTournament tournament,
  ) async {
    try {
      await _database.transaction(() async {
        await _database
            .delete(_database.activeDoubleEliminationTournaments)
            .go();
        await _database
            .into(_database.activeDoubleEliminationTournaments)
            .insert(
              ActiveDoubleEliminationTournamentsCompanion.insert(
                tournamentId: tournament.draft.id.value,
                payload: _tournamentMapper.encode(tournament),
              ),
            );
      });
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось сохранить Double Elimination турнир.',
        error,
      );
    }
  }

  @override
  Future<void> saveFinishedDoubleEliminationTournament(
    FinishedDoubleEliminationSnapshot snapshot,
  ) async {
    try {
      final tournament = snapshot.tournament;
      final existing =
          await (_database.select(_database.tournamentHistoryRecords)..where(
                (table) => table.tournamentId.equals(tournament.draft.id.value),
              ))
              .getSingleOrNull();
      if (existing != null) return;
      final champion = tournament.draft.participants.firstWhere(
        (participant) => participant.id == snapshot.championId,
      );
      await _database.transaction(() async {
        await _database
            .into(_database.tournamentHistoryRecords)
            .insert(
              TournamentHistoryRecordsCompanion.insert(
                tournamentId: tournament.draft.id.value,
                name: tournament.draft.name.value,
                championNickname: champion.nickname.value,
                participantCount: tournament.draft.participants.length,
                rulesetId: 'double-elimination',
                rulesetVersion: 1,
                format: Value(TournamentFormat.doubleElimination.name),
                snapshotPayload: _snapshotMapper.encode(snapshot),
              ),
            );
        await (_database.delete(_database.activeDoubleEliminationTournaments)
              ..where(
                (table) => table.tournamentId.equals(tournament.draft.id.value),
              ))
            .go();
      });
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось завершить Double Elimination турнир.',
        error,
      );
    }
  }

  @override
  Future<FinishedDoubleEliminationSnapshot?>
  getFinishedDoubleEliminationTournamentById(TournamentId id) async {
    try {
      final row =
          await (_database.select(_database.tournamentHistoryRecords)..where(
                (table) =>
                    table.tournamentId.equals(id.value) &
                    table.format.equals(
                      TournamentFormat.doubleElimination.name,
                    ),
              ))
              .getSingleOrNull();
      return row == null ? null : _snapshotMapper.decode(row.snapshotPayload);
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось загрузить Double Elimination из истории.',
        error,
      );
    }
  }
}
