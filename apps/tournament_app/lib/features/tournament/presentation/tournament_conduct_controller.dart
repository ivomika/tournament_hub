import 'package:flutter/foundation.dart';
import 'package:tournament_app/core/common/domain/id_generator.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_outcome.dart';
import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/standings/domain/repositories/tournament_completion_repository.dart';
import 'package:tournament_app/features/standings/domain/services/tournament_ruleset.dart';
import 'package:tournament_app/features/tournament/application/start_tournament.dart';
import 'package:tournament_app/features/tournament/application/update_active_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_storage_exception.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class TournamentConductController extends ChangeNotifier {
  TournamentConductController(
    this._startTournament,
    this._updateMatch,
    this._completionRepository,
    this._idGenerator, {
    required this.ruleset,
    required this.draft,
    required this.setup,
  });

  final StartTournament _startTournament;
  final UpdateActiveTournamentMatch _updateMatch;
  final TournamentCompletionRepository _completionRepository;
  final IdGenerator _idGenerator;
  final TournamentRuleset ruleset;
  final TournamentDraft draft;
  final TournamentSetup setup;

  ActiveTournament? _tournament;
  FinishedTournamentSnapshot? _finishedSnapshot;
  String? _errorMessage;
  bool _isInitializing = true;
  bool _isSaving = false;

  ActiveTournament? get tournament => _tournament;
  String? get errorMessage => _errorMessage;
  bool get isInitializing => _isInitializing;
  bool get isSaving => _isSaving;
  bool get isFinished => _finishedSnapshot != null;
  TournamentOutcome? get outcome {
    final finished = _finishedSnapshot;
    if (finished != null) return finished.outcome;
    final current = _tournament;
    return current == null ? null : ruleset.calculate(current);
  }

  Future<void> initialize() async {
    _isInitializing = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final finished = await _completionRepository.getFinishedTournament();
      if (finished != null && finished.tournament.draft.id == draft.id) {
        _finishedSnapshot = finished;
        _tournament = finished.tournament;
        return;
      }
      _tournament = await _startTournament.execute(
        draft: draft,
        setup: setup,
        rulesetId: ruleset.id,
        rulesetVersion: ruleset.version,
      );
    } on TournamentStorageException catch (error) {
      debugPrint(
        'Не удалось открыть состояние турнира: ${error.message}; '
        'причина: ${error.cause}',
      );
      _errorMessage = error.message;
    } on TournamentValidationException catch (error) {
      debugPrint('Активный турнир не прошёл проверку: ${error.message}');
      _errorMessage = error.message;
    } on Object catch (error, stackTrace) {
      debugPrint('Неожиданная ошибка открытия турнира: $error\n$stackTrace');
      _errorMessage = 'Не удалось открыть активный турнир.';
    } finally {
      _isInitializing = false;
      notifyListeners();
    }
  }

  Future<bool> finishTournament() async {
    final current = _tournament;
    final currentOutcome = outcome;
    if (current == null ||
        currentOutcome == null ||
        !currentOutcome.canFinish) {
      return false;
    }
    if (_finishedSnapshot != null) return true;
    if (_isSaving) return false;
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final snapshot = FinishedTournamentSnapshot(
        tournament: current,
        outcome: currentOutcome,
      );
      await _completionRepository.saveFinishedTournament(snapshot);
      _finishedSnapshot = snapshot;
      return true;
    } on Object {
      _errorMessage = 'Не удалось завершить турнир. Повторите попытку.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> recordBout({
    required TournamentMatchId matchId,
    required TournamentParticipantId winnerId,
  }) {
    return _save(
      (tournament) => _updateMatch.recordBout(
        tournament: tournament,
        matchId: matchId,
        winnerId: winnerId,
        updateId: MatchUpdateId(_idGenerator.nextId()),
      ),
    );
  }

  Future<bool> correctResult({
    required TournamentMatchId matchId,
    required Iterable<TournamentParticipantId> boutWinners,
  }) {
    return _save(
      (tournament) => _updateMatch.correctResult(
        tournament: tournament,
        matchId: matchId,
        boutWinners: boutWinners,
        updateId: MatchUpdateId(_idGenerator.nextId()),
      ),
    );
  }

  Future<bool> _save(
    Future<ActiveTournament> Function(ActiveTournament) operation,
  ) async {
    final current = _tournament;
    if (current == null || _isSaving || isFinished) return false;
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _tournament = await operation(current);
      return true;
    } on Object {
      _errorMessage = 'Не удалось сохранить результат. Повторите выбор.';
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}
