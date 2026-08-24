import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';

abstract interface class LocalProfileRepository {
  Future<LocalProfile?> getProfile();

  Future<void> saveProfile(LocalProfile profile);
}
