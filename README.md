# TournamentHUB

Приложение для ведения локальных турниров по Mortal Kombat 11: помогает организатору учитывать соревнование, а игрокам и зрителям — понимать его состояние. [Назначение и роли пользователей](docs/product/overview.md).

## Правила приложения

[Базовые правила турниров MK11](docs/source/mk11_tournament_rules_ru.md) — источник требований к турнирному поведению приложения. Общая документация: [docs](docs/README.md).

## Локальная разработка

Единый интерфейс команд находится в корневом `Makefile`:

- `make run` — запустить приложение для платформы текущего компьютера.
- `make run PLATFORM=web` — запустить Web-версию.
- `make build` — собрать нативную desktop-версию текущего компьютера.
- `make build-macos`, `make build-windows`, `make build-linux` — собрать соответствующую desktop-версию на её нативной платформе.
- `make analyze` — проверить Dart-код анализатором.
- `make domain-check` — открыть интерактивную карту Domain-архитектуры.

Полный перечень команд: `make help`.

В VS Code доступны профили **TournamentHUB** и **Widgetbook**. Настройка отдельного каталога описана в [руководстве Widgetbook](docs/development/widgetbook.md).
