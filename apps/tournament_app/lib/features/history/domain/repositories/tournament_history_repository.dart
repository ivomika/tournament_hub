import 'package:tournament_app/features/history/domain/entities/tournament_history_summary.dart';
import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';

abstract interface class TournamentHistoryRepository {
  Future<List<TournamentHistorySummary>> getHistory();

  Future<FinishedTournamentSnapshot?> getTournamentById(TournamentId id);
}
