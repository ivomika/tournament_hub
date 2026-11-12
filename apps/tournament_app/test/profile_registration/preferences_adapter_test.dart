import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:shared_preferences_platform_interface/types.dart';
import 'package:tournament_app/domain/operations/operation_outcome.dart';
import 'package:tournament_app/domain/operations/operation_scope.dart';
import 'package:tournament_app/domain/profile/profile_exception.dart';
import 'package:tournament_app/infrastructure/profile/profile_codec.dart';
import 'package:tournament_app/infrastructure/profile/stored_profile_repository.dart';
import 'package:tournament_app/infrastructure/storage/key_value_storage.dart';
import 'package:tournament_app/infrastructure/storage/preferences_key_value_storage.dart';

void main() => _PreferencesTests.run();

abstract final class _PreferencesTests {
  static void run() {
    test(
      'actual Async adapter restores values and sees external changes',
      () async {
        _install(InMemorySharedPreferencesAsync.empty());
        final original = PreferencesKeyValueStorage();
        expect(await original.read(StorageKey.localProfile).result, isNull);
        await original.write(StorageKey.localProfile, 'first').result;
        final reopened = PreferencesKeyValueStorage();
        expect(await reopened.read(StorageKey.localProfile).result, 'first');
        await reopened.write(StorageKey.localProfile, 'second').result;
        expect(await original.read(StorageKey.localProfile).result, 'second');
      },
    );

    test(
      'native failure reaches the repository as a typed read error',
      () async {
        _install(_FailingPreferences.empty());
        await expectLater(
          StoredProfileRepository(storage: PreferencesKeyValueStorage())
              .read()
              .result,
          throwsA(
            isA<ProfileException>().having(
              (failure) => failure.reason,
              'reason',
              ProfileFailureReason.read,
            ),
          ),
        );
      },
    );

    test(
      'cancelled native write may commit but never delivers late success',
      () async {
        final platform = _PendingWritePreferences.empty();
        _install(platform);
        final storage = PreferencesKeyValueStorage();
        final scope = OperationScope();
        final results = _WriteResults();
        final operation = scope.run<void>(
          request: () => storage.write(StorageKey.localProfile, 'committed'),
          onResult: results.accept,
          onError: results.fail,
        );
        await scope.close();
        expect(await operation.result, isA<OperationCancelled<void>>());
        platform.writeGate.complete();
        await platform.finished.future;
        expect(await storage.read(StorageKey.localProfile).result, 'committed');
        expect(results.deliveries, 0);
        expect(results.errors, isEmpty);
      },
    );

    test('blank persisted name is incomplete without losing the ID', () {
      final profile = ProfileCodec.decode(
        '{"version":1,"id":"6fa459ea-ee8a-4ca4-894e-db77e160355e","name":"   "}',
      );
      expect(profile.isComplete, isFalse);
      expect(profile.id.value.value, '6fa459ea-ee8a-4ca4-894e-db77e160355e');
    });

    test('missing persisted name is incomplete without losing the ID', () {
      final profile = ProfileCodec.decode(
        '{"version":1,"id":"6fa459ea-ee8a-4ca4-894e-db77e160355e"}',
      );
      expect(profile.isComplete, isFalse);
      expect(profile.id.value.value, '6fa459ea-ee8a-4ca4-894e-db77e160355e');
    });

    test('unknown schema or missing ID is never treated as a new profile', () {
      for (final payload in [
        '{"version":2,"id":"6fa459ea-ee8a-4ca4-894e-db77e160355e","name":"Иван"}',
        '{"version":1,"name":"Иван"}',
        '{"version":1,"id":"broken","name":"Иван"}',
      ]) {
        expect(
          () => ProfileCodec.decode(payload),
          throwsA(
            isA<ProfileException>().having(
              (failure) => failure.reason,
              'reason',
              ProfileFailureReason.corrupt,
            ),
          ),
        );
      }
    });
  }

  static void _install(SharedPreferencesAsyncPlatform platform) {
    final previous = SharedPreferencesAsyncPlatform.instance;
    SharedPreferencesAsyncPlatform.instance = platform;
    addTearDown(() => SharedPreferencesAsyncPlatform.instance = previous);
  }
}

final class _FailingPreferences extends InMemorySharedPreferencesAsync {
  _FailingPreferences.empty() : super.empty();

  @override
  Future<String?> getString(String key, SharedPreferencesOptions options) =>
      Future.error(StateError('Native store unavailable'));
}

final class _PendingWritePreferences extends InMemorySharedPreferencesAsync {
  _PendingWritePreferences.empty() : super.empty();

  final Completer<void> writeGate = Completer();
  final Completer<void> finished = Completer();

  @override
  Future<bool> setString(
    String key,
    String value,
    SharedPreferencesOptions options,
  ) async {
    await writeGate.future;
    final result = await super.setString(key, value, options);
    finished.complete();
    return result;
  }
}

final class _WriteResults {
  int deliveries = 0;
  final List<Object> errors = [];

  void accept(void value) => deliveries++;

  void fail(Object error, StackTrace stackTrace) => errors.add(error);
}
