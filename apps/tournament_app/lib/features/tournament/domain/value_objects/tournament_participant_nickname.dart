import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';

final class TournamentParticipantNickname extends Equatable {
  TournamentParticipantNickname(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw const TournamentValidationException(
        'Nickname участника не может быть пустым.',
      );
    }
  }

  final String value;

  @override
  List<Object> get props => [value];
}
