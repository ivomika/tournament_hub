import 'package:shared_preferences/shared_preferences.dart';

import '../../application/settings/models/app_settings.dart';
import '../../application/settings/ports/app_settings_repository.dart';

final class SharedPreferencesAppSettingsRepository
    implements AppSettingsRepository {
  static const _confirmTournamentStartKey = 'confirm_tournament_start';

  @override
  Future<AppSettings> read() async {
    final preferences = await SharedPreferences.getInstance();
    return AppSettings(
      confirmTournamentStart:
          preferences.getBool(_confirmTournamentStartKey) ?? true,
    );
  }

  @override
  Future<void> save(AppSettings settings) async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.setBool(
      _confirmTournamentStartKey,
      settings.confirmTournamentStart,
    );
  }

  @override
  Future<void> clear() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.remove(_confirmTournamentStartKey);
  }
}
