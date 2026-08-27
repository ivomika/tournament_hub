# Tournament Hub — единый Product & System Design Document

**Статус:** Normative / MVP baseline  
**Версия:** 1.0  
**Дата фиксации:** 26.08.2026  
**Продукт:** локальное приложение для турниров Mortal Kombat 11 с Flutter Host/Participant и React Spectator Web

## 0. Статус документа и правила трактовки

Этот документ является единственным нормативным design document для MVP Tournament Hub. Он объединяет продуктовые правила, правила турнирных форматов, архитектуру, UI/design system и карту экранов.

Ключевые слова трактуются строго:

- **ОБЯЗАН / ДОЛЖЕН** — требование обязательно к реализации.
- **ЗАПРЕЩЕНО / НЕ ДОЛЖЕН** — решение не допускается в MVP.
- **МОЖЕТ** — только продуктово разрешённое поведение пользователя или явно необязательный визуальный эффект; архитектурную альтернативу это слово не обозначает.

При конфликте правил действует следующий приоритет:

1. format-specific правила DE/SE/RR определяют турнирную математику;
2. product business rules определяют lifecycle, роли, permissions и пользовательское поведение;
3. этот документ определяет техническую реализацию и системные границы;
4. design system определяет визуальное представление и interaction constraints;
5. screen map определяет покрытие экранов и основные переходы.

Ни одно решение, помеченное в прежних материалах как «может», «рекомендуется», «возможное» или «не фиксируется», не создаёт альтернативной архитектуры. Для MVP действует только baseline, закреплённый ниже.

## 1. Product scope и системная модель

Tournament Hub — local-first система для проведения локального турнира по MK11 без облачного backend.

Система состоит ровно из двух приложений:

1. **Flutter application (`apps/tournament_app`)** — единое устанавливаемое приложение, работающее в ролях Host и Participant.
2. **React spectator web (`apps/spectator_web`)** — read-only web UI, который Host раздаёт по локальной сети.

Облачный backend, внешний realtime service и постоянный web-hosting в MVP отсутствуют.

### 1.1. Источник истины

Для активного турнира устройство Host — единственный authoritative вычислительный и persistence-узел.

Только Host имеет право:

- применять бизнес-команды;
- изменять authoritative tournament state;
- вычислять progression и standings;
- выбирать следующий `Current` match по правилам формата;
- создавать authoritative events;
- сохранять Active Tournament Snapshot;
- сохранять Active Event Log;
- публиковать состояние Participant и Spectator Web.

Participant и Spectator Web никогда не выполняют tournament progression, не пересчитывают bracket/standings и не создают authoritative facts.

### 1.2. Базовые архитектурные инварианты

- Monorepo — единственная структура репозитория.
- Local First — обязательный режим работы.
- Host Authoritative — обязательный consistency model.
- One Object — One Responsibility — обязательный design constraint.
- Domain независим от Flutter, Riverpod, SQLite, Drift, HTTP, WebSocket и React.
- Services — только application orchestration.
- Infrastructure — только техническая реализация.
- Все внешние зависимости передаются через dependency injection.
- Для MVP отдельный DI-container package не используется; composition выполняется в `app` и через Riverpod providers.
- Active Tournament хранится snapshot-ориентированно; Event Sourcing запрещён как source of truth.
- React — только read-only projection.

## 2. Роли, identity и permissions

### 2.1. Local Profile

На одном устройстве существует ровно один локальный профиль.

Профиль имеет постоянный `profileId`, генерируемый приложением, и `nickname`.

Правила nickname:

- не пустой;
- Unicode разрешён, включая emoji;
- уникальность не требуется;
- изменение nickname не изменяет nickname уже присоединённого participant в активном турнире;
- identity определяется по `profileId`, а не по nickname.

Один профиль может быть связан только с одним незавершённым турниром одновременно.

### 2.2. Host / Organizer

Host создаёт и управляет турниром. Только Host выполняет:

- создание и настройку турнира;
- переходы lifecycle;
- добавление Guest;
- удаление/снятие participants;
- `Reroll All`;
- запуск турнира;
- фиксацию normal/technical result;
- исправление результата, если правило формата разрешает;
- отмену и финальное завершение турнира.

Host не обязан быть participant.

### 2.3. Host как Participant

Если локальный профиль Host включён в состав, он одновременно имеет роли Organizer и Participant. Участие не уменьшает organizer permissions и не создаёт отдельную сущность профиля.

### 2.4. Participant

Participant:

