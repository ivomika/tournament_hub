# Architecture enforcement

## Trigger

Изменение структуры, layers, dependency direction, ports/adapters, DI, authority, engines, Host/Participant/Spectator boundaries.

## Обязательно

- Назвать затронутые architectural boundaries в карточке.
- Следовать текущему architecture canon и зафиксировать проверку зависимостей.
- При изменении архитектуры создать/обновить ADR до реализации зависимого кода.

## Запрещено

- Дублировать architecture facts в этом rule.
- Менять authority/layer/technology boundary без ADR и migration consequences.
- Обходить boundary ради удобства UI или infrastructure.

## Канон

- [Architecture guide](../../docs/architecture/README.md)
- [ADR policy](../../docs/adr/README.md)

## Evidence

ADR или ссылка на неизменённый канон, dependency/fitness test и review затронутых imports/ports.
