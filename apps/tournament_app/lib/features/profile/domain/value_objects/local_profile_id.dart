import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/profile/domain/exceptions/local_profile_validation_exception.dart';

final class LocalProfileId extends Equatable {
  LocalProfileId(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw const LocalProfileValidationException(
        'Идентификатор профиля не может быть пустым.',
      );
    }
  }

  final String value;

  @override
  List<Object> get props => [value];
}
