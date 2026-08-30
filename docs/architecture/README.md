# Architecture guide

## System context

```text
Remote Flutter Participant -- JSON WebSocket --+
                                                |
React Spectator -- HTTP bundle/WebSocket -------+--> Flutter Host
                                                     | UI/Riverpod
                                                     | Application services
                                                     | Pure Dart Domain engines
                                                     | Infrastructure adapters
                                                     +--> SQLite/Drift
                                                     +--> local notifications
```

Host — единственный writer и source of truth. Participant/Spectator являются projections и никогда не образуют distributed consensus.

## Architectural style

- Local-first modular monolith в Flutter Host.
- Ports and adapters на границах storage/network/clock/IDs/notifications.
- Application services по одному use case.
- Pure Dart Domain без Flutter, Riverpod, Drift, JSON, sockets и platform APIs.
- Snapshot-oriented persistence; event log — только bounded reconnect buffer.
- React — presentation projection без format engine.

## Dependency rule

```text
presentation   -> application -> domain
infrastructure -> application/domain ports
platform       -> application/domain ports
app            -> presentation/application
app/composition -> все слои только для wiring
shared         -> shared
```

Полная machine-readable семантика закреплена в [ADR-0010](../adr/0010-layer-import-boundaries.md). Краткая матрица project imports:

| Source | Разрешённые targets |
|---|---|
| `domain` | `domain`, framework-free `shared` |
| `application` | `application`, `domain`, `shared` |
| `presentation` | `presentation`, `application`, `shared` |
| `infrastructure` | `infrastructure`, `application`, `domain`, `shared` |
| `platform` | `platform`, `application`, `domain`, `shared` |
| `app` | `app`, `application`, `presentation`, `shared` |
| `app/composition` | все project layers только для wiring |
| `shared` | `shared` |

`presentation` не импортирует Domain напрямую: UI использует application projections/contracts. Запрещены concrete Drift/WebSocket зависимости в services, domain decisions в providers/widgets и format switches вне registry/engine. Generated Dart наследует границы owner layer; Widgetbook остаётся presentation; tests не расширяют production graph.

## Рекомендуемая физическая структура

```text
apps/
  tournament_app/lib/
    app/                 # bootstrap, router, theme, localization, DI
    domain/
      tournament/        # aggregate, lifecycle, format contracts
      formats/de|se|rr/  # versioned engines
      game/              # GameDefinition contract
      profile/
    application/         # commands/use cases and ports
    infrastructure/
      persistence/
      networking/
      notifications/
      serialization/
      platform/
    presentation/
      design_system/     # generated tokens, common theme, per-component themes/widgets
      screens/           # one screen per file; composition via design-system public API
      controllers/       # presentation state/adapters when introduced
    shared/              # truly generic primitives only
  spectator_web/src/
    app/
    tournament/          # read model and views, no engine
    shared/
```

Feature subfolders допустимы внутри owner layer. `shared`, `utils`, `common` не используются как склад.

## Command flow

```text
validated UI intent
 -> application service checks actor/lifecycle/revision
 -> domain aggregate/engine computes next state
 -> service creates snapshot + authoritative events
 -> one DB transaction commits coherent mutation
 -> after commit publisher emits events/projections
 -> controller exposes new presentation state
```

Инварианты:

- команда имеет `commandId` и идемпотентна на Host boundary;
- stale `expectedRevision` отклоняется structured conflict;
- commit предшествует success UI и broadcast;
- publish failure не откатывает committed truth; clients догоняются snapshot/reconnect;
- retry той же команды не применяет mutation второй раз.

## Domain ownership

| Решение | Owner |
|---|---|
| Lifecycle transition | Tournament aggregate/policy |
| Bracket/rounds/current/progression | Versioned format engine |
| Ranking/tie-break | Format engine/policy |
| Fighter roster/preparation | Game Definition |
| Random assignment | Assignment policy через injected RNG |
| Role/lifecycle command permission | Application service + domain validation |
| Atomic storage and migration | Persistence adapter |
| Projection/redaction | Application mapper |
| Loading/error/focus/layout | Presentation |

