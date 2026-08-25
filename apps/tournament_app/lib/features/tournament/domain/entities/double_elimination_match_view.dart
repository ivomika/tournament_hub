import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_match_definition.dart';
import 'package:tournament_app/features/tournament/domain/entities/elimination_match_result.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_match_status.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class DoubleEliminationMatchView extends Equatable {
  const DoubleEliminationMatchView({
    required this.definition,
    required this.status,
    this.firstParticipantId,
    this.secondParticipantId,
    this.result,
    this.winnerId,
    this.loserId,
  });

  final DoubleEliminationMatchDefinition definition;
  final BracketMatchStatus status;
  final TournamentParticipantId? firstParticipantId;
  final TournamentParticipantId? secondParticipantId;
  final EliminationMatchResult? result;
  final TournamentParticipantId? winnerId;
  final TournamentParticipantId? loserId;

  @override
  List<Object?> get props => [
    definition,
    status,
    firstParticipantId,
    secondParticipantId,
    result,
    winnerId,
    loserId,
  ];
}
