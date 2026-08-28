# Tournament Hub

Local-first система проведения турниров Mortal Kombat 11: Flutter Host/Participant и read-only React Spectator Web в локальной сети.

## Состояние репозитория

Репозиторий содержит нормативную документацию, обязательный task workflow, source assets, минимальный Flutter application skeleton в `apps/tournament_app` и read-only React/Vite skeleton в `apps/spectator_web`. Внутренние architecture/feature folders добавляются только вместе с соответствующей реализацией.

## Требования

- Flutter SDK с Dart SDK в `PATH`.
- Node.js и npm для Spectator Web.
- GNU Make. На Windows подходит GNU Make из Chocolatey/MSYS2; команды внутри Makefile не зависят от Unix shell.
- Platform toolchain для выбранного Flutter target.

Переменные окружения `FLUTTER`, `DART` и `NPM` позволяют переопределить имена/пути executables.

## Команды

```text
make help
make setup
make sync-fighter-assets
make run
make run DEVICE=windows
make run-widgetbook
make run-widgetbook DEVICE=windows
make run-spectator
make build
make build TARGET=web
make build-flutter TARGET=windows
make build-spectator
make format
make lint
make test
make check
make clean
```

`make run` запускает Flutter, `make run-spectator` — Vite development server. `make run` без `DEVICE` передаёт выбор доступного device Flutter. Общий `make build` последовательно собирает Flutter и Spectator Web; без `TARGET` Flutter выбирает desktop target текущего host. Для изолированной сборки есть `build-flutter` и `build-spectator`. Явно поддерживаемые Flutter build targets: `apk`, `appbundle`, `ios`, `linux`, `macos`, `web`, `windows`. Наличие runner не является обещанием production support: release matrix остаётся отдельным решением OD-009.

Widgetbook запускается отдельным entry point через `make run-widgetbook`. Внутри каталога доступны project viewports `Mobile` и `Desktop`, design tokens, reusable components и screen previews. VS Code configurations `Flutter: Tournament Hub` и `Flutter: Widgetbook` запускают entry points независимо и позволяют выбрать Flutter device стандартным способом.

`make sync-fighter-assets` валидирует read-only source manifest и создаёт проверяемую Flutter runtime copy всех fighter PNG. `make setup` выполняет синхронизацию, а `make check` обнаруживает stale, missing или лишние runtime assets.

## Начало работы

1. Прочитайте [`AGENTS.md`](AGENTS.md).
2. Откройте [`ai-context/task-list.md`](ai-context/task-list.md) и заведите/выберите задачу.
3. Прочитайте router, core и сработавшие conditional [`ai-context/rules`](ai-context/rules/README.md).
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
