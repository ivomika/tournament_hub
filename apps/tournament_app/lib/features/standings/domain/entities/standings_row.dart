import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class StandingsRow extends Equatable {
  const StandingsRow({
    required this.participantId,
    required this.position,
    required this.matchesPlayed,
    required this.wins,
    required this.losses,
    required this.gamesWon,
    required this.gamesLost,
    required this.points,
  });

  final TournamentParticipantId participantId;
  final int position;
  final int matchesPlayed;
  final int wins;
  final int losses;
  final int gamesWon;
  final int gamesLost;
  final int points;

  int get gameDifference => gamesWon - gamesLost;

  StandingsRow withPosition(int value) => StandingsRow(
    participantId: participantId,
    position: value,
    matchesPlayed: matchesPlayed,
    wins: wins,
    losses: losses,
    gamesWon: gamesWon,
    gamesLost: gamesLost,
    points: points,
  );

  @override
  List<Object> get props => [
    participantId,
    position,
    matchesPlayed,
    wins,
    losses,
    gamesWon,
    gamesLost,
    points,
  ];
}
