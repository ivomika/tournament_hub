import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_slot_source_type.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';

final class BracketSlotSource extends Equatable {
  BracketSlotSource.seed(this.seedIndex)
    : type = BracketSlotSourceType.seed,
      matchId = null {
    if (seedIndex! < 0) {
      throw const TournamentValidationException(
        'Индекс seeding не может быть отрицательным.',
      );
    }
  }

  const BracketSlotSource.winner(TournamentMatchId sourceMatchId)
    : type = BracketSlotSourceType.winner,
      seedIndex = null,
      matchId = sourceMatchId;

  const BracketSlotSource.loser(TournamentMatchId sourceMatchId)
    : type = BracketSlotSourceType.loser,
      seedIndex = null,
      matchId = sourceMatchId;

  final BracketSlotSourceType type;
  final int? seedIndex;
  final TournamentMatchId? matchId;

  @override
  List<Object?> get props => [type, seedIndex, matchId];
}
