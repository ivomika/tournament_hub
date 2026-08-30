# Product guide

## Product statement

Tournament Hub проводит локальные турниры Mortal Kombat 11 без облачного backend. Flutter-приложение совмещает Host и Participant, а Host раздаёт read-only React Spectator Web по LAN. Интернет не требуется для полного Host flow.

## MVP outcome

Пользователь должен уметь:

1. Создать один постоянный local profile.
2. Создать и восстановить один active tournament.
3. Набрать local/remote participants и Guests.
4. Уникально распределить fighters и при необходимости выполнить `Reroll All`.
5. Провести DE, SE или RR по versioned ruleset.
6. Зафиксировать normal/technical results и допустимые corrections.
7. Получить champion/ranking, завершить либо отменить турнир.
8. Просмотреть immutable history и derived profile statistics.
9. Подключить Participant и Spectator в LAN без cloud dependency.

## Роли и permissions

| Действие | Host | Participant | Guest | Spectator |
|---|---:|---:|---:|---:|
| Создать/настроить турнир | Да | Нет | Нет | Нет |
| Открыть/закрыть набор | Да | Нет | Нет | Нет |
| Добавить/удалить Guest | Да | Нет | Нет | Нет |
| Присоединиться profile | Может как participant | Да, только Open | Нет | Нет |
| Выйти самостоятельно | Как organizer решает lifecycle | Только Open | Нет | Нет |
| Распределить/reroll fighters | Да | Нет | Нет | Нет |
| Записать/correct result | Да | Нет | Нет | Нет |
| Withdrawal participant | Да | Нет | Нет | Нет |
| Читать разрешённую projection | Да | Да | Через Host UI | Да |
| Вычислять progression/ranking | Authoritative Domain | Запрещено | Запрещено | Запрещено |

Host может не участвовать. Если Host участвует, одна participant identity ссылается на его local `profileId`; organizer permissions не переносятся в participant projection.

## Identity

- На устройстве существует один local profile: immutable `profileId`, изменяемый `nickname`.
- Nickname после trim не пуст; Unicode и emoji разрешены; глобальная уникальность не требуется.
- Tournament participant хранит snapshot nickname. Переименование profile не переписывает active/history snapshots.
- Guest имеет tournament-scoped ID, nickname и badge; между турнирами не связывается.
- Один `profileId` не создаёт duplicate participant: повторное соединение — reconnect.
- Один profile связан не более чем с одним незавершённым tournament.

## Lifecycle

App lifecycle отделён от tournament lifecycle. При запуске `AppBootstrap` последовательно восстанавливает committed local profile и optional active context, после чего публикует `profileRequired`, `operational` либо typed failure. Router только проецирует опубликованное состояние в допустимый экран; navigation/deep link не являются способом создать профиль, tournament или изменить lifecycle. Полный контракт задан в [ADR-0011](../adr/0011-app-lifecycle-and-state-driven-routing.md).

```text
Draft -> Open <-> Distribution -> Running -> Finished
   \        \          \             \
    +--------+----------+---------------> Cancelled
```

| State | Разрешено | Запрещено | Выход |
|---|---|---|---|
| Draft | title, format, typed settings; save/resume | participants, assignment, matches | Open или Cancelled |
| Open | join, Guest, remove/leave participant | менять базовые settings | Distribution или Cancelled |
| Distribution | full assignment, `Reroll All`, remove, back to Open | individual reroll, matches | Open, Running или Cancelled |
| Running | authoritative results, correction по engine, withdrawal | roster/settings/assignment mutation, pause/back | Finished или Cancelled |
| Finished | read-only ranking/history | любые mutation | terminal |
| Cancelled | read-only фактический snapshot | достраивать matches/ranking | terminal |

Переход выполняется Domain-командой. Навигация лишь отражает committed state и не является способом изменить lifecycle.

### Один active tournament

- Active: Draft/Open/Distribution/Running.
- Main при active tournament показывает «Продолжить» и скрывает создание второго.
- Нельзя молча заменить active tournament.
- Любая отмена/замена требует destructive confirmation с названием и необратимым последствием.
- Finished/Cancelled атомарно уходят в history и перестают быть active.

## Основные сценарии

