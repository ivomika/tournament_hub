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
app/presentation -> application/services -> domain
app/composition  -> infrastructure adapters -> domain/application ports
infrastructure   -X-> presentation
domain           -X-> framework/infrastructure/application
```

Запрещены concrete Drift/WebSocket зависимости в services, domain decisions в providers/widgets и format switches вне registry/engine.

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
    presentation/        # screens/controllers/components
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

Router guard читает application state. Route не вызывает lifecycle transition автоматически. Back/Main сохраняет active snapshot. Deep link валидирует role, tournament ID и state; недопустимый route ведёт к безопасному экрану с объяснением.

## Cross-cutting constraints

- UTC instant для факта времени; revision/sequence для порядка.
- Domain state immutable либо контролируемо копируется без live references.
- DTO versioned с mapper boundary.
- Role-specific projections содержат минимум полей.
- Никаких secrets/PII в logs, task cards и spectator payload.
- Background jobs не меняют tournament truth без application command.

## ADR policy

ADR обязателен для изменения authority model, layer direction, persistence truth, transport, versioning strategy, supported platforms или design-token source. ADR включает context, decision, alternatives, consequences, migration и rollback. Task card не заменяет ADR.

## Architecture fitness checks

- Dependency test запрещает framework imports в Domain.
- Search/lint запрещает concrete infrastructure imports в application.
- Engine conformance suite применяется к каждой ruleset version.
- Protocol schemas проходят fixtures/compatibility tests.
- Persistence mutation проверяется fault injection до/после commit.
- React bundle не содержит tournament progression functions.
