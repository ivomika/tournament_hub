import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';

final class TournamentId extends Equatable {
  TournamentId(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw const TournamentValidationException(
        'Идентификатор турнира не может быть пустым.',
      );
    }
  }

  final String value;

  @override
  List<Object> get props => [value];
}