- подключается своим локальным профилем;
- не управляет турниром;
- не видит organizer-only actions;
- видит собственные матчи и релевантный progression;
- может самостоятельно выйти только в `Open`;
- получает локальные notifications;
- использует read-only local cache при disconnect.

### 2.5. Guest

Guest создаётся только Host и существует только внутри конкретного tournament snapshot.

Guest:

- не имеет приложения и `profileId` пользователя;
- не подключается по сети;
- не получает notifications и reconnect;
- участвует по тем же игровым правилам;
- получает character assignment;
- получает итоговое место;
- всегда визуально помечается `Guest` / «Гость».

Guest из разных турниров никогда не связываются между собой.

## 3. Tournament lifecycle — единственная state machine

Единственная разрешённая state machine турнира:

```text
Draft -> Open <-> Distribution -> Running -> Finished
                  \                         
                   +-----------------------> Cancelled
```

`Cancelled` допускается из любого незавершённого состояния по organizer action. `Finished` и `Cancelled` — terminal read-only states.

### 3.1. Draft

Назначение: только настройка турнира.

В `Draft`:

- задаются title, format и format settings;
- participants не добавляются;
- состояние сохраняется локально;
- разрешено продолжить настройку после перезапуска.

Разрешённый forward transition: `Draft -> Open`.

Возврат `Open -> Draft` запрещён.

### 3.2. Open

Назначение: набор состава.

В `Open`:

- Participant подключается по QR или fallback code;
- Host добавляет Guest;
- Host удаляет participants;
- Participant может выйти самостоятельно;
- базовые tournament settings уже immutable.

Разрешённый forward transition: `Open -> Distribution`.

### 3.3. Distribution

При `Open -> Distribution` Host немедленно выполняет полное случайное уникальное распределение MK11 characters.

В `Distribution` Host может:

- выполнить `Reroll All`;
- удалить participant;
- вернуться в `Open`;
- запустить турнир.

При `Distribution -> Open` все character assignments очищаются. Следующий вход в `Distribution` создаёт новое полное распределение.

### 3.4. Running

При `Distribution -> Running`:

- состав фиксируется;
- character assignments фиксируются;
- reroll запрещён;
- добавление новых participants запрещено;
- начинается authoritative match progression;
- возврат в `Open`/`Distribution` запрещён;
- pause state отсутствует.

Одновременно существует ровно один `Current` match.

### 3.5. Finished

Когда все обязательные матчи завершены, Domain формирует итоговый ranking. Затем Host выполняет явное действие «Завершить турнир».

`Running -> Finished` выполняется только после готовности полного итогового ranking.

После transition:

- состояние immutable;
- results, participants, settings и characters больше не меняются;
- создаётся immutable Historical Tournament Snapshot;
- active state и active event log удаляются после фиксации terminal event.

### 3.6. Cancelled

`Cancelled` — terminal state турнира, а не матча.

Cancelled snapshot сохраняет только реально существовавшие данные. Запрещено достраивать отсутствующие matches, результаты, ranking или места.

Отдельного match status `Cancelled` в MVP нет.

## 4. Screen map и информационная архитектура

### 4.1. Общая Flutter shell

При первом запуске:

```text
Registration -> Main
```

Из `Main` доступны общие разделы:

```text
Main -> Profile
Main -> History -> Historical Snapshot
Main -> Settings
```

Если незавершённого турнира нет, Main показывает действия:

- «Создать турнир»;
- «Присоединиться к турниру».

Если незавершённый турнир есть, Main показывает «Продолжить турнир» и не показывает создание второго турнира.

### 4.2. Host flow

Единственный Host flow:

```text
Main
  -> Tournament / Draft
  -> Tournament / Open
  <-> Tournament / Distribution
  -> Tournament / Running
  -> Tournament / Finished (Champion)
  -> Main
```

### 4.3. Participant flow

Participant не управляет state transition; его screen отражает state Host:

```text
Main
  -> Tournament / Open
  -> Tournament / Distribution
  -> Tournament / Running
  -> Tournament / Finished (Champion)
  -> Main
```

### 4.4. Spectator Web flow

Web доступен только через локальный Host server.

State presentation:

```text
Waiting/Disconnected -> Distribution -> Running -> Finished
```

В `Running` доступны presentation views:

- `Dashboard` — current match, tournament progress, adjacent context;
- `Tournament View` — full bracket/standings, participants, match history;
- `Champion` — недоступен до `Finished`.

В `Finished` Champion presentation становится primary, при этом tournament structure и final ranking остаются доступны.

Для `Cancelled` spectator web не предоставляется.

## 5. Tournament rules — формат-специфическая бизнес-истина

