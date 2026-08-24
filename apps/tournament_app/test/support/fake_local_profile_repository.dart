import 'dart:async';

import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/profile/domain/repositories/local_profile_repository.dart';

final class FakeLocalProfileRepository implements LocalProfileRepository {
  FakeLocalProfileRepository({
    this.profile,
    this.loadError,
    this.saveError,
    this.saveCompleter,
  });

  LocalProfile? profile;
  Object? loadError;
  Object? saveError;
  Completer<void>? saveCompleter;
  int saveCalls = 0;

  @override
  Future<LocalProfile?> getProfile() async {
    if (loadError case final error?) throw error;
    return profile;
  }

  @override
  Future<void> saveProfile(LocalProfile profile) async {
    saveCalls += 1;
    if (saveError case final error?) throw error;
    await saveCompleter?.future;
    this.profile = profile;
  }
}
