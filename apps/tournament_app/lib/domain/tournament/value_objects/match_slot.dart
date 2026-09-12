import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/tournament/value_objects/match_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';

sealed class MatchSlot extends Equatable {
  const MatchSlot();

  ParticipantId? get resolvedParticipantId;
}

final class AssignedParticipantSlot extends MatchSlot {
  const AssignedParticipantSlot(this.participantId);

  final ParticipantId participantId;

  @override
  ParticipantId get resolvedParticipantId => participantId;

  @override
  List<Object> get props => [participantId];
}

final class WinnerOfMatchSlot extends MatchSlot {
  const WinnerOfMatchSlot(this.sourceMatchId);

  final MatchId sourceMatchId;

  @override
  ParticipantId? get resolvedParticipantId => null;

  @override
  List<Object> get props => [sourceMatchId];
}

final class LoserOfMatchSlot extends MatchSlot {
  const LoserOfMatchSlot(this.sourceMatchId);

  final MatchId sourceMatchId;

  @override
  ParticipantId? get resolvedParticipantId => null;

  @override
  List<Object> get props => [sourceMatchId];
}

final class SeedPositionSlot extends MatchSlot {
  SeedPositionSlot(int position) : position = _requirePositive(position);

  final int position;

  static int _requirePositive(int value) {
    if (value < 1) {
      throw ArgumentError.value(
        value,
        'position',
        'Seed position должна быть не меньше 1.',
      );
    }
    return value;
  }

  @override
  ParticipantId? get resolvedParticipantId => null;

  @override
  List<Object> get props => [position];
}

final class ByeSlot extends MatchSlot {
  const ByeSlot();

  @override
  ParticipantId? get resolvedParticipantId => null;

  @override
  List<Object> get props => const [];
}
