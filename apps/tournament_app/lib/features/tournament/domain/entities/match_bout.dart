import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class MatchBout extends Equatable {
  MatchBout({required this.number, required this.winnerId}) {
    if (number < 1 || number > 3) {
      throw const TournamentValidationException(
        'Номер схватки должен быть от 1 до 3.',
      );
    }
  }

  final int number;
  final TournamentParticipantId winnerId;

  @override
  List<Object> get props => [number, winnerId];
}
