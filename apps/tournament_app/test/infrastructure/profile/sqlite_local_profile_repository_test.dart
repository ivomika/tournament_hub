import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/domain/profile/local_profile.dart';
import 'package:tournament_hub_app/infrastructure/database/tournament_hub_database.dart'
    hide LocalProfile;
import 'package:tournament_hub_app/infrastructure/profile/drift_local_profile_repository.dart';

void main() {
  late TournamentHubDatabase database;
  late DriftLocalProfileRepository repository;

  setUp(() {
    database = TournamentHubDatabase.memory();
    repository = DriftLocalProfileRepository(Future.value(database));
  });

  tearDown(() => database.close());

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
