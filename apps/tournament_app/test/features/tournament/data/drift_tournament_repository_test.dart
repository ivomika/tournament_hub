import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/data/repositories/drift_local_profile_repository.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/standings/domain/services/mvp_tournament_ruleset.dart';
import 'package:tournament_app/features/tournament/application/start_tournament.dart';
import 'package:tournament_app/features/tournament/data/repositories/drift_tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_storage_exception.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
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

  test('восстанавливает сетку, бойцов и результаты после reopen', () async {
    final file = File('${temporaryDirectory.path}/active-reopen.sqlite');
    final firstDatabase = AppDatabase(executor: NativeDatabase(file));
    final repository = DriftTournamentRepository(firstDatabase);
    var tournament = _activeTournament();
    final firstMatch = tournament.matches.first;
    tournament = tournament.replaceMatch(
      firstMatch.recordBout(
        winnerId: firstMatch.scheduledMatch.firstParticipantId,
        updateId: MatchUpdateId('bout-1'),
      ),
    );
    final secondMatch = tournament.matches[1];
    tournament = tournament.replaceMatch(
      secondMatch.applyTechnicalResult(
        winnerId: secondMatch.scheduledMatch.secondParticipantId,
        updateId: MatchUpdateId('technical-1'),
      ),
    );

    await repository.saveActiveTournament(tournament);
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(executor: NativeDatabase(file));
    addTearDown(reopenedDatabase.close);
    final restored = await DriftTournamentRepository(reopenedDatabase)
        .getActiveTournament();

    expect(restored, tournament);
    expect(restored!.matches.first.bouts, hasLength(1));
    expect(
      restored.matches[1].result.runtimeType,
      tournament.matches[1].result.runtimeType,
    );
  });

  test('новый draft атомарно заменяет прежний active tournament', () async {
    final database = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftTournamentRepository(database);
    await repository.saveActiveTournament(_activeTournament());
    final newDraft = _draft('Новый турнир', [
      'Новый гость',
    ], id: 'tournament-2');
    final newSetup = TournamentSetup(
      tournamentId: newDraft.id,
      schedule: const RoundRobinTournamentRules().createSchedule(
        newDraft.participants.map((participant) => participant.id),
      ),
      fighterAssignments: [
        for (final (index, participant) in newDraft.participants.indexed)
          FighterAssignment(
            participantId: participant.id,
            fighterId: FighterId('new-fighter-$index'),
          ),
      ],
    );

    await repository.saveActiveDraft(newDraft);
    expect(await repository.getActiveTournament(), isNull);

    final started = await StartTournament(repository).execute(
      draft: newDraft,
      setup: newSetup,
      rulesetId: 'mvp-round-robin',
      rulesetVersion: 1,
    );

    expect(await repository.getActiveTournament(), started);
  });

  test('игнорирует устаревший active marker от другого draft', () async {
    final database = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftTournamentRepository(database);
    final draft = _draft('Новый турнир', ['Новый гость'], id: 'tournament-2');
    await repository.saveActiveDraft(draft);
    await database.customStatement('PRAGMA foreign_keys = OFF;');
    await database.customStatement('''
      INSERT INTO active_tournaments (
        tournament_id,
        ruleset_id,
        ruleset_version
      ) VALUES ('stale-tournament', 'mvp-round-robin', 1);
    ''');

    expect(await repository.getActiveTournament(), isNull);
  });

  test('повтор update id не добавляет дубликат схватки', () async {
    final database = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftTournamentRepository(database);
    var tournament = _activeTournament();
    final match = tournament.matches.first;
    final updateId = MatchUpdateId('duplicate');
    final once = match.recordBout(
      winnerId: match.scheduledMatch.firstParticipantId,
      updateId: updateId,
    );
    final twice = once.recordBout(
      winnerId: match.scheduledMatch.secondParticipantId,
      updateId: updateId,
    );

    tournament = tournament.replaceMatch(twice);
    await repository.saveActiveTournament(tournament);

    final restored = await repository.getActiveTournament();
    expect(restored!.matches.first.bouts, hasLength(1));
    expect(restored.matches.first.appliedUpdateIds, {updateId});
  });

  test('атомарно сохраняет и восстанавливает завершённый snapshot', () async {
    final file = File('${temporaryDirectory.path}/finished-reopen.sqlite');
    final firstDatabase = AppDatabase(executor: NativeDatabase(file));
    final firstRepository = DriftTournamentRepository(firstDatabase);
    final tournament = _completedTournament();
    final snapshot = FinishedTournamentSnapshot(
      tournament: tournament,
      outcome: MvpTournamentRuleset.instance.calculate(tournament),
    );

    await firstRepository.saveActiveTournament(tournament);
    await firstRepository.saveFinishedTournament(snapshot);
    await firstRepository.saveFinishedTournament(snapshot);

    expect(await firstRepository.getActiveTournament(), isNull);
    expect(
      await firstDatabase.select(firstDatabase.tournamentHistoryRecords).get(),
      hasLength(1),
    );
    await firstDatabase.close();

    final reopenedDatabase = AppDatabase(executor: NativeDatabase(file));
    addTearDown(reopenedDatabase.close);
    final restored = await DriftTournamentRepository(reopenedDatabase)
        .getFinishedTournament();

    expect(restored, snapshot);
  });

  test('хранит несколько завершённых турниров от новых к старым', () async {
    final database = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftTournamentRepository(database);
    final firstTournament = _completedTournament();
    final firstSnapshot = FinishedTournamentSnapshot(
      tournament: firstTournament,
      outcome: MvpTournamentRuleset.instance.calculate(firstTournament),
    );
    final secondTournament = _completedTournament(
      id: 'tournament-2',
      name: 'Второй турнир',
    );
    final secondSnapshot = FinishedTournamentSnapshot(
      tournament: secondTournament,
      outcome: MvpTournamentRuleset.instance.calculate(secondTournament),
    );

    await repository.saveActiveTournament(firstTournament);
    await repository.saveFinishedTournament(firstSnapshot);
    await repository.saveActiveTournament(secondTournament);
    await repository.saveFinishedTournament(secondSnapshot);
    await repository.saveFinishedTournament(secondSnapshot);

    final history = await repository.getHistory();
    expect(history.map((item) => item.tournamentId.value), [
      'tournament-2',
      'tournament-1',
    ]);
    expect(history.first.name, 'Второй турнир');
    expect(history.first.participantCount, 3);
    expect(history.first.championFighterName, isNotEmpty);
    expect(
      await repository.getTournamentById(TournamentId('tournament-1')),
      firstSnapshot,
    );
    expect(await repository.getTournamentById(TournamentId('missing')), isNull);
    expect(
      await database.select(database.tournamentHistoryRecords).get(),
      hasLength(2),
    );
  });

  test('откатывает завершение целиком при ошибке history snapshot', () async {
    final database = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftTournamentRepository(database);
    final tournament = _completedTournament();
    final snapshot = FinishedTournamentSnapshot(
      tournament: tournament,
      outcome: MvpTournamentRuleset.instance.calculate(tournament),
    );
    await repository.saveActiveTournament(tournament);
    await database.customStatement('''
      CREATE TRIGGER reject_history_snapshot
      BEFORE INSERT ON tournament_history_records
      BEGIN
        SELECT RAISE(ABORT, 'тестовая ошибка');
      END;
    ''');

    await expectLater(
      repository.saveFinishedTournament(snapshot),
      throwsA(isA<TournamentStorageException>()),
    );

    expect(await repository.getActiveTournament(), tournament);
    expect(
      await database.select(database.tournamentHistoryRecords).get(),
      isEmpty,
    );
  });

  test('откатывает всю транзакцию при ошибке записи', () async {
    final database = AppDatabase(executor: NativeDatabase.memory());
    addTearDown(database.close);
    final repository = DriftTournamentRepository(database);
    var stored = _activeTournament();
    final match = stored.matches.first;
    stored = stored.replaceMatch(
      match.recordBout(
        winnerId: match.scheduledMatch.firstParticipantId,
        updateId: MatchUpdateId('stored'),
      ),
    );
    await repository.saveActiveTournament(stored);
    await database.customStatement('''
      CREATE TRIGGER reject_failed_update
      BEFORE INSERT ON match_updates
      WHEN NEW.update_id = 'fail'
      BEGIN
        SELECT RAISE(ABORT, 'тестовая ошибка');
      END;
    ''');
    final changedMatch = stored.matches.first.recordBout(
      winnerId: stored.matches.first.scheduledMatch.secondParticipantId,
      updateId: MatchUpdateId('fail'),
    );

    await expectLater(
      repository.saveActiveTournament(stored.replaceMatch(changedMatch)),
      throwsA(isA<TournamentStorageException>()),
    );

    expect(await repository.getActiveTournament(), stored);
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
    expect(database.schemaVersion, 6);
    expect(await database.select(database.tournamentDrafts).get(), isEmpty);
  });

  test('migration v2 сохраняет существующий tournament draft', () async {
    final file = File('${temporaryDirectory.path}/migration-v2.sqlite');
    final sqlite = sqlite3.open(file.path);
    sqlite.execute('''
      CREATE TABLE tournament_drafts (
        id TEXT NOT NULL PRIMARY KEY,
        name TEXT NOT NULL,
        status TEXT NOT NULL
      );
      CREATE TABLE tournament_participants (
        tournament_id TEXT NOT NULL REFERENCES tournament_drafts (id) ON DELETE CASCADE,
        participant_id TEXT NOT NULL,
        nickname TEXT NOT NULL,
        source TEXT NOT NULL,
        position INTEGER NOT NULL,
        PRIMARY KEY (tournament_id, participant_id, source)
      );
    ''');
    sqlite.execute(
      "INSERT INTO tournament_drafts VALUES ('tournament-1', 'Миграция', 'draft');",
    );
    sqlite.execute('''
      INSERT INTO tournament_participants VALUES
        ('tournament-1', 'local-1', 'Владелец', 'localProfile', 0),
        ('tournament-1', 'guest-0', 'Гость', 'guestProfile', 1);
    ''');
    sqlite.execute('PRAGMA user_version = 2;');
    sqlite.close();

    final database = AppDatabase(executor: NativeDatabase(file));
    addTearDown(database.close);

    expect(
      await DriftTournamentRepository(database).getActiveDraft(),
      _draft('Миграция', ['Гость']),
    );
    expect(await database.select(database.activeTournaments).get(), isEmpty);
  });

  test(
    'migration v3 сохраняет active marker и назначает ruleset MVP',
    () async {
      final file = File('${temporaryDirectory.path}/migration-v3.sqlite');
      final currentDatabase = AppDatabase(executor: NativeDatabase(file));
      await DriftTournamentRepository(currentDatabase)
          .saveActiveTournament(_activeTournament());
      await currentDatabase.close();

      final sqlite = sqlite3.open(file.path);
      sqlite.execute('PRAGMA foreign_keys = OFF;');
      sqlite.execute('DROP TABLE finished_standings;');
      sqlite.execute('DROP TABLE finished_tournaments;');
      sqlite.execute('''
      CREATE TABLE active_tournaments_v3 (
        tournament_id TEXT NOT NULL PRIMARY KEY
      );
      INSERT INTO active_tournaments_v3 (tournament_id)
        SELECT tournament_id FROM active_tournaments;
      DROP TABLE active_tournaments;
      ALTER TABLE active_tournaments_v3 RENAME TO active_tournaments;
      PRAGMA user_version = 3;
    ''');
      sqlite.close();

      final migratedDatabase = AppDatabase(executor: NativeDatabase(file));
      addTearDown(migratedDatabase.close);
      final restored = await DriftTournamentRepository(migratedDatabase)
          .getActiveTournament();

      expect(restored, _activeTournament());
      expect(restored!.rulesetId, 'mvp-round-robin');
      expect(restored.rulesetVersion, 1);
      expect(
        await migratedDatabase
            .select(migratedDatabase.finishedTournaments)
            .get(),
        isEmpty,
      );
    },
  );
}

