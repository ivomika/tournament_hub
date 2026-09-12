# Задача 12. Исправить запуск Domain architecture checker на Windows

## Статус

✅ Выполнена

## Цель

Команда `make domain-check` запускает локальный viewer на Windows и сохраняет запуск на Unix-платформах.

## Контекст и границы

- Воспроизводимая причина: Makefile вызывает `python3`, которого в Windows PATH нет; установленный Python доступен через `py -3`.
- Входит: платформенный выбор Python launcher, возможность явного переопределения и обновление инструкции запуска.
- Не входит: изменение viewer, JSON-инвентаря Domain или сетевого контракта HTTP-сервера.

## Применимые правила

### Обязательные правила

- [x] [R-001 · SOLID](../rules/core/001-solid.md) — выбор интерпретатора остаётся ответственностью Makefile и не проникает в viewer; вводится одна переменная `PYTHON` с точкой переопределения.
- [x] [R-002 · Документирование на русском](../rules/core/002-documentation-russian.md) — документируется изменившееся кроссплатформенное поведение команды и override `PYTHON` в `docs/`.

### Conditional rules

- Scan выполнен: conditional rules отсутствуют, поскольку меняется только локальная developer-команда без Domain, UI, persistence или внешнего контракта.

## Декомпозиция

- [x] Воспроизвести ошибку запуска и проверить доступный Python launcher Windows.
- [x] Добавить платформенный launcher и override `PYTHON` в Makefile.
- [x] Обновить документацию, проверить Windows-команду и завершить задачу.

## Критерии готовности

- [x] `make domain-check DOMAIN_CHECK_PORT=8091` отдаёт viewer на Windows без `python3` в PATH.
- [x] На Unix по умолчанию сохраняется `python3`; `PYTHON` можно переопределить явно.
- [x] Документация на русском описывает запуск и override.

## Открытые вопросы и блокеры

- Нет.

## Ключевые решения

- Windows использует официальный Python launcher `py -3`, а Unix — `python3`; значение можно заменить через `PYTHON=...`.

## Проверки

- `py -3 --version` — доступен Python 3.14.3 через Windows launcher.
- `make domain-check DOMAIN_CHECK_PORT=8091` — запустил `py -3 -m http.server 8091 --directory tools/domain-check`.
- `Invoke-WebRequest http://127.0.0.1:8091/` — HTTP 200, отдан HTML Domain viewer.
- `git diff --check` — успешно.

## Итог

В `Makefile` добавлена переопределяемая переменная `PYTHON`: на Windows по умолчанию `py -3`, на macOS/Linux — `python3`. Документация фиксирует платформенный запуск и override для нестандартной установки Python. Viewer и его HTTP-контракт не менялись.
