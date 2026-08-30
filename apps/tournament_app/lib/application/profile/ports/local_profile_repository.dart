import '../../../domain/profile/local_profile.dart';

abstract interface class LocalProfileRepository {
  Future<LocalProfile?> read();

  Future<void> save(LocalProfile profile);

  Future<void> resetOwnedData();
}
