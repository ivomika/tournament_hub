# Открытые решения

Эти вопросы нельзя молча решать в коде. Каждое закрытие содержит выбранное решение, дату, владельца и ссылку на обновлённый канонический документ/ADR.

## Блокируют foundation

| ID | Вопрос | Почему важно | До какого этапа закрыть |
|---|---|---|---|
| OD-002 | Какой versioned URI/code, entropy, expiry и session binding используются для Participant? | Определяет безопасность и reconnect contract. | До LAN transport |
| OD-003 | Как устроены request/handshake/error envelopes, idempotency и protocol compatibility? | Без этого Host может применить duplicate command или принять несовместимый client. | До Participant flow |

## Нормализованные противоречия источника

| ID | Решение | Канон |
|---|---|---|
| OD-001 | Terminal history insert и удаление active snapshot/log выполняются одной DB transaction; terminal event публикуется только после commit. | [Data and protocol](../data/README.md#terminal-normalization) |

## Закрытые Domain decisions

| ID | Решение | Дата и владелец | Канон и verification |
|---|---|---|---|
| OD-005 | DE/SE main FT — positive integer, default FT1; final FT — independent positive integer, default main FT; DE reset использует final FT. | 2026-08-30, product owner via Design Doc | [Format engine v1](../domain/format-engine-v1.md), settings validation tests |
| OD-006 | Выбывшие на одной стадии DE делят place range; искусственный tie-break не добавляется. | 2026-08-30, product owner via full-ranking requirement | [Format engine v1](../domain/format-engine-v1.md), ranking fixtures |
| OD-007 | Normal result хранит winner/loser и фактический score серии; technical result score не имеет. | 2026-08-30, product owner via FT/result/history requirements | [Format engine v1](../domain/format-engine-v1.md), result validation/replay tests |
| OD-008 | Mini-RR повторяется для tied subgroup без iteration limit, random fallback или жребия. | 2026-08-30, product owner via explicit Design Doc rule | [Format engine v1](../domain/format-engine-v1.md), repeated tie fixture |
| OD-004 | Correction replay-ит results от initial seed, заменяя target result; Finished downstream запрещает correction. Event log append-only: atomic mutation пишет новый snapshot/revision и correction event, не изменяя старые events. | 2026-08-30, product owner via Design Doc + commit-before-success contract | [Format engine v1](../domain/format-engine-v1.md), [Data contract](../data/README.md#result-correction), replay/downstream/atomic tests |

## Блокируют production release

| ID | Вопрос | Требуемый артефакт |
|---|---|---|
| OD-009 | Какие OS и минимальные версии входят в MVP? | Platform support matrix и CI jobs. |
| OD-010 | Как лицензируются и распространяются fighter artwork и Mortal Kombat naming? | Legal/asset approval. |
| OD-011 | Какой font/fallback используется одинаково во Flutter и Web? | Typography tokens и license record. |
| OD-013 | Как обрабатываются port conflict, interface change и app background? | Host server lifecycle contract. |

## Закрытые Spectator decisions

| ID | Решение | Дата и владелец | Канон и verification |
|---|---|---|---|
| OD-012 (Spectator) | Protocol-level число connections не ограничено; replay window 4096 public events, затем full snapshot; inbound/outbound limits зафиксированы SPEC-001. | 2026-08-30, product owner + task 098 | [WebSocket v1](../data/websocket-protocol-v1.md#решения-spec-001--spec-002), schema/replay/security tests; runtime capacity — 099 |
| OD-014 (Spectator) | Публикуется только allowlisted tournament-scoped projection; profile/local/network/diagnostic fields запрещены. Participant privacy остаётся вне MVP. | 2026-08-30, product owner + task 098 | [WebSocket v1](../data/websocket-protocol-v1.md#spectator-projection), redaction/schema tests |

## Шаблон закрытия

```markdown
- Статус: Закрыто
- Решение: ...
- Дата и владелец: ...
- Канон/ADR: ...
- Contracts/tests: ...
```
