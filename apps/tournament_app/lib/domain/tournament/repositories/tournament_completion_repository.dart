import 'package:tournament_app/domain/history/models/historical_tournament_snapshot.dart';
import 'package:tournament_app/domain/statistics/entities/profile_statistic.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

final class TournamentCompletionChange {
  const TournamentCompletionChange({
    required this.expectedRevision,
    required this.snapshot,
    required this.profileStatistics,
  });

  final int expectedRevision;
  final HistoricalTournamentSnapshot snapshot;
  final Iterable<ProfileStatistic> profileStatistics;

  TournamentId get tournamentId => snapshot.tournamentId;
}

abstract interface class TournamentCompletionRepository {
  Future<void> commit(TournamentCompletionChange change);
}
