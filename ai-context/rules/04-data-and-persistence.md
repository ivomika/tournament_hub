# Data and persistence enforcement

## Trigger

Изменение persisted state, DTO/mapper, transaction, history, cache, event log, version, time/ordering, schema или migration.

## Обязательно

- Зафиксировать consistency, compatibility, migration и recovery impact.
- Сохранять authoritative mutation в определённой каноном atomic boundary.
- Проверить round-trip, upgrade и failure/rollback paths.

## Запрещено

- Сериализовать Domain model напрямую.
- Переиспользовать опубликованную version или молча удалять пользовательские данные.
- Показывать success/broadcast до требуемого commit.

## Канон

- [Data and protocol](../../docs/data/README.md)

## Evidence

Versioned contract, migration/round-trip/fault tests и documented rollback/recovery.
