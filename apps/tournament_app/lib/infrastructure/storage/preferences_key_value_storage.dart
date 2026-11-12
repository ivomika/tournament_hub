import 'package:shared_preferences/shared_preferences.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/infrastructure/storage/key_value_storage.dart';

final class PreferencesKeyValueStorage implements KeyValueStorage {
  PreferencesKeyValueStorage() : _preferences = SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  @override
  OperationRequest<String?> read(StorageKey key) => OperationRequest(
    result: _preferences.getString(_encodeKey(key)),
    onCancel: _release,
  );

  @override
  OperationRequest<void> write(StorageKey key, String value) =>
      OperationRequest(
        result: _preferences.setString(_encodeKey(key), value),
        onCancel: _release,
      );

  static String _encodeKey(StorageKey key) => switch (key) {
    StorageKey.localProfile => 'tournament_hub.local_profile',
  };

  // Native API не отменяет уже начатые чтение/запись. Scope завершает ожидание
  // и подавляет позднюю доставку; запись может сохраниться после отмены.
  static Future<void> _release() => Future<void>.value();
}
