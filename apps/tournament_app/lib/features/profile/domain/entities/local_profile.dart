import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/profile/domain/value_objects/local_profile_id.dart';
import 'package:tournament_app/features/profile/domain/value_objects/nickname.dart';

final class LocalProfile extends Equatable {
  const LocalProfile({required this.id, required this.nickname});

  factory LocalProfile.create({required String id, required String nickname}) {
    return LocalProfile(id: LocalProfileId(id), nickname: Nickname(nickname));
  }

  final LocalProfileId id;
  final Nickname nickname;

  LocalProfile rename(String value) {
    return LocalProfile(id: id, nickname: Nickname(value));
  }

  @override
  List<Object> get props => [id, nickname];
}