## Format extension contract

`TournamentFormatEngine` предоставляет create, matches, apply/correct result, advance, next current, withdraw, completion и ranking. Registry выбирает implementation по `(formatId, rulesetVersion)`. Добавление формата не изменяет старые engines. Опубликованная ruleset version остаётся читаемой для history.

## Game boundary

Tournament core оперирует participant IDs и не импортирует MK11 entities/assets. `GameDefinition` предоставляет stable game/fighter IDs, roster snapshot, asset references и preparation constraints. Assignment хранится отдельной map в tournament snapshot.

## Composition and DI

- Dependencies передаются constructors/providers.
- Riverpod используется как composition/lifecycle mechanism, не service locator внутри Domain.
- Clock, ID generator, RNG, storage, publisher и notifications injectable.
- Production adapters собираются только в `app` composition root.
- `main.dart` только создаёт composition и запускает app host; startup/recovery orchestration принадлежит `AppBootstrap`.
- Bootstrap получает application ports, публикует immutable `AppState` и не импортирует presentation/router.
- Composition владеет созданием и disposal dependency graph, но не содержит Domain decisions.
- Tests используют fakes на портах, а не framework globals.

## Error model

Ошибки разделяются:

- `DomainViolation`: стабильный code, безопасное описание invariant.
- `PermissionDenied`: actor/action/state.
- `Conflict`: expected/actual revision либо duplicate semantics.
- `ValidationError`: field/code, без stack trace в UI.
- `InfrastructureFailure`: storage/network/platform cause, логируется с redaction.
- `ProtocolError`: version/schema/order/gap.

UI маппит codes в русский user-facing текст. Domain не локализует строки.

## State and navigation

App lifecycle и state-driven routing закреплены в [ADR-0011](../adr/0011-app-lifecycle-and-state-driven-routing.md).

`AppBootstrap` — единственный writer app-level lifecycle state: `bootstrapping`, `profileRequired`, `operational`, `recoverableFailure`, `fatalFailure`. `operational` содержит application projections local profile и optional active context. Tournament lifecycle, connection state и presentation state остаются отдельными автоматами.

Router получает read-only `AppState` и отдельный `NavigationIntent`. Чистая route policy проецирует их в logical route: state определяет допустимые routes/обязательные redirects, intent выбирает экран внутри разрешённого пространства. Router не меняет AppState и не вызывает lifecycle transition автоматически. Back/Main сохраняет active snapshot. Deep link валидирует role, tournament ID и state; недопустимый route ведёт к Main либо безопасному экрану с объяснением без mutation.

## Cross-cutting constraints

- UTC instant для факта времени; revision/sequence для порядка.
- Domain state immutable либо контролируемо копируется без live references.
- DTO versioned с mapper boundary.
- Role-specific projections содержат минимум полей.
- Никаких secrets/PII в logs, task cards и spectator payload.
- Background jobs не меняют tournament truth без application command.

## ADR policy

ADR обязателен для изменения authority model, layer direction, persistence truth, transport, versioning strategy, supported platforms или design-token source. Требуемые поля и порядок определяет [политика серьёзных решений](../governance/decision-policy.md), реестр ведётся в [ADR index](../adr/README.md). Архитектурный выбор фиксируется до реализации; task card и code comment не заменяют ADR.

## Architecture fitness checks

- Architecture import gate исполняет allow matrix из [ADR-0010](../adr/0010-layer-import-boundaries.md), нормализует relative/package imports и блокирует reverse dependency.
- Gate запрещает framework imports в Domain и Flutter UI/concrete adapter imports в application.
- Generated Dart проверяется как часть owner layer; tests и tooling fixtures проверяют gate отдельно, но не ослабляют production matrix.
- Engine conformance suite применяется к каждой ruleset version.
- Protocol schemas проходят fixtures/compatibility tests.
- Persistence mutation проверяется fault injection до/после commit.
- React bundle не содержит tournament progression functions.
- Flutter design-system check запрещает raw visual values, direct token imports в components/screens, component без собственной theme и Material visual primitives в screen compositions.