Минимальное количество participants для любого формата — 2.

Для DE и SE initial seeding формируется полностью случайно. Bye распределяются случайно и не считаются победой или сыгранным матчем.

### 5.1. Match state

Единственная match state machine:

```text
Upcoming -> Current -> Finished
```

Одновременно разрешён один `Current` match. Host не выбирает следующий match вручную, не переставляет очередь и не пропускает `Current`.

### 5.2. Result types

Каждый завершённый match имеет один winner и один loser.

Тип результата:

- `Normal Win`;
- `Technical Win`.

Technical result хранится отдельно от normal gameplay score и никогда не подменяется искусственным счётом.

### 5.3. Double Elimination

- основной формат;
- игрок выбывает после двух поражений;
- 0 losses -> Winners Bracket;
- 1 loss -> Losers Bracket;
- 2 losses -> eliminated;
- rematch разрешён;
- Bracket Reset используется всегда при победе Losers winner в Grand Final;
- default main bracket FT = FT1;
- Grand Final по умолчанию использует main FT, но имеет отдельную organizer setting;
- Bracket Reset использует FT Grand Final;
- full final ranking обязателен.

### 5.4. Single Elimination

- одно поражение = elimination;
- default FT = FT1;
- final по умолчанию использует main FT, но имеет отдельную organizer setting;
- отдельного матча за 3-е место нет;
- проигравшие полуфиналов делят позиции 3-4;
- full final ranking обязателен.

### 5.5. Round Robin

- каждая пара играет ровно один match в основном RR;
- каждый match всегда FT2;
- organizer не меняет FT;
- points:

| Result | Points |
|---|---:|
| Win 2:0 | 3 |
| Win 2:1 | 2 |
| Loss 1:2 | 1 |
| Loss 0:2 | 0 |
| Technical Win | 3 |
| Technical Loss | 0 |

При равенстве tournament points проводится mini Round Robin FT2 между равной группой. В mini RR каждый играет с каждым один раз; порядок определяется по количеству wins в переигровке. Если равенство сохраняется у подгруппы, mini RR повторяется только для этой подгруппы до однозначного распределения мест.

Основные RR results и points при tie-break не пересчитываются.

### 5.6. Forfeit и withdrawal

Forfeit — сдача текущего match. Это `Technical Loss`, но не автоматический выход из турнира, если формат позволяет продолжение.

Withdrawal из турнира:

- выполняет только Host;
- уже сыгранные results не меняются;
- снятого participant нельзя вернуть;
- в DE/SE следующий соперник получает Technical Win;
- в RR все оставшиеся matches снятого participant становятся Technical Loss, а opponents получают 3 points.

### 5.7. Result correction

Host может исправить match result только пока следующий зависимый match ещё не сыгран.

После correction Domain автоматически пересчитывает только несыгранную зависимую часть tournament structure.

Если зависимый match уже сыгран, correction запрещён.

`Undo` — UI shortcut этого же правила, а не отдельная бизнес-операция.

## 6. MK11 Game Definition и character distribution

Tournament Domain не знает MK11 roster и character assets.

MK11 реализуется отдельной `Game Definition`, которая предоставляет:

- stable game id;
- display name;
- roster;
- game-specific metadata;
- character asset references;
- MK11 pre-tournament preparation rules.

### 6.1. Participant vs character

`Participant` не содержит обязательное фундаментальное поле `characterId`.

Character assignment — отдельные game-specific данные конкретного турнира:

```text
Tournament Participant + MK11 Character Assignment
```

### 6.2. Distribution rules

- распределение выполняется только в `Distribution`;
- assignment случайный;
- character уникален внутри турнира;
- max participant count ограничен размером доступного roster;
- exclusions в MVP отсутствуют;
- единственная операция изменения — `Reroll All`;
- individual reroll запрещён;
- история reroll не хранится;
- после `Running` хранится только final assignment.

Participant получает только свой assignment. Host и Spectator Web получают полный participant -> character mapping.

## 7. Monorepo и физическая структура

Физический baseline репозитория фиксируется так:

```text
tournament_hub/
├── apps/
│   ├── tournament_app/
│   │   └── lib/
│   │       ├── app/
│   │       ├── domain/
│   │       │   ├── tournament/
│   │       │   ├── game/
│   │       │   └── profile/
│   │       ├── services/
│   │       ├── infrastructure/
│   │       │   ├── persistence/
│   │       │   ├── networking/
│   │       │   ├── notifications/
│   │       │   ├── serialization/
│   │       │   └── platform/
│   │       └── shared/
│   └── spectator_web/
│       └── src/
│           ├── app/
│           ├── tournament/
│           └── shared/
├── docs/
├── tools/
├── Makefile
└── README.md
```

