import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';

final class TournamentHistorySummary extends Equatable {
  const TournamentHistorySummary({
    required this.tournamentId,
    required this.name,
    required this.championNickname,
    required this.championFighterName,
    required this.participantCount,
    required this.rulesetId,
    required this.rulesetVersion,
    required this.completionOrder,
    this.format = TournamentFormat.roundRobin,
  });

  final TournamentId tournamentId;
  final String name;
  final String championNickname;
  final String championFighterName;
  final int participantCount;
  final String rulesetId;
  final int rulesetVersion;
  final int completionOrder;
  final TournamentFormat format;

  @override
  List<Object> get props => [
    tournamentId,
    name,
    championNickname,
    championFighterName,
    participantCount,
    rulesetId,
    rulesetVersion,
    completionOrder,
    format,
  ];
}
