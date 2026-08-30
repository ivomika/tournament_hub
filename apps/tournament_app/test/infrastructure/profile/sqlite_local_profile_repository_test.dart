import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:tournament_hub_app/domain/profile/local_profile.dart';
import 'package:tournament_hub_app/infrastructure/profile/sqlite_local_profile_repository.dart';

void main() {
  late Database database;
  late SqliteLocalProfileRepository repository;

  setUp(() {
    database = sqlite3.openInMemory();
    repository = SqliteLocalProfileRepository(
      openDatabase: () async => database,
    );
  });

  tearDown(() => repository.dispose());

  test('profile survives repository round trip', () async {
    final profile = LocalProfile(id: 'profile-1', nickname: 'Иво');
    await repository.save(profile);
    expect(await repository.read(), profile);
    expect((await repository.readLocalProfile())?.nickname, 'Иво');
  });

  test('save updates nickname without replacing identity', () async {
    await repository.save(LocalProfile(id: 'profile-1', nickname: 'Иво'));
    await repository.save(LocalProfile(id: 'profile-1', nickname: 'Мика'));
    final restored = await repository.read();
    expect(restored?.id, 'profile-1');
    expect(restored?.nickname, 'Мика');
  });

  test('reset removes critical profile atomically', () async {
    await repository.save(LocalProfile(id: 'profile-1', nickname: 'Иво'));
    await repository.resetOwnedData();
    expect(await repository.read(), isNull);
  });
}