Новые top-level architectural areas внутри Flutter `lib/` не добавляются. Feature-specific subfolders создаются только внутри закреплённого owner layer.

### 7.1. Dependency direction

Разрешённое направление:

```text
app
  -> services
      -> domain

infrastructure -> implements contracts consumed by services/domain
app -> composes concrete implementations
```

Запрещено:

- `domain -> services`;
- `domain -> infrastructure`;
- `domain -> Flutter/Riverpod`;
- `services -> concrete infrastructure classes`;
- `infrastructure -> UI behavior`;
- React -> tournament engine.

## 8. Flutter layer responsibilities

### 8.1. `app`

`app` содержит только:

- bootstrap;
- `go_router` configuration;
- theme/design-token wiring;
- localization wiring;
- application configuration;
- Riverpod composition/providers;
- application entry points.

`app` не содержит tournament business logic, SQL, WebSocket serialization или notification implementation.

### 8.2. `domain`

`domain` содержит:

- domain models;
- value objects;
- lifecycle/state invariants;
- format contracts;
- DE/SE/RR engines;
- game definition contracts;
- MK11 game definition/preparation logic;
- business policies.

Domain model отвечает за собственное состояние и локальные invariants. Cross-aggregate операции выполняются engines/policies, а не god object `Tournament`.

### 8.3. `services`

`services` — application layer. Каждый service координирует один user/application use case.

Обязательная orchestration sequence для mutation:

```text
UI intent
 -> Service validates role/lifecycle preconditions
 -> Domain Engine/Policy computes new consistent state
 -> Service builds authoritative event(s)
 -> one persistence transaction:
      save Active Tournament Snapshot
      append Active Event Log
 -> COMMIT
 -> broadcast committed event(s)
 -> expose updated presentation state
```

Broadcast до успешного database commit запрещён.

Services не содержат DE/SE/RR rules и не знают Drift table details.

### 8.4. `infrastructure`

`infrastructure` реализует:

- SQLite/Drift storage;
- JSON DTO mapping;
- Shelf HTTP server;
- WebSocket host/client adapters;
- static React hosting;
- local notifications;
- platform APIs.

Infrastructure отвечает «как выполнить», но не «когда и с какими бизнес-последствиями».

### 8.5. `shared`

`shared` содержит только truly cross-cutting primitives:

- typed IDs;
- result/error primitives;
- базовые serializable technical errors;
- общие utilities без domain semantics.

`shared` не используется как feature dump.

## 9. Tournament Format Engine boundary

Каждый формат реализуется отдельным engine:

```text
TournamentFormatEngine
├── DoubleEliminationEngine
├── SingleEliminationEngine
└── RoundRobinEngine
```

Общий contract обязан покрывать следующие операции и только их общую семантику:

- create tournament structure;
- apply match result;
- advance progression;
- determine next available/current match;
- determine completion;
- build full ranking;
- withdraw participant;
- validate/correct result while dependent matches remain unplayed.

Format-specific branching (`if DE`, `if RR`) вне engine/registry запрещён.

`TournamentFormatRegistry` выполняет единственную функцию:

```text
TournamentFormat -> TournamentFormatEngine
```

Добавление нового format требует новой engine implementation и registration; существующие engines не переписываются.

## 10. Persistence architecture

### 10.1. Storage boundaries

В MVP используются ровно следующие логические persistence boundaries:

1. `Local Profile`;
2. `Active Tournament State`;
3. `Active Event Log`;
4. `Participant Tournament Cache`;
5. `Tournament History`;
6. `App Settings`.

Один universal repository запрещён. Repository-per-domain-model также запрещён как default pattern.

### 10.2. Active Tournament Snapshot

Active tournament сохраняется единым сериализуемым snapshot.

```text
Old Snapshot
 -> Domain Operation
 -> New Consistent State
 -> Atomic Save
```

После restart Host обязан выполнить:

```text
load snapshot -> deserialize/migrate -> resume tournament
```

### 10.3. Serialization boundary

Domain object никогда не является persisted/network DTO напрямую.

Обязательная boundary:

```text
Domain Models
 <-> Mapper
 <-> Serializable Snapshot/Event DTO
 <-> Storage/Wire
```

### 10.4. Snapshot versioning

Каждый persisted snapshot содержит `schemaVersion` с первой версии MVP.

Migration выполняется последовательно:

```text
v1 -> v2 -> v3 -> ...
```

