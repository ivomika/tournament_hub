import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/profile/domain/exceptions/local_profile_validation_exception.dart';

final class Nickname extends Equatable {
  Nickname(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw const LocalProfileValidationException('Введите nickname.');
    }
  }

  final String value;

  @override
  List<Object> get props => [value];
}
