import 'package:tournament_app/features/tournament/domain/entities/double_elimination_bracket.dart';
import 'package:tournament_app/features/tournament/domain/services/double_elimination_topology_generator.dart';
import 'package:tournament_app/features/tournament/domain/services/tournament_format_strategy.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class DoubleEliminationFormatStrategy
    implements TournamentFormatStrategy<DoubleEliminationBracket> {
  const DoubleEliminationFormatStrategy(this._topologyGenerator);

  final DoubleEliminationTopologyGenerator _topologyGenerator;

  @override
  TournamentFormat get format => TournamentFormat.doubleElimination;

  @override
  DoubleEliminationBracket create(
    Iterable<TournamentParticipantId> participantIds,
  ) {
    return DoubleEliminationBracket(
      topology: _topologyGenerator.generate(participantIds),
    );
  }
}
