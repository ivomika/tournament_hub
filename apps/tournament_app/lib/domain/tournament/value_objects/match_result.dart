import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';

abstract base class MatchResult extends Equatable {
  const MatchResult({required this.winnerId, required this.loserId})
    : assert(winnerId != loserId, 'Winner и loser должны различаться.');

  final ParticipantId winnerId;
  final ParticipantId loserId;
}
