import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/profile/data/repositories/drift_local_profile_repository.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';

void main() {
  group('DriftLocalProfileRepository', () {
    late AppDatabase database;
    late DriftLocalProfileRepository repository;

    setUp(() {
      database = AppDatabase(executor: NativeDatabase.memory());
      repository = DriftLocalProfileRepository(database);
    });

    tearDown(() => database.close());

    test('возвращает null, когда профиль отсутствует', () async {
      expect(await repository.getProfile(), isNull);
    });

    test('сохраняет и загружает профиль', () async {
      final profile = LocalProfile.create(id: 'profile-id', nickname: 'Игрок');

      await repository.saveProfile(profile);

      expect(await repository.getProfile(), profile);
    });

    test('обновляет nickname без создания второго профиля', () async {
      final profile = LocalProfile.create(id: 'profile-id', nickname: 'Игрок');
      await repository.saveProfile(profile);

      await repository.saveProfile(profile.rename('Новый nickname'));

      expect(await repository.getProfile(), profile.rename('Новый nickname'));
      expect((await database.select(database.localProfiles).get()).length, 1);
    });
  });

  test('восстанавливает профиль после повторного открытия базы', () async {
    final directory = await Directory.systemTemp.createTemp(
      'tournament_hub_profile_test_',
    );
    final file = File('${directory.path}/profile.sqlite');

    try {
      var database = AppDatabase(executor: NativeDatabase(file));
      var repository = DriftLocalProfileRepository(database);
      final profile = LocalProfile.create(id: 'profile-id', nickname: 'Игрок');

      await repository.saveProfile(profile);
      await database.close();

      database = AppDatabase(executor: NativeDatabase(file));
      repository = DriftLocalProfileRepository(database);

      expect(await repository.getProfile(), profile);
      await database.close();
    } finally {
      await directory.delete(recursive: true);
    }
  });
}
