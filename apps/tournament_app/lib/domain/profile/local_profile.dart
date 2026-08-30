import 'package:equatable/equatable.dart';

final class LocalProfile extends Equatable {
  LocalProfile({required this.id, required String nickname})
    : nickname = normalizeNickname(nickname) {
    if (id.trim().isEmpty) {
      throw const FormatException('Profile ID must not be empty.');
    }
  }

  final String id;
  final String nickname;

  LocalProfile rename(String value) => LocalProfile(id: id, nickname: value);

  static String normalizeNickname(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw const FormatException('Nickname must not be empty.');
    }
    return normalized;
  }

  @override
  List<Object?> get props => [id, nickname];
}