Migration преобразует representation и запрещено переигрывать business logic или менять исторический смысл старого турнира.

### 10.5. Historical snapshots

`Finished` и `Cancelled` сохраняются как immutable historical snapshots.

История хранит полное фактическое состояние: settings, participants, guests, tournament nicknames, assignments, созданные matches, их order/stages, results/result types, standings/bracket, определённые places/ranking и terminal lifecycle state.

Отдельный historical tournament удалить нельзя. Settings action «Очистить историю» удаляет все Finished/Cancelled snapshots и сбрасывает derived profile statistics.

### 10.6. Profile statistics

Tournament History — единственный source of truth для агрегатов профиля.

Derived values:

- tournament count;
- tournament wins;
- Tournament Win Rate;
- normal match count;
- normal match wins;
- Match Win Rate;
- best place;
- last 3 tournaments.

Technical Win/Loss не входит в Match Win Rate.

## 11. Realtime protocol и local server

### 11.1. Transport

Единственный realtime transport — WebSocket, wire format — JSON.

Host одновременно:

- поднимает local Shelf HTTP server;
- раздаёт compiled React bundle через `shelf_static`;
- предоставляет WebSocket endpoint через `shelf_web_socket`.

Participant использует `web_socket_channel`. React использует native browser WebSocket API.

### 11.2. Message categories

Protocol имеет ровно четыре категории:

```text
handshake
request
 event
 error
```

- `request`: Client -> Host intent;
- `event`: Host -> clients committed authoritative fact;
- `error`: structured request error correlated by `requestId`;
- `handshake`: initial connect/reconnect negotiation.

Clients не отправляют authoritative tournament facts.

### 11.3. Event envelope

Каждый authoritative event содержит:

```text
protocolVersion
eventVersion
eventId
tournamentId
sequence
type
timestamp
payload
```

`type` имеет стабильное имя `subject.action`.

`sequence` — монотонно возрастающий номер внутри tournament. Он является единственным ordering mechanism protocol.

### 11.4. Initial connect

Initial handshake обязан вернуть клиенту текущий authoritative snapshot/read model и текущий `sequence`. После применения snapshot клиент продолжает только event stream.

### 11.5. Reconnect

Client хранит:

```text
tournamentId
lastSequence
```

Reconnect требует повторного QR/fallback-code entry для Participant; automatic LAN discovery отсутствует.

Если tournamentId совпадает, Host восстанавливает существующее участие и досылает events с `sequence > lastSequence` из Active Event Log.

Participant tournament nickname при reconnect берётся из tournament state, а не из текущего local nickname.

### 11.6. Active Event Log

Active Event Log существует только пока tournament активен и только для:

- realtime synchronization;
- reconnect;
- replay missed events.

Event Log не является бизнес-историей и не является source of truth.

Active Snapshot + Event Log сохраняются в одной transactional boundary так, чтобы restart никогда не увидел несовместимые версии.

### 11.7. Terminal events

Terminal event types:

```text
tournament.finished
tournament.cancelled
```

Terminal event содержит полный historical snapshot.

После terminal commit Host:

1. сохраняет Historical Snapshot;
2. публикует terminal event;
3. удаляет Active Tournament State;
4. удаляет Active Event Log.

## 12. Connection, QR и code

Основной connect mechanism Participant — QR. Fallback — connection code. Оба определяют один и тот же tournament identity и endpoint data.

New participant join разрешён только в `Open`.

При successful join:

- дополнительного confirmation нет;
- local profile автоматически передаётся Host;
- пользователь сразу становится participant;
- открывается tournament screen.

Один `profileId` соответствует ровно одному participant внутри tournament. Повторный join того же profileId в тот же tournament — reconnect, а не duplicate.

Join в `Distribution`, `Running` или `Finished` отклоняется с user-facing error «Турнир уже начат».

## 13. Participant cache и disconnect behavior

Participant хранит last-known read-only tournament cache.

При disconnect:

- участие не удаляется;
- поражение не фиксируется;
- match state не меняется;
- UI показывает stale/disconnected state;
- client не пересчитывает ничего локально.

После reconnect cache заменяется актуальным authoritative state/event sequence.

Если Host восстановить невозможно, user action может завершить локальную привязку и сохранить локальное участие как `Cancelled`; это не изменяет Host tournament.

## 14. Notifications

Notification model фиксирован:

```text
Host authoritative event -> Participant app -> local notification
```

MVP notification events:

- tournament started;
- participant match became `Current`;
- participant eliminated;
- tournament finished and final place known.

Запрещены:

