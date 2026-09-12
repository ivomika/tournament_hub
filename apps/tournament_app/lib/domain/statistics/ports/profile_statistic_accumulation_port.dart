import 'package:tournament_app/domain/history/models/historical_tournament_snapshot.dart';
import 'package:tournament_app/domain/statistics/entities/profile_statistic.dart';

abstract interface class ProfileStatisticAccumulationPort {
  ProfileStatistic apply({
    required ProfileStatistic statistic,
    required HistoricalTournamentSnapshot snapshot,
  });
}
