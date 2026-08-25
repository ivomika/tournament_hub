import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/standings/domain/entities/standings_row.dart';

final class TournamentStandings extends Equatable {
  TournamentStandings({
    required Iterable<StandingsRow> rows,
    required this.completedMatchCount,
    required this.requiredMatchCount,
  }) : rows = List.unmodifiable(rows);

  final List<StandingsRow> rows;
  final int completedMatchCount;
  final int requiredMatchCount;

  bool get allMatchesCompleted => completedMatchCount == requiredMatchCount;
  bool get hasUniquePositions =>
      rows.map((row) => row.position).toSet().length == rows.length;

  @override
  List<Object> get props => [rows, completedMatchCount, requiredMatchCount];
}
