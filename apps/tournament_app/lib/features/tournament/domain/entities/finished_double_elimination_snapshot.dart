import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class FinishedDoubleEliminationSnapshot extends Equatable {
  FinishedDoubleEliminationSnapshot({
    required this.tournament,
    required Map<FighterId, String> fighterNamesById,
  }) : fighterNamesById = Map.unmodifiable(fighterNamesById),
       placements = List.unmodifiable(
         tournament.finalPlacements ??
             (throw const TournamentValidationException(
               'Нельзя завершить Double Elimination до определения мест.',
             )),
       );

  final DoubleEliminationTournament tournament;
  final List<TournamentParticipantId> placements;
  final Map<FighterId, String> fighterNamesById;

  TournamentParticipantId get championId => placements.first;

  @override
  List<Object> get props => [tournament, placements, fighterNamesById];
}
