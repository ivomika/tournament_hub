import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/fighters/domain/exceptions/fighter_validation_exception.dart';

final class FighterId extends Equatable {
  FighterId(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw const FighterValidationException('ID бойца не может быть пустым.');
    }
  }

  final String value;

  @override
  List<Object> get props => [value];
}
