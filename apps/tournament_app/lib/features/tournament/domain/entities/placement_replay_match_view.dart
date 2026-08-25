import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/elimination_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/scheduled_tournament_match.dart';

final class PlacementReplayMatchView extends Equatable {
  const PlacementReplayMatchView({required this.scheduledMatch, this.result});

  final ScheduledTournamentMatch scheduledMatch;
  final EliminationMatchResult? result;

  bool get isCompleted => result != null;

  @override
  List<Object?> get props => [scheduledMatch, result];
}
