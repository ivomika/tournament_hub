# Карта экранов и переходов

Navigation отражает committed application/tournament state. Route не меняет lifecycle автоматически.

## App lifecycle и route projection

По [ADR-0011](../adr/0011-app-lifecycle-and-state-driven-routing.md) bootstrap публикует read-only `AppState`, а router вычисляет route из пары `AppState + NavigationIntent`. AppState задаёт guards и обязательные redirects; intent выбирает Main/Profile/History/Settings либо разрешённый role flow. Back и deep link меняют только intent и никогда не являются lifecycle command.

| AppState | Обязательная route policy |
|---|---|
| `bootstrapping` | Bootstrap |
| `profileRequired` | Registration |
| `operational` без допустимого intent | Main |
| `operational` с допустимым intent | Соответствующий logical route |
| `recoverableFailure` | Recoverable Error/retry |
| `fatalFailure` | Fatal Error |

App lifecycle, tournament lifecycle и Participant connection state не объединяются. Active tournament ограничивает create/join и разрешает Continue, но сам по себе не запрещает Main/Profile/History/Settings.

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
Main показывает одну карточку создания без выбора формата: название и режим задаются на Draft. Действие «Продолжить» сохраняется независимо от блока последнего terminal snapshot. Последний завершённый или отменённый турнир показывается отдельной read-only карточкой с переходом в `historyDetail`; при пустой истории отображается empty state.

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
| Draft | Прежняя линейная композиция параметров: название, компактный dropdown DE/SE/RR и stage summary | Save/open/cancel | Back/Main сохраняет Draft; Open возможен только после committed valid settings |
| Open | Общий двухрегионный layout: roster — основной блок, guest form расположена выше optional Participant invite во втором блоке; Spectator access рядом со статусом | Add/remove, открыть spectator access, distribution, cancel | Settings immutable; Main сохраняет active; недоступные Participant/Spectator возможности не блокируют local progression |
| Distribution | Full fighter assignments и committed reroll feedback | Reroll All, back Open, start, cancel | Reroll блокирует duplicate command и сразу обновляет projection; Back transition только explicit Domain command |
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

Экран Join остаётся scanner/code-first: камера и ручной адрес/код равноправны, состояния scanning/connecting/denied/notFound/error названы текстом. Визуальные mock states не являются handshake или transport implementation.

## Spectator Web flow

```text
Host foreground start -> Static bundle available
  -> Waiting (нет public tournament, Draft/Open/Cancelled или terminal уже закрыт)
  -> Distribution presentation
  -> Running Dashboard <-> Tournament View
  -> Finished Champion <-> Final Structure/Ranking

Any connected view -> Disconnected/Stale -> Reconnecting -> Full projection
```

Spectator не имеет mutation routes. LAN server не зависит от active tournament и сохраняет endpoint между waiting и public стадиями; mobile background остаётся под OS lifecycle policy. Cancelled tournament не публикуется. Manual refresh не является sync mechanism.

На Running Dashboard expanded-композиция сохраняет пространственную хронологию `Завершённые → Сейчас → Будущие`: current match занимает доминирующую центральную lane. Compact-композиция сохраняет тот же DOM/read order вертикально; состояние каждой lane названо текстом и не кодируется только цветом.

## Route guards

- Profile gate precedes application routes.
- Guard читает AppState projection и не вызывает application/domain command.
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