- notification history;
- notification center;
- acknowledgement;
- replay missed notifications after reconnect.

Global setting включает/выключает все local notifications, не влияя на in-app state updates.

## 15. Spectator Web architecture

Spectator Web:

- доступен в LAN без auth;
- read-only;
- получает данные только от Host;
- автоматически применяет authoritative events;
- сохраняет last-known view при disconnect;
- явно показывает stale state;
- не имеет manual refresh как sync mechanism;
- не содержит tournament engine.

Web должен уметь отображать:

- tournament summary/state;
- previous/current/next-known match;
- participants и assignments;
- all created matches;
- full DE/SE bracket или RR standings;
- shared profiles;
- played match history;
- final ranking/champion.

Product limit spectator connections не задаётся; предел определяется Host/device/LAN capacity.

## 16. Технологический baseline — без альтернатив

| Area | Fixed technology |
|---|---|
| Mobile/Desktop app | Flutter |
| Flutter language | Dart |
| Spectator web | React |
| Web language | TypeScript |
| Web tooling | Vite |
| State management / composition | `flutter_riverpod` |
| Local DB | SQLite + `drift` |
| Simple non-critical settings | `shared_preferences` |
| Flutter routing | `go_router` |
| Host HTTP | `shelf` |
| HTTP routing | `shelf_router` |
| Static web hosting | `shelf_static` |
| Host WebSocket | `shelf_web_socket` |
| Participant WebSocket | `web_socket_channel` |
| React WebSocket | Browser native WebSocket |
| Wire format | JSON |
| JSON DTO codegen | `json_serializable` |
| Immutable/codegen models | `freezed` where useful |
| Equality | `equatable` only where not already provided by generated model |
| Code generation | `build_runner` |
| QR generation | `qr_flutter` |
| QR scanning | `mobile_scanner` |
| Local notifications | `flutter_local_notifications` |
| Distributed IDs | `uuid` |
| Monorepo automation | Makefile + scripts |
| Source control | Git |

`shared_preferences` запрещён для profile, active tournament, history, reconnect cache или event log.

## 17. Riverpod, routing и UI state

Riverpod используется только для:

- presentation state;
- async state;
- dependency wiring;
- lifecycle application objects;
- предоставления Services UI.

Riverpod notifier/provider не содержит tournament business rules и не вызывает concrete Drift/WebSocket classes напрямую.

Navigation отражает application state:

```text
Tournament State -> Navigation
```

Обратная причинность (`Navigation -> Tournament State`) запрещена.

## 18. Design system — единый visual language

Визуальный характер продукта:

> **Competitive / Cinematic / Clean**

Базовые принципы:

- information before decoration;
- dark-first;
- high contrast;
- сильная typography hierarchy;
- character artwork является identity;
- mobile-first Flutter;
- structurally adaptive desktop Flutter;
- desktop-first presentation-oriented spectator web;
- Flutter и Web используют один semantic token model.

### 18.1. Spacing

Base unit: **4 px**.

| Token | px |
|---|---:|
| `space.0` | 0 |
| `space.1` | 4 |
| `space.2` | 8 |
| `space.3` | 12 |
| `space.4` | 16 |
| `space.5` | 20 |
| `space.6` | 24 |
| `space.8` | 32 |
| `space.10` | 40 |
| `space.12` | 48 |
| `space.16` | 64 |
| `space.20` | 80 |
| `space.24` | 96 |

Random component spacing outside token scale запрещён, кроме локально обоснованных artwork/platform/math cases.

### 18.2. Breakpoints и layout

| Name | Width |
|---|---:|
| compact | `< 600 px` |
| medium | `600-959 px` |
| expanded | `960-1279 px` |
| large | `1280-1599 px` |
| xlarge | `>= 1600 px` |

Flutter page padding:

- compact: 16 px, absolute minimum 12 px;
- tablet/medium: 24-32 px;
- desktop: 32-48 px;
- operational max content width: 1200-1440 px.

Spectator Web max content width: 1440-1600 px, centered on wider screens.

Desktop обязан менять composition и information density, а не растягивать mobile cards.

### 18.3. Typography

Основной UI использует один sans-serif family. Дополнительный display font разрешён только для very large presentation headings.

