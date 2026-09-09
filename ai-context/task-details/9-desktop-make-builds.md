# Задача 9. Добавить desktop-сборки в Makefile

## Статус

✅ Выполнена

## Цель

Сделать Makefile одинаково применимым на macOS, Windows и Linux для нативной сборки Flutter desktop-приложения.

## Контекст и границы

- Входит: определение текущей desktop-платформы, явные build-цели и защита от невозможной кросс-сборки.
- Не входит: настройка CI runners, подпись приложений и установка системных toolchain.

## Применимые правила

### Обязательные правила

- [x] [R-001 · SOLID](../rules/core/001-solid.md) — Makefile разделяет определение host-платформы, валидацию и команды сборки; aliases не дублируют логику Flutter build.
- [x] [R-002 · Документирование на русском](../rules/core/002-documentation-russian.md) — поведение нативных desktop-сборок и ограничения toolchain описаны в README и `docs/development`.

### Conditional rules

- Scan выполнен: conditional rules пока отсутствуют.

## Декомпозиция

- [x] Определить нативную desktop-платформу на macOS, Windows и Linux.
- [x] Добавить `build-macos`, `build-windows` и `build-linux`.
- [x] Ограничить desktop-сборку соответствующим host toolchain.
- [x] Проверить Makefile на macOS и завершить задачу.

## Критерии готовности

- [x] На macOS, Windows и Linux `make build` выбирает соответствующий desktop target.
- [x] Доступны явные нативные цели для трёх desktop-платформ.
- [x] Некорректная кросс-сборка завершается понятной ошибкой.
- [x] `make help`, сборка macOS и проверка отказа для Windows проходят на текущем host.

## Открытые вопросы и блокеры

- Нативные сборки Windows и Linux нельзя выполнить на текущем macOS host; их проверка требует соответствующих runners.

## Ключевые решения

- Makefile не имитирует кросс-сборку Flutter desktop: артефакты должны собираться на native OS с её toolchain.

## Проверки

- `make help` — успешно.
- `make build-macos` — успешно; создан `tournament_app.app`.
- `make build-windows` на macOS — корректно отклонён с объяснением отсутствия нативного Windows toolchain.
- `git diff --check` — успешно.

## Итог

Makefile поддерживает нативные desktop-сборки macOS, Windows и Linux. Цели запускаются на соответствующих ОС и не скрывают ограничение Flutter desktop на кросс-сборку.
