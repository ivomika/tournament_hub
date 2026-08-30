# Data, persistence and realtime

## Logical stores

1. Local Profile.
2. Active Tournament Snapshot.
3. Active Event Log.
4. Processed Command IDs/idempotency records.
5. Participant read-only cache/binding.
6. Tournament History.
7. App Settings.

Один universal repository запрещён. Ports проектируются по consistency boundary/use case, а не по таблице.

## Snapshot contract

Каждый persisted/network snapshot содержит как минимум:

```text
schemaVersion
tournamentId
revision
ruleset: { formatId, version }
state
createdAtUtc
updatedAtUtc
payload
```

Domain models не сериализуются напрямую. Mapper валидирует required fields, enums, IDs, revision и cross-field constraints до restore.

## Atomic active mutation

```text
BEGIN
  verify expected revision
  apply domain operation in memory
  upsert complete active snapshot at revision+1
  append event(s) with contiguous sequence
  record commandId/result for idempotency
COMMIT
broadcast committed events
```

При любой ошибке до commit всё откатывается. После commit publish failure не меняет truth; reconnect получает snapshot или missing events.

## Terminal normalization

Противоречие исходного Design Doc нормализуется обязательным правилом commit-before-broadcast:

```text
build terminal snapshot/event in memory
BEGIN
  insert immutable history snapshot (dedupe tournamentId)
  delete active snapshot
  delete active event log/idempotency rows
COMMIT
publish terminal event/projection
```

Terminal payload сохраняется в memory/outbox-подобном application result до публикации. Broadcast до commit запрещён. Повтор Finish после crash распознаётся по history tournamentId и не создаёт duplicate.

## History

- Immutable append/dedupe по tournament ID.
- Snapshot self-contained: profile/roster/ruleset current records не являются live references.
- Хранит фактические settings, participant nicknames/sources, fighter metadata/assets reference, structure, results, order, tie-breaks, places и terminal state.
- Derived statistics пересчитываются из history; cache проекции можно удалить и восстановить.
- Clear history — одна explicit transaction. Individual delete отсутствует.

## Schema evolution

- Version numbers монотонны и никогда не переиспользуются.
- Последовательная migration `vN -> vN+1`; skip реализуется цепочкой.
- Migration меняет representation, не переигрывает updated business rules.
- Перед release fixtures всех опубликованных schema проходят upgrade tests.
- Destructive fallback запрещён без explicit user decision, backup/export и release note.
- Generated Drift files меняются codegen, не вручную.

## Time and ordering

- Persisted time — ISO-8601 UTC либо epoch с явной unit; offset может храниться для display.
- Business/protocol ordering — revision/sequence, не wall clock.
- Clock injectable; системный rollback не уменьшает revision/sequence.
- UI локализует время на presentation boundary.

## Identifiers

Typed stable IDs: profile, tournament, participant, guest, match, fighter, event, command, session. Nickname/title не identity. UUID допустим для distributed IDs; deterministic engine IDs могут выводиться из tournament + stable slot, если contract versioned.

## Protocol envelope

Полный канонический WebSocket-контракт v1: [websocket-protocol-v1.md](websocket-protocol-v1.md).

До закрытия OD-002/OD-003 wire implementation не считается стабильной. Минимальная общая оболочка:

```json
{
  "protocolVersion": 1,
  "kind": "handshake|request|event|error",
  "messageId": "uuid",
  "tournamentId": "uuid-or-null",
  "sentAt": "UTC instant",
  "payload": {}
}
```

Request дополнительно содержит `requestId`, `commandId`, actor/session identity и `expectedRevision`. Event содержит `eventVersion`, `eventId`, `sequence`, `revision`, stable `type`. Error содержит correlated request ID, stable code, retryability и безопасные details.

## Handshake and sync

1. Client заявляет supported protocol range, role intent, tournament/session data и last sequence.
2. Host валидирует lifecycle/identity/version.
3. Host отвечает full role-specific snapshot + current revision/sequence либо compatible replay plan.
4. Client атомарно заменяет cache snapshot и затем применяет только contiguous events.
5. Duplicate event ID/sequence игнорируется; gap переводит client в stale/syncing и требует full snapshot/replay.

Reconnect никогда не доверяет client-computed state. Если log range утрачен, Host отправляет full snapshot.

## Role projections

- Host projection может включать operational queue и full assignments.
- Participant получает только разрешённую public roster и собственные private/operational данные.
- Spectator получает public tournament presentation без profile IDs, local history, settings, addresses и diagnostic metadata.
- Guest не имеет network projection identity.

Каждая projection имеет отдельный DTO/schema test. Нельзя сериализовать internal snapshot и «скрыть пару полей» в UI.

## Event log

Event log active-only и bounded; точный limit — OD-012. Он поддерживает contiguous replay, затем full snapshot fallback. После terminal commit удаляется. Permanent event sourcing, analytics history и audit reconstruction из event log запрещены.

## Participant cache

- Read-only last-known projection + tournament/session binding + sequence.
- Stale marker не хранится как authoritative state; он выводится из connection state.
- Disconnect ничего не удаляет и не создаёт technical result.
- «Прекратить попытки подключения» закрывает local binding отдельным local reason; не создаёт Host `Cancelled`.

## Settings storage

`shared_preferences` разрешён только для non-critical preferences. Profile, active/history/cache/event log/idempotency запрещены. Reset account должен удалить все owned stores crash-safe и вернуть Registration.

## Backup and privacy

Local DB не добавляется в git/logs/tasks. Diagnostics редактирует IDs/payload. Экспорт/backup не входит в MVP до отдельного encrypted format decision. Тестовые fixtures содержат synthetic data.
