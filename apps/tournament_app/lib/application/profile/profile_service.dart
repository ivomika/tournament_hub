import 'dart:math';

import '../../domain/profile/local_profile.dart';
import '../settings/ports/app_settings_repository.dart';
import 'ports/local_profile_repository.dart';

final class ProfileService {
  ProfileService(this._profiles, this._settings, {Random? random})
    : _random = random ?? Random.secure();

  final LocalProfileRepository _profiles;
  final AppSettingsRepository _settings;
  final Random _random;

  Future<LocalProfile> create(String nickname) async {
    final existing = await _profiles.read();
    if (existing != null) return existing;
    final profile = LocalProfile(id: _newId(), nickname: nickname);
    await _profiles.save(profile);
    return profile;
  }

  Future<LocalProfile> rename(String nickname) async {
    final current = await _profiles.read();
    if (current == null) throw StateError('Local profile is missing.');
    final renamed = current.rename(nickname);
    await _profiles.save(renamed);
    return renamed;
  }

  Future<void> reset() async {
    await _profiles.resetOwnedData();
    await _settings.clear();
  }

  String _newId() {
    final bytes = List<int>.generate(16, (_) => _random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    final hex = bytes
        .map((byte) => byte.toRadixString(16).padLeft(2, '0'))
        .join();
    return '${hex.substring(0, 8)}-${hex.substring(8, 12)}-${hex.substring(12, 16)}-${hex.substring(16, 20)}-${hex.substring(20)}';
  }
}
