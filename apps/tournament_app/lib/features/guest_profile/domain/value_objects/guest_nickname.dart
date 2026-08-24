import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/guest_profile/domain/exceptions/guest_profile_validation_exception.dart';

final class GuestNickname extends Equatable {
  GuestNickname(String value) : value = value.trim() {
    if (this.value.isEmpty) {
      throw const GuestProfileValidationException('Введите nickname гостя.');
    }
  }

  final String value;

  @override
  List<Object> get props => [value];
}