| Token | Size / line | Weight | Use |
|---|---|---:|---|
| `display.xl` | 56/64 | 700 | web hero/champion |
| `display.lg` | 48/56 | 700 | web major heading |
| `display.md` | 40/48 | 700 | tournament presentation |
| `heading.xl` | 32/40 | 700 | page title |
| `heading.lg` | 28/36 | 700 | major section |
| `heading.md` | 24/32 | 600 | card/section heading |
| `heading.sm` | 20/28 | 600 | component heading |
| `body.lg` | 18/28 | 400/500 | emphasized body |
| `body.md` | 16/24 | 400 | body |
| `body.sm` | 14/20 | 400 | secondary body |
| `label.lg` | 16/20 | 600 | major controls |
| `label.md` | 14/20 | 600 | buttons/tabs |
| `label.sm` | 12/16 | 600 | badges/metadata |

Score/standings/statistics используют tabular figures, если font поддерживает.

### 18.4. Colors

Base palette:

| Semantic token | Hex |
|---|---|
| `bg.canvas` | `#0B0D10` |
| `bg.subtle` | `#111419` |
| `bg.elevated` | `#171B21` |
| `surface.primary` | `#15191F` |
| `surface.secondary` | `#1B2027` |
| `surface.tertiary` | `#232A33` |
| `surface.hover` | `#29313B` |
| `text.primary` | `#F5F7FA` |
| `text.secondary` | `#B9C0CA` |
| `text.tertiary` | `#7F8996` |
| `text.disabled` | `#58616D` |
| `accent.primary` | `#F0B429` |
| `status.success` | `#36C98F` |
| `status.danger` | `#F05D5E` |
| `status.warning` | `#F5A623` |
| `status.info` | `#4DA3FF` |

State никогда не кодируется только цветом; обязательны text/icon/shape cues.

### 18.5. Radius, borders, elevation

| Radius token | px |
|---|---:|
| `radius.sm` | 6 |
| `radius.md` | 10 |
| `radius.lg` | 14 |
| `radius.xl` | 20 |
| `radius.full` | 999 |

Base border: 1 px semantic border. Separation preference: surface tone -> border -> spacing -> shadow. Heavy blurred shadows не являются базовым UI mechanism.

### 18.6. Buttons и touch targets

Minimum interactive area mobile: 44x44 px; preferred 48x48 px.

Button hierarchy:

- Primary — одно dominant action в visual region;
- Secondary;
- Tertiary/Ghost;
- Destructive — визуально отдельно от Primary.

Button heights:

- compact: 36-40 px;
- standard: 44-48 px;
- large: 52-56 px.

### 18.7. Participant identity

До Distribution participant может отображаться nickname + Guest/status.

После assignment любое tournament representation обязано включать:

1. Character Asset;
2. Character Name;
3. Participant Nickname.

Guest использует тот же identity pattern плюс secondary `Guest` badge.

Character artwork — часть identity, а не background decoration. Crop policy стабилен для каждого component variant.

### 18.8. Matchup и tournament structure

Current Match — самый сильный operational state.

Приоритет tournament structure:

1. relationship matches/positions;
2. participant identity;
3. result/state;
4. metadata.

RR standings на desktop — table, а не card wall. Mobile допускает compact rows, horizontal scroll или adaptive ranking list.

### 18.9. Motion

| Token | Duration |
|---|---:|
| `motion.fast` | 120 ms |
| `motion.normal` | 200 ms |
| `motion.slow` | 320 ms |
| `motion.presentation` | 450 ms |

Motion объясняет change of state. Infinite blinking/glow/autoplay decoration запрещены. Reduced Motion обязателен: movement заменяется fade, информация не зависит от animation.

### 18.10. Accessibility

- обычный text contrast >= 4.5:1;
- large text >= 3:1;
- critical metadata не прячется в tiny tertiary text;
- desktop/web keyboard focus обязателен;
- hover не является единственным способом получить information/action;
- status имеет text label;
- character image имеет semantic character name;
- color не является единственным carrier meaning.

## 19. Error, loading и stale states

Loading локализуется к конкретной области; global spinner для локальных operations без необходимости запрещён.

WebSocket reconnect отображается как connection state.

Error UI обязан:

- называть понятную пользователю проблему;
- быть локальным к action/context;
- иметь recovery action, если recovery возможен;
- не показывать stack trace.

Participant/Web при disconnect показывают last-known data с явным stale indicator и не имитируют live state.

## 20. History, Settings и account reset

History единая для hosted и participated tournaments. В ней только `Finished` и `Cancelled`.

History card минимальна:

- title;
- date;
- place, если реально определено;
- terminal status, если не обычный Finished.

Settings MVP:

- global local notifications toggle;
- «не показывать confirmation старта турнира»;
- «Очистить историю» с confirmation;
- «Удалить аккаунт» с отдельным explicit confirmation.

Account deletion удаляет profileId, nickname, history/statistics, active tournament/reconnect data и settings, после чего приложение возвращается к first-run Registration.

