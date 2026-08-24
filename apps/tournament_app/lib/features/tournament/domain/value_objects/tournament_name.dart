import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';

final class TournamentName extends Equatable {
  TournamentName(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw const TournamentValidationException('Введите название турнира.');
    }
  }

  final String value;

  @override
  List<Object> get props => [value];
}