ActiveTournament _activeTournament({
  String id = 'tournament-1',
  String name = 'Активный',
}) {
  final draft = _draft(name, ['Первый', 'Второй'], id: id);
  final participantIds = draft.participants.map(
    (participant) => participant.id,
  );
  final setup = TournamentSetup(
    tournamentId: draft.id,
    schedule: const RoundRobinTournamentRules().createSchedule(participantIds),
    fighterAssignments: [
      for (final (index, participant) in draft.participants.indexed)
        FighterAssignment(
          participantId: participant.id,
          fighterId: FighterId('fighter-$index'),
        ),
    ],
  );
  return ActiveTournament.fromSetup(draft: draft, setup: setup);
}

ActiveTournament _completedTournament({
  String id = 'tournament-1',
  String name = 'Активный',
}) {
  var tournament = _activeTournament(id: id, name: name);
  final participantOrder = {
    for (final (index, participant) in tournament.draft.participants.indexed)
      participant.id: index,
  };
  for (final match in tournament.matches) {
    final firstIndex =
        participantOrder[match.scheduledMatch.firstParticipantId]!;
    final secondIndex =
        participantOrder[match.scheduledMatch.secondParticipantId]!;
    final winnerId = firstIndex < secondIndex
        ? match.scheduledMatch.firstParticipantId
        : match.scheduledMatch.secondParticipantId;
    var completedMatch = match;
    for (var bout = 0; bout < 2; bout++) {
      completedMatch = completedMatch.recordBout(
        winnerId: winnerId,
        updateId: MatchUpdateId('${match.scheduledMatch.id.value}-bout-$bout'),
      );
    }
    tournament = tournament.replaceMatch(completedMatch);
  }
  return tournament;
}

TournamentDraft _draft(
  String name,
  List<String> guestNames, {
  String id = 'tournament-1',
}) {
  final owner = LocalProfile.create(id: 'local-1', nickname: 'Владелец');
  return TournamentDraft(
    id: TournamentId(id),
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