### Первый запуск

```text
Bootstrap -> profileRequired -> Registration -> operational -> Main
Bootstrap -> operational(profile + optional active context) -> Main
Bootstrap -> recoverableFailure/fatalFailure -> Error projection
```

Ошибки storage показывают recovery action; stack trace пользователю не показывается. Повторный bootstrap не позволяет late result старой попытки заменить новое состояние.

### Host

```text
Main -> Draft -> Open -> Distribution -> Running -> Results/Champion -> Main/History
```

Каждый state переживает restart. Выход на Main не отменяет active tournament.

### Participant

```text
Main -> Scan/Code -> Handshake -> Open lobby -> Distribution -> Running -> Finished -> Main
```

При disconnect отображается last-known state + stale indicator. Локальный client не принимает tournament decisions.

### Spectator

```text
HTTP bundle -> Waiting/Connecting -> Distribution/Running -> Finished
```

Web read-only, автоматически синхронизируется snapshot/events и не имеет primary polling/manual-refresh механизма.

## Экранная карта

### Общая shell

- Main: create/join либо continue active; быстрые ссылки History/Profile/Settings.
- Profile: nickname и derived statistics.
- History: Finished/Cancelled list и immutable detail.
- Settings: notifications, start confirmation, clear history, delete account.

### Host screens

- Draft: title, format, format settings, validation, persistent summary.
- Open: connection QR/code, requests/roster, Guests, lifecycle actions.
- Distribution: полная сетка `fighter asset + fighter name + nickname`, reroll, start confirmation.
- Running: Current match, next context, bracket/rounds/standings, result entry and correction.
- Finished: champion hero, ranking, tournament structure, Main/History actions.
- Cancelled: фактическое summary без выдуманных places.

### Global UI states

Каждый async/network screen проектируется для `initial`, `loading`, `content`, `empty`, `offline/stale`, `incompatible`, `permissionDenied`, `notFound`, `error/retry`. Ошибка локализуется к области действия.

## History and statistics

History содержит только immutable Finished/Cancelled snapshots. Отдельное удаление snapshot запрещено; «Очистить историю» удаляет всё после confirmation.

Проекции profile вычисляются заново из history:

- tournament count/wins/win rate;
- normal match count/wins/win rate;
- best known place;
- последние три tournaments.

Technical results не входят в normal Match Win Rate. Host без participant place учитывается как организатор только если отдельная метрика это явно поддерживает.

## Notifications

Локальные notifications создаёт Participant app только из committed Host events: tournament start, own Current match, elimination, finished/place. Нет notification history, acknowledgement или replay missed notifications. Global toggle не влияет на in-app state.

## Non-functional requirements

- Полный Host flow работает offline от Internet.
- Crash/restart не теряет последний committed snapshot.
- Duplicate/reordered network messages не меняют результат повторно.
- History воспроизводима опубликованной версией ruleset.
- UI поддерживает compact-to-desktop composition, keyboard и reduced motion.
- External payload не попадает в Domain без validation.
- Секреты, local DB и личная history не публикуются Spectator.

## MVP exclusions

Cloud/backend accounts, несколько profiles, несколько active tournaments, multi-station/current matches, pause, individual reroll, fighter exclusions, presence feature, notification center, permanent hosting, guest conversion, avatars, draws и match-level Cancelled запрещены. Расширение требует новой задачи и изменения product scope.

## Traceable requirement IDs

| ID | Требование | Основная проверка |
|---|---|---|
| PR-001 | Host — единственный authority | Application/domain tests + protocol security tests |
| PR-002 | Один active tournament | Storage/application invariant tests |
| PR-003 | Lifecycle строго валидируется | Domain transition/property tests |
| PR-004 | Terminal snapshots immutable | Persistence contract tests |
| PR-005 | Participant/Spectator read-only | Permission/projection tests |
| PR-006 | Assignment полный и уникальный | Property tests |
| PR-007 | Main сохраняет и продолжает active state | Widget + restart integration tests |
| PR-008 | Offline Host cycle | E2E without Internet |
| PR-009 | History строит statistics | Projection tests |
| PR-010 | Все состояния UI доступны и восстанавливаемы | Widget/accessibility tests |
