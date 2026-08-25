import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/bracket_slot_source.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_stage.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';

final class DoubleEliminationMatchDefinition extends Equatable {
  DoubleEliminationMatchDefinition({
    required this.id,
    required this.stage,
    required this.round,
    required this.position,
    required this.firstSource,
    required this.secondSource,
  }) {
    if (round < 1 || position < 0 || firstSource == secondSource) {
      throw const TournamentValidationException(
        'Определение матча Double Elimination некорректно.',
      );
    }
  }

  final TournamentMatchId id;
  final BracketStage stage;
  final int round;
  final int position;
  final BracketSlotSource firstSource;
  final BracketSlotSource secondSource;

  Iterable<TournamentMatchId> get sourceMatchIds sync* {
    if (firstSource.matchId case final id?) yield id;
    if (secondSource.matchId case final id?) yield id;
  }

  @override
  List<Object> get props => [
    id,
    stage,
    round,
    position,
    firstSource,
    secondSource,
  ];
}
