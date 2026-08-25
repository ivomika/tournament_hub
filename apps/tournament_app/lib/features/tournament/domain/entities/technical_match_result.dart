import 'package:tournament_app/features/tournament/domain/entities/match_result.dart';

final class TechnicalMatchResult extends MatchResult {
  const TechnicalMatchResult({
    required super.winnerId,
    required super.firstParticipantScore,
    required super.secondParticipantScore,
  });

  @override
  List<Object> get props => [
    winnerId,
    firstParticipantScore,
    secondParticipantScore,
  ];
}