## 21. MVP exclusions — не реализовывать

В MVP запрещено добавлять:

- cloud sync/backend accounts;
- email/password identity;
- несколько local profiles;
- несколько active tournaments на Host;
- несколько одновременных Current matches;
- multiple game stations;
- pause lifecycle;
- per-player reroll;
- character exclusions;
- participant online/offline presence как business feature;
- notification history/center;
- manual spectator refresh как sync mechanism;
- auto-discovery Host for reconnect;
- permanent external spectator hosting;
- arbitrary edit/delete single historical snapshot;
- guest-to-profile conversion;
- profile avatars;
- privacy permission matrix for shared profile;
- match draws;
- separate match `Cancelled` state.

## 22. Architecture decision matrix — единственный допустимый baseline

| Decision | Fixed choice | Forbidden interpretation |
|---|---|---|
| Active tournament authority | Flutter Host | client-side consensus / cloud authority |
| Business truth | Domain + format engines on Host | Riverpod/React/networking rules |
| Persistence truth | Active Snapshot | Event Sourcing |
| Reconnect buffer | Active Event Log | event log as permanent history |
| Atomic mutation | snapshot + events in one DB transaction | save/broadcast independently |
| Tournament formats | one engine per format + registry | large switch in controller/service |
| Game-specific logic | Game Definition + assignment layer | MK11 types in Tournament core |
| DI | constructor/provider injection via app/Riverpod | global service locator / mandatory DI container |
| DB | Drift over SQLite | shared_preferences for business data |
| Realtime | JSON WebSocket | polling as primary sync |
| Web | React read-only projection | duplicated tournament engine |
| UI state | Riverpod presentation/application lifecycle | business rules inside providers |
| Navigation | derived from application state | navigation mutates lifecycle |
| Desktop UI | structural adaptation | stretched mobile layout |
| Participant identity after Distribution | artwork + character + nickname | nickname-only tournament identity |

## 23. Acceptance invariants

Реализация считается архитектурно корректной только если одновременно выполняются все пункты:

1. Host может провести tournament полностью offline от Internet.
2. Любой mutation authoritative state проходит через Service + Domain и committed persistence transaction.
3. Participant/Web не могут получить иной tournament result путём локального computation.
4. Restart Host восстанавливает Active Tournament без потери consistency.
5. Reconnect Participant после missed events приходит к exact Host state.
6. Finished/Cancelled history остаётся immutable.
7. DE/SE/RR rules не смешаны между engines.
8. Добавление нового format не меняет существующие engines.
9. MK11 roster/characters не находятся в Tournament Domain core.
10. Technical results не маскируются normal score.
11. Одновременно существует максимум один Current match.
12. Distribution character uniqueness соблюдается.
13. Participant после Distribution в tournament UI всегда имеет full character identity.
14. React не содержит authoritative business logic.
15. Design tokens являются источником visual values, а magic numbers — исключением.
16. Desktop layout структурно отличается от compact layout, когда viewport это позволяет.
17. Disconnect state явно отличим от live state.
18. Critical state доступен без color-only, hover-only или motion-only encoding.

## 24. Итоговая архитектура в одной схеме

```text
                         LOCAL NETWORK

+--------------------------- HOST DEVICE ---------------------------+
| Flutter tournament_app                                              |
|                                                                     |
|  UI / Riverpod                                                      |
|       |                                                             |
|       v                                                             |
|  Application Services                                               |
|       |                                                             |
|       v                                                             |
|  Domain ---------------------------------------------------------+  |
|  | Tournament core | DE/SE/RR engines | MK11 Game Definition    |  |
|  +---------------------------------------------------------------+  |
|       |                                                             |
|       v                                                             |
|  Infrastructure                                                     |
|   | Drift/SQLite | Snapshot + Event Log | Shelf HTTP/WebSocket |    |
|   | Notifications | DTO/Mapper | QR/static React hosting       |    |
+---+----------------------+------------------------------+-----------+
    |                      |                              |
    | WebSocket JSON       | HTTP static + WebSocket      | local DB
    v                      v                              v
+----------------+   +----------------------+       +-------------+
| Participant    |   | Spectator Web        |       | Host state  |
| Flutter app    |   | React / TypeScript   |       | source of   |
| read-only      |   | read-only projection |       | truth       |
| remote state   |   |                      |       +-------------+
+----------------+   +----------------------+
```

**Правило финальной интерпретации:** если implementation choice нарушает схему, decision matrix или acceptance invariants этого документа, choice считается архитектурно недопустимым для MVP.
