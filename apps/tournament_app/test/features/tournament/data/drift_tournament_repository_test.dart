import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/data/repositories/drift_local_profile_repository.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/data/repositories/drift_tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';

void main() {
  late Directory temporaryDirectory;

  setUp(() async {
    temporaryDirectory = await Directory.systemTemp.createTemp(
      'tournament-hub-test-',
    );
  });

  tearDown(() async {
    await temporaryDirectory.delete(recursive: true);
  });

  test('сохраняет и обновляет active draft без дубликатов', () async {
    final database = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftTournamentRepository(database);
    final initial = _draft('Первый', ['Гость']);
    final updated = _draft('Обновлённый', ['Первый', 'Второй']);

    await repository.saveActiveDraft(initial);
    await repository.saveActiveDraft(updated);

    expect(await repository.getActiveDraft(), updated);
    expect(
      await database.select(database.tournamentDrafts).get(),
      hasLength(1),
    );
    expect(
      await database.select(database.tournamentParticipants).get(),
      hasLength(3),
    );
  });

  test('восстанавливает draft после повторного открытия файла', () async {
    final file = File('${temporaryDirectory.path}/reopen.sqlite');
    final firstDatabase = AppDatabase(executor: NativeDatabase(file));
    final draft = _draft('Перезапуск', ['Гость']);
    await DriftTournamentRepository(firstDatabase).saveActiveDraft(draft);
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(executor: NativeDatabase(file));
    addTearDown(reopenedDatabase.close);

    expect(
      await DriftTournamentRepository(reopenedDatabase).getActiveDraft(),
      draft,
    );
  });

  test('migration v1 сохраняет существующий local profile', () async {
    final file = File('${temporaryDirectory.path}/migration.sqlite');
    final sqlite = sqlite3.open(file.path);
    sqlite.execute('''
      CREATE TABLE local_profiles (
        id TEXT NOT NULL PRIMARY KEY,
        nickname TEXT NOT NULL
      );
    ''');
    sqlite.execute(
      "INSERT INTO local_profiles (id, nickname) VALUES ('local-1', 'Игрок');",
    );
    sqlite.execute('PRAGMA user_version = 1;');
    sqlite.close();

    final database = AppDatabase(executor: NativeDatabase(file));
    addTearDown(database.close);
    final profile = await DriftLocalProfileRepository(database).getProfile();

    expect(profile?.id.value, 'local-1');
    expect(profile?.nickname.value, 'Игрок');
    expect(database.schemaVersion, 2);
    expect(await database.select(database.tournamentDrafts).get(), isEmpty);
  });
}

TournamentDraft _draft(String name, List<String> guestNames) {
  final owner = LocalProfile.create(id: 'local-1', nickname: 'Владелец');
  return TournamentDraft(
    id: TournamentId('tournament-1'),
    name: TournamentName(name),
    participants: [
      TournamentParticipant.fromLocalProfile(owner),
      for (final (index, nickname) in guestNames.indexed)
        TournamentParticipant.fromGuestProfile(
          GuestProfile.create(id: 'guest-$index', nickname: nickname),
        ),
    ],
  );
}
