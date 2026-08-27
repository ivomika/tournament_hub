# Tournament Hub

Local-first система проведения турниров Mortal Kombat 11: Flutter Host/Participant и read-only React Spectator Web в локальной сети.

## Состояние репозитория

Текущая ветка содержит нормативную документацию, обязательный task workflow и source assets. Application skeleton ещё не восстановлен/создан, поэтому команды `make setup/check/run/build` пока являются запланированным interface, а не готовыми командами.

## Начало работы

1. Прочитайте [`AGENTS.md`](AGENTS.md).
2. Откройте [`ai-context/task-list.md`](ai-context/task-list.md) и заведите/выберите задачу.
3. Прочитайте все [`ai-context/rules`](ai-context/rules/README.md).
4. Изучите карту [`docs/README.md`](docs/README.md) и open decisions.
5. Реализуйте только scope активной карточки и зафиксируйте проверки.

## Документация

- [Полная карта проекта](docs/README.md)
- [Аудит исходного Design Doc](docs/audit/design-doc-audit.md)
- [Product guide](docs/product/README.md)
- [Architecture guide](docs/architecture/README.md)
- [Tournament rules](docs/domain/tournament-rules.md)
- [Design system](docs/design/README.md)
- [План реализации](docs/roadmap/implementation-plan.md)

`docs/source` — неизменяемый reference. Рабочие требования берутся из нормализованной документации.

## Главные инварианты

- Host — единственный source of truth.
- Domain — чистый Dart; DE/SE/RR, tie-break и assignment являются versioned/replaceable contracts.
- Active mutation атомарно сохраняется до broadcast/UI success.
- Participant/Spectator не содержат tournament engine.
- Finished/Cancelled history immutable и воспроизводима.
- После assignment participant всегда отображается с fighter artwork, fighter name и nickname.
- Одна задача `В работе`, один логический commit и только по прямому запросу.
