import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/application/persistence/models/persisted_command_result.dart';
import 'package:tournament_hub_app/application/persistence/models/persisted_history_snapshot.dart';
import 'package:tournament_hub_app/application/persistence/models/persisted_tournament_event.dart';
import 'package:tournament_hub_app/application/persistence/models/persisted_tournament_snapshot.dart';
import 'package:tournament_hub_app/application/persistence/ports/active_tournament_store.dart';
import 'package:tournament_hub_app/infrastructure/database/tournament_hub_database.dart';
import 'package:tournament_hub_app/infrastructure/persistence/drift_active_tournament_store.dart';
import 'package:tournament_hub_app/infrastructure/persistence/drift_tournament_history_store.dart';

void main() {
  late TournamentHubDatabase database;
  late DriftActiveTournamentStore active;
  late DriftTournamentHistoryStore history;

  setUp(() {
    database = TournamentHubDatabase.memory();
    active = DriftActiveTournamentStore(database);
    history = DriftTournamentHistoryStore(database);
  });

  tearDown(() => database.close());

  test(
    'active mutation persists snapshot event and command atomically',
    () async {
      final result = await active.commitMutation(
        expectedRevision: 0,
        snapshot: snapshot(revision: 1),
        events: [event(sequence: 1, revision: 1)],
        commandResult: command(revision: 1),
      );
      expect(result.status, ActiveCommitStatus.committed);
      expect((await active.readActive())?.revision, 1);
      expect(
        await active.readEventsAfter(tournamentId: 't1', sequence: 0),
        hasLength(1),
      );
    },
  );

  test(
    'duplicate command returns stored result without second mutation',
    () async {
      await active.commitMutation(
        expectedRevision: 0,
        snapshot: snapshot(revision: 1),
        events: [event(sequence: 1, revision: 1)],
        commandResult: command(revision: 1),
      );
      final duplicate = await active.commitMutation(
        expectedRevision: 1,
        snapshot: snapshot(revision: 2),
        events: [event(sequence: 2, revision: 2)],
        commandResult: command(revision: 2),
      );
      expect(duplicate.status, ActiveCommitStatus.duplicateCommand);
      expect(duplicate.commandResult.revision, 1);
      expect((await active.readActive())?.revision, 1);
    },
  );

  test('revision conflict rolls back snapshot and event writes', () async {
    await active.commitMutation(
      expectedRevision: 0,
      snapshot: snapshot(revision: 1),
      events: [event(sequence: 1, revision: 1)],
      commandResult: command(revision: 1),
    );
    expect(
      () => active.commitMutation(
        expectedRevision: 0,
        snapshot: snapshot(revision: 1),
        events: [event(sequence: 2, revision: 1, id: 'event-2')],
        commandResult: command(revision: 1, id: 'command-2'),
      ),
      throwsA(isA<RevisionConflict>()),
    );
    expect((await active.readActive())?.revision, 1);
    expect(
      await active.readEventsAfter(tournamentId: 't1', sequence: 0),
      hasLength(1),
    );
  });

  test(
    'constraint failure after snapshot upsert rolls transaction back',
    () async {
      await active.commitMutation(
        expectedRevision: 0,
        snapshot: snapshot(revision: 1),
        events: [event(sequence: 1, revision: 1)],
        commandResult: command(revision: 1),
      );
      await expectLater(
        active.commitMutation(
          expectedRevision: 1,
          snapshot: snapshot(revision: 2),
          events: [event(sequence: 2, revision: 2)],
          commandResult: command(revision: 2, id: 'command-2'),
        ),
        throwsA(anything),
      );
      expect((await active.readActive())?.revision, 1);
      expect(
        await active.readEventsAfter(tournamentId: 't1', sequence: 0),
        hasLength(1),
      );
    },
  );

  test('terminal commit dedupes history and removes all active rows', () async {
    await active.commitMutation(
      expectedRevision: 0,
      snapshot: snapshot(revision: 1),
      events: [event(sequence: 1, revision: 1)],
      commandResult: command(revision: 1),
    );
    final terminalSnapshot = snapshot(revision: 2, lifecycle: 'finished');
    final terminalEvent = event(
      sequence: 2,
      revision: 2,
      id: 'terminal',
      type: 'tournament.finished',
    );
    final first = await history.commitTerminal(
      history: PersistedHistorySnapshot(
        snapshot: terminalSnapshot,
        finishedAtUtc: now.add(const Duration(minutes: 2)),
      ),
      terminalEvent: terminalEvent,
    );
    final repeated = await history.commitTerminal(
      history: PersistedHistorySnapshot(
        snapshot: terminalSnapshot,
        finishedAtUtc: now.add(const Duration(minutes: 2)),
      ),
      terminalEvent: terminalEvent,
    );
    expect(first.inserted, isTrue);
    expect(repeated.inserted, isFalse);
    expect(await active.readActive(), isNull);
    expect(
      await active.readEventsAfter(tournamentId: 't1', sequence: 0),
      isEmpty,
    );
    expect(await history.readAll(), hasLength(1));
  });

  test('schema v1 upgrades without losing local profile', () async {
    await database.close();
    final migrated = TournamentHubDatabase(
      NativeDatabase.memory(
        setup: (raw) {
          raw.execute(
            'CREATE TABLE local_profile (singleton_id INTEGER PRIMARY KEY, profile_id TEXT NOT NULL UNIQUE, nickname TEXT NOT NULL, schema_version INTEGER NOT NULL)',
          );
          raw.execute("INSERT INTO local_profile VALUES (1, 'p1', 'Иво', 1)");
          raw.userVersion = 1;
        },
      ),
    );
    addTearDown(migrated.close);
    final rows = await migrated.select(migrated.localProfiles).get();
    expect(rows.single.nickname, 'Иво');
    expect(
      await migrated.select(migrated.activeTournamentSnapshots).get(),
      isEmpty,
    );
  });
}

final now = DateTime.utc(2026, 8, 30, 12);

PersistedTournamentSnapshot snapshot({
  required int revision,
  String lifecycle = 'draft',
}) => PersistedTournamentSnapshot(
  schemaVersion: 1,
  tournamentId: 't1',
  revision: revision,
  formatId: 'round-robin',
  rulesetVersion: 1,
  lifecycle: lifecycle,
  createdAtUtc: now,
  updatedAtUtc: now.add(Duration(minutes: revision)),
  payload: const {'localProfileId': 'p1', 'title': 'Cup'},
);

PersistedTournamentEvent event({
  required int sequence,
  required int revision,
  String id = 'event-1',
  String type = 'tournament.updated',
}) => PersistedTournamentEvent(
  eventId: id,
  tournamentId: 't1',
  sequence: sequence,
  revision: revision,
  eventVersion: 1,
  type: type,
  timestampUtc: now,
  payload: const {'state': 'draft'},
);

PersistedCommandResult command({
  required int revision,
  String id = 'command-1',
}) => PersistedCommandResult(
  commandId: id,
  tournamentId: 't1',
  revision: revision,
  payload: const {'ok': true},
);
