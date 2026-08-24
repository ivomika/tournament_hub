import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/guest_profile/domain/value_objects/guest_nickname.dart';
import 'package:tournament_app/features/guest_profile/domain/value_objects/guest_profile_id.dart';

final class GuestProfile extends Equatable {
  const GuestProfile({required this.id, required this.nickname});

  factory GuestProfile.create({required String id, required String nickname}) {
    return GuestProfile(
      id: GuestProfileId(id),
      nickname: GuestNickname(nickname),
    );
  }

  final GuestProfileId id;
  final GuestNickname nickname;

  GuestProfile rename(String value) {
    return GuestProfile(id: id, nickname: GuestNickname(value));
  }

  @override
  List<Object> get props => [id, nickname];
}
