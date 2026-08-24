import 'package:drift/drift.dart';
import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/tournament/data/mappers/tournament_draft_mapper.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_storage_exception.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';

final class DriftTournamentRepository implements TournamentRepository {
  const DriftTournamentRepository(this._database);

  final AppDatabase _database;
  static const _mapper = TournamentDraftMapper();

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
      await _database.transaction(() async {
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
      });
    } on Object catch (error) {
      throw TournamentStorageException(
        'Не удалось сохранить черновик турнира.',
        error,
      );
    }
  }
}
