import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class FighterAssignment extends Equatable {
  const FighterAssignment({
    required this.participantId,
    required this.fighterId,
  });

  final TournamentParticipantId participantId;
  final FighterId fighterId;

  @override
  List<Object> get props => [participantId, fighterId];
}
