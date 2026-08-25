import 'package:tournament_app/features/tournament/domain/entities/match_result.dart';

final class NormalMatchResult extends MatchResult {
  const NormalMatchResult({
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
