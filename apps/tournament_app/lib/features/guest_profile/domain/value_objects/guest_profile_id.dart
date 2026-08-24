import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/guest_profile/domain/exceptions/guest_profile_validation_exception.dart';

final class GuestProfileId extends Equatable {
  GuestProfileId(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw const GuestProfileValidationException(
        'ID гостя не может быть пустым.',
      );
    }
  }

  final String value;

  @override
  List<Object> get props => [value];
}
