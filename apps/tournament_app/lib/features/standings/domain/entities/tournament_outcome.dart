import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_standings.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class TournamentOutcome extends Equatable {
  const TournamentOutcome({
    required this.rulesetId,
    required this.rulesetVersion,
    required this.standings,
    required this.championId,
  });

  final String rulesetId;
  final int rulesetVersion;
  final TournamentStandings standings;
  final TournamentParticipantId? championId;

  bool get canFinish =>
      standings.allMatchesCompleted &&
      standings.hasUniquePositions &&
      championId != null;

  @override
  List<Object?> get props => [rulesetId, rulesetVersion, standings, championId];
}
