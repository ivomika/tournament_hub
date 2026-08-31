# Development guide

## Перед началом

1. Прочитать `AGENTS.md`, `ai-context/README.md`, `task-list.md` и весь индекс `ai-context/rules/README.md`.
2. Найти либо создать карточку; заполнить ссылки на применимые правила.
3. Проверить [open decisions](../product/open-decisions.md): нельзя реализовывать заблокированный выбор.
4. Прочитать канонические документы затронутой области.
5. Зафиксировать scope/non-scope, risks, migration и проверки; только затем менять проект.

### Rule routing gate

Для каждой задачи читаются rule router и пять core rules. Затем scope сопоставляется с conditional triggers; читаются и связываются только сработавшие rules. Карточка хранит core evidence, результат trigger scan и evidence conditional rules. Пустой или формальный routing блокирует `В работе`; изменение scope требует повторного routing, итоговый diff — повторной сверки перед `Выполнена`.

## Current repository state

Репозиторий содержит Flutter Host `apps/tournament_app`, read-only React/Vite Spectator `apps/spectator_web`, root `Makefile` и cross-platform Dart orchestration. Spectator получает public snapshot/events v1 через локальный Host, валидирует DTO и восстанавливается только full snapshot/contiguous replay; Participant transport, CI и production platform matrix ещё не реализованы. Platform runners обеспечивают development bootstrap и сами по себе не закрывают OD-009.

## Tool interface

| Command | Contract |
|---|---|
| `make setup` | Устанавливает workspace dependencies без secret mutation |
| `make sync-fighter-assets` | Валидирует source manifest и синхронизирует Flutter runtime artwork |
| `make format` | Форматирует Dart/TS/Markdown поддерживаемыми tools |
| `make lint` | Static analysis/lint/typecheck |
| `make test` | Unit/widget/component tests |
| `make architecture` | Layer imports и design-system boundaries с positive/negative fixtures |
| `make check` | Assets + format check + lint + tests + docs links |
| `make run DEVICE=...` | Запускает Flutter на явно/безопасно выбранном device |
| `make run-widgetbook DEVICE=...` | Запускает Flutter Widgetbook через отдельный entry point |
| `make build` | Последовательно собирает выбранный Flutter target и Spectator Web |

Windows/macOS/Linux branching реализован в `tool/project.dart`, а Makefile остаётся thin interface без bash/cmd/PowerShell-specific логики. `DEVICE` задаёт Flutter run target; `TARGET` задаёт Flutter build target, а без него выбирается desktop target текущего host. `run-spectator`, `build-flutter` и `build-spectator` доступны для изолированной работы. `make test` и `make check` включают Flutter suites и Vitest protocol/reducer/component suites Spectator Web.

Flutter presentation catalog находится в `lib/main_widgetbook.dart`. Он использует generated bindings из `docs/design/tokens.json` и не является production router. Запуск также доступен через `.vscode/launch.json`; VS Code выбирает конкретный Flutter device, а Widgetbook `ViewportAddon` переключает project compositions Mobile/Desktop внутри catalog. `make architecture`, `make test` и `make check` запускают layer import gate из `tool/check_flutter_layer_imports.dart`, а затем design-system check. Gate исполняет [ADR-0010](../adr/0010-layer-import-boundaries.md) и [ADR-0011](../adr/0011-app-lifecycle-and-state-driven-routing.md), одинаково проверяет relative и `package:tournament_hub_app` imports и завершает команду с ошибкой при reverse dependency или router-owned lifecycle coupling.

## Definition of Ready

- Цель проверяема.
- Scope/non-scope и actor/state определены.
- Правила и канонические документы связаны.
- Core evidence и conditional trigger scan заполнены без декоративных ссылок.
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
- Rule routing сверён с итоговым diff; фактический evidence записан для core и сработавших conditional rules.
- Commit создаётся только по прямому запросу и содержит одну логическую задачу.

## Git safety

Сохранять dirty worktree пользователя. Запрещены `reset --hard`, массовое восстановление, recursive delete broad paths и переписывание history без явного запроса. Перед удалением проверить абсолютную цель; предпочитать recoverable action. Не добавлять local DB, env secrets, build outputs и diagnostics payload.
