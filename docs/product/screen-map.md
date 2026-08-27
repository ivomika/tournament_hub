# Карта экранов и переходов

Navigation отражает committed application/tournament state. Route не меняет lifecycle автоматически.

## Общая Flutter shell

```text
Bootstrap
  ├─ profile absent ─> Registration ─> Main
  ├─ profile ready ──> Main
  └─ storage error ──> Recoverable Error

Main
  ├─ Profile
  ├─ History ─> Historical Tournament Detail
  ├─ Settings
  ├─ Create Host Tournament
  ├─ Join Participant Tournament
  └─ Continue Active Tournament
```

Main всегда доступен без отмены active tournament. При active tournament создание второго скрыто/заблокировано, а «Продолжить» ведёт в экран, соответствующий authoritative state.

## Logical route catalog

| Route ID | Actor | Source state | Guard/result |
|---|---|---|---|
| `registration` | Local user | profile absent | profile ready → `main` |
| `main` | Any local profile | profile ready | показывает create/join или continue |
| `profile` | Any | profile ready | не меняет tournament |
| `history` | Any | profile ready | только terminal snapshots |
| `historyDetail` | Any | snapshot exists | read-only; not found → local error |
| `settings` | Any | profile ready | destructive actions подтверждаются |
| `hostTournament` | Host | active Host tournament exists | state-driven child composition |
| `joinTournament` | Participant | нет конфликтующей active binding | QR/code handshake |
| `participantTournament` | Participant | valid binding/cache | Host-state projection |

Concrete `go_router` paths определяются при bootstrap routing contract; logical IDs и guards являются каноном.

## Host flow

```text
Main
  -> Draft
  -> Open
  <-> Distribution
  -> Running
  -> Finished
  -> Main | History

Draft/Open/Distribution/Running
  -> Cancel confirmation
  -> Cancelled
  -> Main | History
```

| Tournament state | Primary screen content | Host actions | Navigation guarantees |
|---|---|---|---|
| Draft | Settings form + persistent summary | Save/open/cancel | Back/Main сохраняет Draft |
| Open | Connection, roster, Guests | Add/remove, distribution, cancel | Settings immutable; Main сохраняет active |
| Distribution | Full fighter assignments | Reroll All, back Open, start, cancel | Back transition только explicit Domain command |
| Running | Current match + structure/progress | Result, technical, valid correction, withdrawal | Нельзя route-назад в Open/Distribution |
| Finished | Champion + ranking + structure | Read-only | Main/History доступны |
| Cancelled | Factual terminal summary | Read-only | Main/History доступны |

## Participant flow

```text
Main -> Join (QR/code) -> Connecting/Handshake
  ├─ accepted Open -> Lobby
  ├─ incompatible/denied/not found -> Recoverable Error
  └─ reconnect -> Full Snapshot -> state projection

Lobby(Open) -> Distribution -> Running -> Finished -> Main
Disconnect -> stale last-known projection -> reconnect/full snapshot
```

Participant route не показывает organizer actions. Disconnect/back не создаёт loss, withdrawal или Host cancellation. Локальное прекращение reconnect отделено от tournament terminal state.

## Spectator Web flow

```text
Load bundle -> Waiting/Connecting
  -> Distribution presentation
  -> Running Dashboard <-> Tournament View
  -> Finished Champion <-> Final Structure/Ranking

Any connected view -> Disconnected/Stale -> Reconnecting -> Full projection
```

Spectator не имеет mutation routes. Cancelled tournament не публикуется. Manual refresh не является sync mechanism.

## Route guards

- Profile gate precedes application routes.
- Actor role и tournament/binding ID валидируются до content.
- Host state выбирает единственную допустимую tournament composition.
- Historical snapshot никогда не открывается как editable active tournament.
- Deep link в недопустимый state не мутирует lifecycle и ведёт к Main либо объясняющему error.
- Terminal transition удаляет active route source только после committed persistence; UI затем предлагает Main/History.

## Presentation states

Каждый async/network route проектирует применимые `initial`, `loading`, `content`, `empty`, `offline/stale`, `reconnecting`, `incompatible`, `permissionDenied`, `notFound`, `error/retry`. Last-known data не выглядит live при stale.

## Back, close and destructive navigation

- Back/close сохраняет committed active state.
- Explicit lifecycle command и обычная navigation визуально/технически разделены.
- Cancel, clear history и account deletion требуют отдельного confirmation с объектом и последствиями.
- После dialog focus возвращается trigger; keyboard/screen-reader order следует logical transition.

## Participant identity

После assignment любой tournament screen следует identity contract design system; route compactness не разрешает nickname-only representation.

## Проверка карты

- Widget/router tests на каждый guard и state restoration.
- Host back/Main не удаляет active snapshot.
- Finished/Cancelled открываются read-only из history.
- Participant/Spectator не получают mutation action.
- Deep links, stale/error/retry и accessibility focus проверяются отдельно.
