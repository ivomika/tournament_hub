import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/profile/data/models/local_profile_data.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';

final class LocalProfileMapper {
  const LocalProfileMapper();

  LocalProfileData fromDomain(LocalProfile profile) {
    return LocalProfileData(
      id: profile.id.value,
      nickname: profile.nickname.value,
    );
  }

  LocalProfileData fromRow(LocalProfileRow row) {
    return LocalProfileData(id: row.id, nickname: row.nickname);
  }

  LocalProfile toDomain(LocalProfileData data) {
    return LocalProfile.create(id: data.id, nickname: data.nickname);
  }

  LocalProfilesCompanion toCompanion(LocalProfileData data) {
    return LocalProfilesCompanion.insert(id: data.id, nickname: data.nickname);
  }
}
