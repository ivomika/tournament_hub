import 'package:flutter/foundation.dart';
import 'package:tournament_app/core/common/domain/id_generator.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_storage_exception.dart';
import 'package:tournament_app/features/tournament/domain/repositories/double_elimination_tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class DoubleEliminationConductController extends ChangeNotifier {
  DoubleEliminationConductController(
    this._initialTournament,
    this._repository,
    this._idGenerator,
    this._fighterRegistry,
  );

  final DoubleEliminationTournament _initialTournament;
  final DoubleEliminationTournamentRepository _repository;
  final IdGenerator _idGenerator;
  final FighterRegistry _fighterRegistry;

  DoubleEliminationTournament? _tournament;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isFinished = false;
  String? _errorMessage;

  DoubleEliminationTournament? get tournament => _tournament;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  bool get isFinished => _isFinished;
  String? get errorMessage => _errorMessage;

  Future<void> initialize() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final restored = await _repository.getActiveDoubleEliminationTournament();
      if (restored != null &&
          restored.draft.id == _initialTournament.draft.id) {
        _tournament = restored;
      } else {
        await _repository.saveActiveDoubleEliminationTournament(
          _initialTournament,
        );
        _tournament = _initialTournament;
      }
    } on TournamentStorageException catch (error) {
      _errorMessage = error.message;
    } on Object {
      _errorMessage = 'Не удалось открыть Double Elimination турнир.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> recordBracketResult({
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
  }) {
    return _save(
      (current) => current.recordBracketResult(
        matchId: matchId,
        winnerId: winnerId,
        updateId: MatchUpdateId(_idGenerator.nextId()),
      ),
    );
  }

  Future<bool> correctBracketResult({
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
  }) {
    return _save(
      (current) => current.correctBracketResult(
        matchId: matchId,
        winnerId: winnerId,
        updateId: MatchUpdateId(_idGenerator.nextId()),
      ),
    );
  }

  Future<bool> recordPlacementResult({
    required Iterable<TournamentParticipantId> group,
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
  }) {
    return _save(
      (current) => current.recordPlacementResult(
        group: group,
        matchId: matchId,
        winnerId: winnerId,
        updateId: MatchUpdateId(_idGenerator.nextId()),
      ),
    );
  }

  Future<bool> finish() async {
    final current = _tournament;
    if (current == null || !current.isCompleted || _isSaving) return false;
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repository.saveFinishedDoubleEliminationTournament(
        FinishedDoubleEliminationSnapshot(
          tournament: current,
          fighterNamesById: {
            for (final assignment in current.fighterAssignments)
              assignment.fighterId:
                  _fighterRegistry
                      .findById(assignment.fighterId)
                      ?.displayName ??
                  assignment.fighterId.value,
          },
        ),
      );
      _isFinished = true;
      return true;
    } on Object {
      _errorMessage = 'Не удалось завершить турнир. Повторите попытку.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> _save(
    DoubleEliminationTournament Function(DoubleEliminationTournament) update,
  ) async {
    final current = _tournament;
    if (current == null || _isSaving || _isFinished) return false;
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final updated = update(current);
      await _repository.saveActiveDoubleEliminationTournament(updated);
      _tournament = updated;
      return true;
    } on Object {
      _errorMessage = 'Не удалось сохранить результат. Повторите попытку.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
