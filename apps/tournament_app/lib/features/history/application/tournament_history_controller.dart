import 'package:flutter/foundation.dart';
import 'package:tournament_app/features/history/domain/entities/tournament_history_summary.dart';
import 'package:tournament_app/features/history/domain/repositories/tournament_history_repository.dart';
import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_storage_exception.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/repositories/double_elimination_tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';

enum TournamentHistoryStatus { loading, ready, failure }

final class TournamentHistoryController extends ChangeNotifier {
  TournamentHistoryController(
    this._repository, [
    this._doubleEliminationRepository,
  ]);

  final TournamentHistoryRepository _repository;
  final DoubleEliminationTournamentRepository? _doubleEliminationRepository;

  TournamentHistoryStatus _status = TournamentHistoryStatus.loading;
  List<TournamentHistorySummary> _items = const [];
  FinishedTournamentSnapshot? _selectedTournament;
  FinishedDoubleEliminationSnapshot? _selectedDoubleEliminationTournament;
  TournamentHistorySummary? _selectedSummary;
  TournamentId? _selectedId;
  String? _errorMessage;
  bool _isLoadingDetail = false;
  String? _detailErrorMessage;

  TournamentHistoryStatus get status => _status;
  List<TournamentHistorySummary> get items => _items;
  FinishedTournamentSnapshot? get selectedTournament => _selectedTournament;
  FinishedDoubleEliminationSnapshot? get selectedDoubleEliminationTournament =>
      _selectedDoubleEliminationTournament;
  TournamentHistorySummary? get selectedSummary => _selectedSummary;
  TournamentId? get selectedId => _selectedId;
  String? get errorMessage => _errorMessage;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailErrorMessage => _detailErrorMessage;

  Future<void> initialize() async {
    _status = TournamentHistoryStatus.loading;
    _errorMessage = null;
    notifyListeners();
    try {
      _items = await _repository.getHistory();
      _status = TournamentHistoryStatus.ready;
    } on TournamentStorageException catch (error) {
      _errorMessage = error.message;
      _status = TournamentHistoryStatus.failure;
    } on Object {
      _errorMessage = 'Не удалось загрузить историю турниров.';
      _status = TournamentHistoryStatus.failure;
    }
    notifyListeners();
  }

  Future<bool> select(TournamentHistorySummary summary) async {
    if (_isLoadingDetail) return false;
    _selectedSummary = summary;
    _selectedId = summary.tournamentId;
    _selectedTournament = null;
    _selectedDoubleEliminationTournament = null;
    _detailErrorMessage = null;
    _isLoadingDetail = true;
    notifyListeners();
    try {
      if (summary.format == TournamentFormat.doubleElimination) {
        _selectedDoubleEliminationTournament =
            await _doubleEliminationRepository
                ?.getFinishedDoubleEliminationTournamentById(
                  summary.tournamentId,
                );
      } else {
        _selectedTournament = await _repository.getTournamentById(
          summary.tournamentId,
        );
      }
      if (_selectedTournament == null &&
          _selectedDoubleEliminationTournament == null) {
        _detailErrorMessage = 'Турнир не найден или был удалён.';
      }
      return _detailErrorMessage == null;
    } on TournamentStorageException catch (error) {
      _detailErrorMessage = error.message;
      return false;
    } on Object {
      _detailErrorMessage = 'Не удалось открыть турнир из истории.';
      return false;
    } finally {
      _isLoadingDetail = false;
      notifyListeners();
    }
  }
}
