import '../../tournament/models/host_tournament_projection.dart';

final class HistoryTournamentProjection {
  const HistoryTournamentProjection({
    required this.tournament,
    required this.finishedAtUtc,
  });

  final HostTournamentProjection tournament;
  final DateTime finishedAtUtc;
}

final class HostProfileStatisticsProjection {
  const HostProfileStatisticsProjection({
    required this.tournamentCount,
    required this.tournamentWins,
    required this.normalMatchCount,
    required this.normalMatchWins,
    required this.recentTournamentIds,
    this.bestPlace,
  });

  final int tournamentCount;
  final int tournamentWins;
  final int normalMatchCount;
  final int normalMatchWins;
  final int? bestPlace;
  final List<String> recentTournamentIds;

  double get tournamentWinRate =>
      tournamentCount == 0 ? 0 : tournamentWins / tournamentCount;
  double get normalMatchWinRate =>
      normalMatchCount == 0 ? 0 : normalMatchWins / normalMatchCount;
}

final class HistoryProjection {
  const HistoryProjection({required this.entries, required this.statistics});

  final List<HistoryTournamentProjection> entries;
  final HostProfileStatisticsProjection statistics;

  HistoryTournamentProjection? byId(String id) =>
      entries.where((entry) => entry.tournament.id == id).firstOrNull;
}
