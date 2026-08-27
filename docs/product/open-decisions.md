# Открытые решения

Эти вопросы нельзя молча решать в коде. Каждое закрытие содержит выбранное решение, дату, владельца и ссылку на обновлённый канонический документ/ADR.

## Блокируют foundation

| ID | Вопрос | Почему важно | До какого этапа закрыть |
|---|---|---|---|
| OD-002 | Какой versioned URI/code, entropy, expiry и session binding используются для Participant? | Определяет безопасность и reconnect contract. | До LAN transport |
| OD-003 | Как устроены request/handshake/error envelopes, idempotency и protocol compatibility? | Без этого Host может применить duplicate command или принять несовместимый client. | До Participant flow |
| OD-004 | Как исправление результата инвалидирует DE/SE progression и уже созданные events? | Определяет корректность bracket и snapshots. | До result correction |

## Блокируют format engines

| ID | Вопрос | Безопасный default запрещён потому что |
|---|---|---|
| OD-005 | Какие значения разрешены для DE/SE main FT и final FT? | Значения влияют на validation, UI и snapshot schema. |
| OD-006 | Как ранжируются участники DE, выбывшие на одной стадии? | «Full ranking» не определяет exact place либо place range. |
| OD-007 | Хранятся ли отдельные bouts/score в DE/SE или только winner серии? | Влияет на correction, history и spectator. |
| OD-008 | Нужен ли safety mechanism для бесконечно повторяющегося RR tie-break? | Любой лимит или random fallback меняет спортивное правило. |

## Нормализованные противоречия источника

| ID | Решение | Канон |
|---|---|---|
| OD-001 | Terminal history insert и удаление active snapshot/log выполняются одной DB transaction; terminal event публикуется только после commit. | [Data and protocol](../data/README.md#terminal-normalization) |

## Блокируют production release

| ID | Вопрос | Требуемый артефакт |
|---|---|---|
| OD-009 | Какие OS и минимальные версии входят в MVP? | Platform support matrix и CI jobs. |
| OD-010 | Как лицензируются и распространяются fighter artwork и Mortal Kombat naming? | Legal/asset approval. |
| OD-011 | Какой font/fallback используется одинаково во Flutter и Web? | Typography tokens и license record. |
| OD-012 | Каковы limits active event log и spectator connections? | Capacity test и fallback policy. |
| OD-013 | Как обрабатываются port conflict, interface change и app background? | Host server lifecycle contract. |
| OD-014 | Какие поля profile разрешено публиковать Participant/Spectator? | Projection/privacy schema. |

## Шаблон закрытия

```markdown
- Статус: Закрыто
- Решение: ...
- Дата и владелец: ...
- Канон/ADR: ...
- Contracts/tests: ...
```
