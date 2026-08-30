import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/application/profile/ports/local_profile_repository.dart';
import 'package:tournament_hub_app/application/profile/profile_service.dart';
import 'package:tournament_hub_app/application/settings/models/app_settings.dart';
import 'package:tournament_hub_app/application/settings/ports/app_settings_repository.dart';
import 'package:tournament_hub_app/domain/profile/local_profile.dart';

void main() {
  test('create is idempotent and rename preserves id', () async {
    final profiles = _MemoryProfiles();
    final settings = _MemorySettings();
    final service = ProfileService(profiles, settings, random: Random(7));
    final created = await service.create(' Иво ');
    final duplicate = await service.create('Другое имя');
    final renamed = await service.rename('Мика');
    expect(duplicate, created);
    expect(renamed.id, created.id);
    expect(renamed.nickname, 'Мика');
  });

  test('reset clears critical profile and non-critical settings', () async {
    final profiles = _MemoryProfiles()
      ..value = LocalProfile(id: 'p1', nickname: 'Иво');
    final settings = _MemorySettings();
    final service = ProfileService(profiles, settings);
    await service.reset();
    expect(profiles.value, isNull);
    expect(settings.cleared, isTrue);
  });
}

final class _MemoryProfiles implements LocalProfileRepository {
  LocalProfile? value;
  @override
  Future<LocalProfile?> read() async => value;
  @override
  Future<void> save(LocalProfile profile) async => value = profile;
  @override
  Future<void> resetOwnedData() async => value = null;
}

final class _MemorySettings implements AppSettingsRepository {
  bool cleared = false;
  AppSettings value = const AppSettings();
  @override
  Future<void> clear() async => cleared = true;
  @override
  Future<AppSettings> read() async => value;
  @override
  Future<void> save(AppSettings settings) async => value = settings;
}
