import 'package:tournament_app/domain/history/models/historical_tournament_snapshot.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

abstract interface class TournamentHistoryRepository {
  Future<void> append(HistoricalTournamentSnapshot snapshot);

  Future<List<HistoricalTournamentSnapshot>> list();

  Future<HistoricalTournamentSnapshot?> find(TournamentId tournamentId);

  Future<void> clear();
}
