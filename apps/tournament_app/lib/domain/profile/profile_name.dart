import 'package:tournament_app/domain/profile/profile_exception.dart';

final class ProfileName {
  ProfileName(String input) : value = input.trim() {
    if (value.isEmpty) {
      throw const ProfileException(ProfileFailureReason.invalidName);
    }
  }

  final String value;

  @override
  bool operator ==(Object other) =>
      other is ProfileName && other.value == value;

  @override
  int get hashCode => value.hashCode;
}
