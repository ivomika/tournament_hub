# Development guide

## Перед началом

1. Прочитать `AGENTS.md`, `ai-context/README.md`, `task-list.md` и весь индекс `ai-context/rules/README.md`.
2. Найти либо создать карточку; заполнить ссылки на применимые правила.
3. Проверить [open decisions](../product/open-decisions.md): нельзя реализовывать заблокированный выбор.
4. Прочитать канонические документы затронутой области.
5. Зафиксировать scope/non-scope, risks, migration и проверки; только затем менять проект.

## Current repository state

На дату документации ветка содержит design source и AI-context, но application skeleton отсутствует. Команды сборки нельзя придумывать в документации как уже работающие. При bootstrap должны появиться root `README.md`, `Makefile`, Flutter/React apps, tool scripts и CI; команды ниже становятся обязательным interface после реализации.

## Planned tool interface

| Command | Contract |
|---|---|
| `make setup` | Устанавливает workspace dependencies без secret mutation |
| `make format` | Форматирует Dart/TS/Markdown поддерживаемыми tools |
| `make lint` | Static analysis/lint/typecheck |
| `make test` | Unit/widget/component tests |
| `make check` | Assets + format check + lint + tests + docs links |
| `make run DEVICE=...` | Запускает Flutter на явно/безопасно выбранном device |
| `make build` | Production artifacts; только когда задача требует/разрешает |

Windows/macOS/Linux orchestration реализуется scripts, а Makefile остаётся thin interface. Команда не зависит от bash-only builtins, если заявлена Windows support.

## Definition of Ready

- Цель проверяема.
- Scope/non-scope и actor/state определены.
- Правила и канонические документы связаны.
- Open decisions либо закрыты, либо область исключена.
- Data/protocol/design impact перечислен.
- Acceptance criteria наблюдаемы.
- Test plan расположен на самом нижнем ответственном слое.
- Destructive/external actions явно авторизованы.

## Implementation order

1. Domain types/invariants и tests.
2. Application command/port и tests.
3. DTO/mappers/storage/network adapter и contract tests.
4. Presentation controller/state.
5. Adaptive UI, accessibility states и widget/component tests.
6. Integration/E2E vertical slice.
7. Документация/contracts/migrations/release notes.

Порядок меняется только с объяснением в task card.

## Coding rules

- Один production object — одна ответственность.
- Immutable values и typed IDs на domain boundaries.
- Constructors валидируют локальные invariants; cross-aggregate policy живёт в engine/service.
- Dependency передаётся явно; clock/RNG/ID/network/storage тестируемы.
- Error codes стабильны; user-facing localization только presentation.
- Async operation cancellable/disposable по lifecycle.
- Generated files не редактируются вручную.
- Broad ignore, suppressed test и catch-all без recovery запрещены.
- TODO содержит task ID; неизвестное не маскируется hardcoded default.

## Database and protocol changes

- Сначала schema/contract + compatibility policy.
- Потом mapper/migration/fixtures.
- Затем adapter/application/UI.
- Обязательны old→new upgrade, round-trip, invalid input и rollback tests.
- Опубликованные version numbers не переиспользуются.
- Destructive migration требует отдельного решения и recovery plan.

## UI changes

- Использовать semantic tokens/components.
- Проверить все applicable width classes и text scaling.
- Добавить loading/empty/error/offline/disabled/focus.
- После assignment соблюдать full participant identity.
- Domain decision не дублировать во widget/React.
- Для заметного visual change приложить golden/screenshot/component evidence.

## Review checklist

- Изменение соответствует task scope и rules references.
- Нет unrelated formatting/deletes.
- Authority и layer direction сохранены.
- Snapshot/protocol projection минимальны и versioned.
- Failure path не теряет committed data.
- Error безопасен для UI/log.
- Tests не только happy path.
- Docs/link/task status актуальны.

## Definition of Done

- Все acceptance criteria отмечены фактическими результатами.
- `make check` успешен либо непроведённые проверки явно объяснены.
- Build/E2E выполнены только если нужны и разрешены.
- Migration/rollback/release impact записан.
- Нет secrets, temporary/generated garbage и несвязанных изменений.
- Task card содержит result и переведена в Finished/✅.
- Commit создаётся только по прямому запросу и содержит одну логическую задачу.

## Git safety

Сохранять dirty worktree пользователя. Запрещены `reset --hard`, массовое восстановление, recursive delete broad paths и переписывание history без явного запроса. Перед удалением проверить абсолютную цель; предпочитать recoverable action. Не добавлять local DB, env secrets, build outputs и diagnostics payload.
