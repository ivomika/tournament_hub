# Tournament HUB — Technical Design Document

**Status:** Draft
**Product:** Tournament HUB
**Document type:** Technical Design / System Architecture
**Scope:** MVP
**Primary client:** Flutter
**Spectator client:** React Web
**Architecture:** Local-first

---

# 1. Purpose

Этот документ описывает техническую архитектуру **Tournament HUB**.

Он фиксирует:

- состав системы;
- границы ответственности компонентов;
- структуру монорепозитория;
- основные доменные сущности;
- хранение состояния;
- взаимодействие устройств;
- жизненный цикл локальной группы;
- жизненный цикл турнира;
- synchronization model;
- spectator architecture;
- обработку reconnect;
- доставку результатов;
- требования к устойчивости;
- требования к тестированию;
- технические границы MVP.

Документ не является описанием UI-дизайна.

---

# 2. System Overview

Tournament HUB состоит из двух пользовательских приложений:

1. **Tournament App** — Flutter-приложение.
2. **Spectator Web** — React-приложение.

Главное Flutter-приложение может работать в двух ролях:

```text
Host
Participant
```

Host одновременно может быть участником турнира.

Общая схема:

```text
                    Tournament HUB

                ┌────────────────────┐
                │    Flutter Host    │
                │                    │
                │ Tournament State   │
                │ Local Group State  │
                │ Local Server       │
                └─────────┬──────────┘
                          │
                  Local Network
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
┌───────────────┐ ┌───────────────┐ ┌─────────────────┐
│ Flutter       │ │ Flutter       │ │ Browser         │
│ Participant   │ │ Participant   │ │ React Spectator │
└───────────────┘ └───────────────┘ └─────────────────┘
```

---

# 3. Architecture Principles

## 3.1. Local First

Основной сценарий Tournament HUB не зависит от публичного backend.

Во время турнира:

```text
Host device = session authority
```

Все устройства взаимодействуют напрямую внутри локальной сети.

---

## 3.2. Host as Session Authority

Host является единственным authoritative source активной турнирной сессии.

Host хранит актуальное состояние:

- Local Group;
- участников;
- Tournament;
- Matches;
- Standings;
- Rounds;
- Current Match;
- Display State;
- результаты.

Participant и Spectator получают производное состояние.

---

## 3.3. Domain Logic Isolated from UI

Турнирные правила не должны находиться внутри UI.

Архитектурный поток:

```text
Presentation
     ↓
Application
     ↓
Domain
     ↓
Persistence / Transport
```

Турнирная бизнес-логика должна быть доступна независимо от Flutter widgets.

---

## 3.4. Transport Is Not Domain

Network messages не должны напрямую определять бизнес-логику.

Например:

```text
Network message:
"match result changed"

        ↓

Application command

        ↓

Tournament domain validates change

        ↓

Tournament state updated
```

---

## 3.5. Derived State

Standings являются производным состоянием.

Источник истины:

```text
Tournament
+
Participants
+
Matches
+
Results
```

Standings не должны существовать как независимая изменяемая модель.

---

## 3.6. Immutable Historical Snapshots

Завершенный турнир должен храниться как исторический snapshot.

Изменение текущего профиля игрока не должно изменять:

- старый nickname;
- старый fighter;
- старый результат;
- standings завершенного турнира;
- список участников.

---

# 4. Monorepository

Корневая структура:

```text
tournament-hub/
│
├── apps/
│   │
│   ├── tournament_app/
│   │
│   └── spectator_web/
│
├── docs/
│   ├── product/
│   ├── architecture/
│   ├── protocol/
│   ├── tournament/
│   └── adr/
│
├── tools/
│   └── scripts/
│
├── .github/
│   └── workflows/
│
├── README.md
└── .gitignore
```

Отдельная директория `packages/` не используется.

---

# 5. Flutter Application Structure

Пример feature-oriented структуры:

```text
apps/tournament_app/
│
├── lib/
│   │
│   ├── app/
│   │
│   ├── core/
│   │   ├── database/
│   │   ├── identity/
│   │   ├── networking/
│   │   ├── discovery/
│   │   ├── server/
│   │   └── common/
│   │
│   ├── features/
│   │   ├── profile/
│   │   ├── career/
│   │   ├── local_group/
│   │   ├── tournament/
│   │   ├── matches/
│   │   ├── standings/
│   │   ├── achievements/
│   │   ├── history/
│   │   └── spectator/
│   │
│   └── shared/
│
├── assets/
│   ├── fighters/
│   └── spectator/
│
└── test/
```

Каждая feature может разделяться на:

```text
domain/
application/
data/
presentation/
```

Точная глубина структуры определяется сложностью feature.

---

# 6. React Spectator Structure

Пример:

```text
apps/spectator_web/
│
├── src/
│   ├── app/
│   ├── transport/
│   ├── state/
│   │
│   ├── screens/
│   │   ├── dashboard/
│   │   ├── current-match/
│   │   ├── rounds/
│   │   ├── matrix/
│   │   ├── standings/
│   │   ├── players/
│   │   └── champion/
│   │
│   └── components/
│
└── public/
```

Spectator Web является read-oriented клиентом.

Он не содержит Tournament Engine.

---

# 7. Core Domains

Система разделяется на несколько доменных областей:

```text
Identity
Profile
Career

Local Group

Tournament
Matches
Standings
Achievements

Tournament History

Spectator
```

---

# 8. Player Identity

Каждый профиль должен иметь постоянный уникальный идентификатор.

Identity:

- создается один раз;
- сохраняется локально;
- не зависит от nickname;
- не зависит от устройства как hardware identity;
- используется для связывания участника между турнирами.

Nickname является изменяемым атрибутом.

---

# 9. Player Profile

Обязательные данные MVP:

```text
PlayerProfile
├── id
└── nickname
```

Опционально:

```text
favorite fighter
player avatar
profile metadata
```

Требование к собственному Player Avatar пока не зафиксировано.

---

# 10. Fighter

Для Mortal Kombat 11 используется полный roster.

Fighter должен иметь стабильную identity.

Минимально:

```text
Fighter
├── id
├── name
└── chibi avatar
```

Для каждого fighter необходим chibi-style avatar.

Fighter assets должны использовать единый визуальный стиль.

---

# 11. Group Member

Group Member представляет профиль внутри активной Local Group.

Он не является Tournament Player автоматически.

Состояние группы может содержать:

```text
Connected
Disconnected
Pending Approval
Rejected
```

---

# 12. Tournament Player

Tournament Player — snapshot участника турнира.

Он должен отделяться от Player Profile.

Snapshot должен сохранять как минимум:

```text
Tournament Player
├── tournamentPlayerId
├── profileId, если существует
├── nickname snapshot
├── player avatar snapshot, если существует
├── fighter
├── participant status
└── guest flag
```

---

# 13. Guest Player

Guest не имеет постоянного Player Profile в Tournament HUB.

Host создает его непосредственно в текущей группе или турнире.

Guest после добавления становится полноценным Tournament Player.

Его snapshot должен сохраняться после завершения турнира.

---

# 14. Local Group

Local Group является session entity.

Основные данные:

```text
Group
├── group id
├── name
├── host
├── members
├── guests
└── state
```

Базовые состояния:

```text
Waiting
Tournament Active
Closing
Closed
```

---

# 15. Join Lifecycle

Подключение требует подтверждения Host.

Lifecycle:

```text
Discovered
    ↓
Join Requested
    ↓
Pending Host Approval
   / \
  /   \
 ▼     ▼
Accepted Rejected
   ↓
Connected
```

Host должен видеть публичную информацию о профиле до принятия решения.

---

# 16. Disconnect Lifecycle

Temporary disconnect не удаляет участника.

Пример:

```text
Connected
    ↓
Connection Lost
    ↓
Disconnected
    ↓
Reconnect
    ↓
Connected
```

После reconnect participant получает актуальное состояние группы и турнира.

---

# 17. Tournament Aggregate

Tournament является основной агрегированной сущностью соревнования.

Он содержит:

```text
Tournament
├── id
├── name
├── format
├── rules
├── participants
├── rounds
├── matches
├── current match
├── status
└── timestamps
```

---

# 18. Tournament Lifecycle

Основные состояния:

```text
Draft
  ↓
Ready
  ↓
Active
  ↓
Tie Break
  ↓
Finished
```

`Tie Break` возникает только при необходимости дополнительных матчей для определения точного порядка мест.

---

# 19. Tournament Format MVP

MVP поддерживает:

```text
Round Robin
```

Все участники играют друг с другом один раз.

Количество основных матчей:

```text
N × (N - 1) / 2
```

Tie-break матчи в эту формулу не входят.

---

# 20. Tournament Rounds

Round Robin должен иметь понятие `Round`.

Round:

```text
Round
├── number
├── matches
└── state
```

Rounds входят в MVP.

Требуется обеспечить такое распределение матчей, при котором один участник не играет два основных матча внутри одного Round.

При нечетном количестве участников один участник может иметь Bye в конкретном Round.

---

# 21. Match

Матч должен содержать:

```text
Match
├── id
├── round
├── player A
├── player B
├── status
├── result
└── result type
```

---

# 22. Match Status

Минимальные состояния:

```text
Scheduled
Current
Completed
Technical
Cancelled
```

Необязательно все состояния должны отображаться пользователю напрямую.

---

# 23. Match Rules MVP

Формат:

```text
Best of 3
First to 2
```

Допустимые спортивные результаты:

```text
2:0
2:1
1:2
0:2
```

---

# 24. Technical Result

Technical Result должен отличаться от реально сыгранного матча.

Пример:

```text
Normal Result
Technical Result
```

Оба могут иметь счет `2:0`, но имеют различную семантику.

Это важно для:

- истории;
- статистики;
- будущих achievements;
- анализа результатов.

---

# 25. Scoring Rules

Финальная система очков пока не утверждена.

Текущий кандидат:

```text
2:0 → 3 / 0
2:1 → 2 / 1
1:2 → 1 / 2
0:2 → 0 / 3
```

До реализации scoring logic это решение должно быть подтверждено.

---

# 26. Standings

Standings вычисляются на основании результатов Tournament.

Показатели MVP:

```text
Position
Player
Fighter

Matches Played
Wins
Losses

Games Won
Games Lost
Game Difference

Points
```

---

# 27. Tie Breakers

Финальный порядок стандартных tie breakers пока не утвержден.

Кандидаты:

```text
Points
Wins
Game Difference
Games Won
Head-to-Head
```

Ключевое продуктовое правило уже зафиксировано:

> Если стандартные критерии не позволяют однозначно распределить места, порядок определяется дополнительными матчами.

---

# 28. Tie-Break Stage

Tie-break используется для любых мест.

Например:

```text
1
2
3/4 tie
5
6/7 tie
```

Необходимо определить:

```text
3 vs 4
6 vs 7
```

Турнир не считается окончательно завершенным, пока каждое место не определено.

---

# 29. Multi-Player Tie

Если равенство возникает между более чем двумя игроками:

```text
Player A
Player B
Player C
```

создается отдельный Tie-Break Stage.

Его формат должен позволить получить однозначный порядок всех связанных игроков.

Если после tie-break снова возникает равенство, создается следующий tie-break.

---

# 30. Exact Placement Requirement

Finished Tournament должен иметь уникальное место для каждого участника.

Например:

```text
1
2
3
4
5
```

Не допускается окончательный результат:

```text
1
2
3
3
5
```

---

# 31. Character Assignment

До старта Tournament каждому участнику назначается уникальный fighter.

MVP rules:

```text
Random
Unique
Locked
```

После начала турнира fighter изменить нельзя.

---

# 32. Tournament Roster Changes

Изменение состава после старта разрешено.

Это относится к:

- позднему добавлению участника;
- выходу участника;
- исключению участника.

При изменении состава Tournament Engine должен сохранить корректность уже существующей истории.

---

# 33. Withdrawal

Если участник покидает активный турнир:

- завершенные матчи сохраняются;
- уже введенные результаты сохраняются;
- несыгранные матчи получают технический результат;
- участник остается в snapshot турнира;
- участник получает статус Withdrawn.

Он не удаляется из исторического Tournament.

---

# 34. Late Join

Позднее добавление участника разрешено.

Для матчей, которые новый участник уже не может сыграть из-за прошедшей части турнира, применяется Technical Loss согласно турнирным правилам.

Для доступных будущих матчей он участвует обычно.

Точная логика определения пропущенных матчей должна учитывать структуру Rounds.

---

# 35. Current Match

Host может обозначить Match как Current.

Current Match:

- используется внутри Flutter UI;
- передается participant clients;
- доступен spectator;
- может изменяться Host.

Наличие Current Match не влияет на спортивный результат.

---

# 36. Tournament Completion

Перед переходом в Finished необходимо проверить:

- все обязательные основные матчи имеют результат;
- все необходимые technical results применены;
- все ties разрешены;
- каждое место уникально.

После этого формируется Final Tournament Snapshot.

---

# 37. Tournament Snapshot

После завершения Tournament создается immutable snapshot.

Он должен содержать все данные турнира.

Пользователь зафиксировал требование:

> На устройстве участника необходимо сохранять весь турнир, а не только его личный результат.

Snapshot включает:

```text
Tournament metadata

Rules

Participants
Player snapshots
Guest snapshots

Fighter assignments

Rounds

All matches
All results
Technical results

Final standings
Final placements

Champion

Achievements

Tournament timestamps
```

---

# 38. Player Tournament History

Локальная история является набором завершенных Tournament Snapshots, связанных с Player Profile.

Из них вычисляется Career State.

---

# 39. Career State

Career является derived state.

Минимальные показатели:

```text
Tournaments Played
Matches Played
Wins
Losses
Championships
Win Rate
Achievements
```

В будущем:

```text
Fighter statistics
Opponent statistics
Rivalries
Head-to-head
Streaks
```

---

# 40. Achievements

Achievements должны иметь два контекста.

```text
Tournament Achievement
Career Achievement
```

---

# 41. MVP Achievements

Первоначально нужны простые достижения.

Обязательное:

```text
First Fight
```

Дополнительные легкие кандидаты:

```text
First Victory
First Tournament
Clean Win
Champion
Undefeated
```

Конкретный MVP-набор должен быть утвержден отдельно.

---

# 42. Local Persistence

Состояние подразделяется на:

```text
Persistent Personal State

Persistent Tournament State

Session State

Derived State
```

---

# 43. Persistent Personal State

Должно переживать перезапуск приложения:

```text
Player identity
Player profile
Tournament history
Career
Achievements
Settings
```

---

# 44. Persistent Host Tournament State

Активный Host должен сохранять состояние турнира достаточно часто, чтобы случайный перезапуск приложения не приводил к потере введенных результатов.

Пользователи должны получать уведомление при потере соединения с Host.

Точное продуктовое поведение восстановления активной групповой сессии после полного restart Host требует отдельного решения.

---

# 45. Session State

Примеры session-only данных:

```text
Current connections
Pending join requests
Spectator connections
Transient network state
```

Некоторые session данные могут восстанавливаться из persistent state.

---

# 46. State Synchronization

Participant после подключения или reconnect должен получить полный актуальный snapshot активной сессии.

После initial sync могут использоваться incremental updates.

Модель:

```text
Connect
   ↓
Full State
   ↓
Incremental Events
   ↓
Connection Lost
   ↓
Reconnect
   ↓
Full State
```

Full State после reconnect имеет приоритет над локальным stale state.

---

# 47. Conflict Model

В MVP изменение Tournament State выполняет Host.

Participant не должен самостоятельно менять authoritative Tournament State.

Participant может отправлять:

```text
Join request
Profile update
Acknowledgement
Client intent
```

Но спортивные результаты и структура Tournament подтверждаются Host.

Это позволяет избежать distributed conflict resolution в MVP.

---

# 48. Communication Channels

Необходимо логически разделить:

```text
Commands
Events
Snapshots
```

### Command

Запрос на действие.

### Event

Уже произошедшее изменение.

### Snapshot

Текущее полное состояние.

---

# 49. Protocol Versioning

Все клиенты должны использовать versioned communication protocol.

При несовместимой версии Participant должен получать понятный статус incompatibility вместо неопределенного поведения.

Protocol version должен быть частью session negotiation.

---

# 50. Message Categories

Необходимые категории:

```text
Connection
Session
Group
Profile
Tournament
Match
Standings
Display
Results
Heartbeat
Errors
```

---

# 51. Reconnect

Participant reconnect является обязательной частью MVP.

После reconnect он должен видеть:

```text
Current Group State
Current Tournament
Current Round
Current Match
Current Standings
Remaining Matches
```

Локальное устаревшее состояние заменяется текущим Host State.

---

# 52. Host Connection Loss

Participant должен явно видеть потерю Host.

Состояние нельзя маскировать как обычную загрузку.

Пример состояний:

```text
Connected
Host unavailable
Reconnecting
Connected
```

Необходимо отдельное пользовательское уведомление.

---

# 53. Result Delivery

После завершения Tournament Host формирует Final Tournament Snapshot.

Каждый connected Player получает его.

Delivery должна быть:

```text
Idempotent
Retryable
```

Повторная доставка не должна создавать дубликат турнира в истории.

---

# 54. Result Identity

Каждый завершенный Tournament имеет стабильный уникальный ID.

Participant использует его для проверки:

```text
Already stored?
```

Это предотвращает duplicate history entries.

---

# 55. Pending Delivery

Если Participant недоступен в момент завершения:

```text
Result
   ↓
Pending Delivery
```

После reconnect возможна повторная отправка.

Политика времени хранения Pending Delivery пока не определена.

---

# 56. Spectator Architecture

Spectator получает отдельную read model.

Он не должен получать внутреннее состояние Tournament Engine без необходимости.

Поток:

```text
Tournament State
      ↓
Display Projection
      ↓
Spectator State
      ↓
React
```

---

# 57. Spectator Modes

MVP:

```text
Dashboard
Current Match
Rounds
Matrix
Standings
Champion
```

Rounds входит в MVP.

---

# 58. Spectator Navigation

Spectator может самостоятельно выбирать экран.

Необходимо поддержать два поведения.

## Follow Host

Spectator следует текущему presentation mode Host.

## Free View

Spectator самостоятельно выбирает доступный screen.

---

# 59. Multiple Spectators

Продукт не вводит искусственного ограничения количества spectator connections.

Система должна проектироваться как one-to-many distribution:

```text
Host
 ↓
Display State
 ↓
N Spectators
```

Практический предел определяется ресурсами Host и локальной сети.

---

# 60. Spectator Permissions

Spectator является read-only клиентом.

Он может:

```text
Navigate spectator screens
Switch Follow Host / Free View
```

Он не может:

```text
Change match result
Change tournament rules
Change participants
Finish tournament
```

---

# 61. React Distribution

Spectator Web является частью Tournament HUB monorepository.

Production spectator bundle должен поставляться вместе с Tournament App.

С точки зрения продукта:

```text
Install Tournament HUB Host
        ↓
Spectator UI already available
```

Пользователь не должен отдельно устанавливать spectator server.

---

# 62. Initial Spectator State

После открытия spectator должен получить полное текущее Display State.

То есть spectator может подключиться:

- до турнира;
- во время турнира;
- после нескольких сыгранных матчей;
- перед финальным tie-break;
- после завершения.

Во всех случаях он должен восстановить текущую картину одним initial sync.

---

# 63. Error Model

Система должна иметь нормализованные категории ошибок.

Минимально:

```text
Validation Error
Permission Error
Protocol Error
Session Error
Tournament Rule Error
Connection Error
Not Found
Conflict
```

Ошибки должны быть пригодны для:

- отображения пользователю;
- логирования;
- тестирования.

---

# 64. Validation

Validation требуется как минимум для:

```text
nickname
group join
tournament creation
participant count
fighter availability
match result
roster mutation
tournament completion
tie-break completion
result import
```

Domain validation имеет приоритет перед UI validation.

---

# 65. Idempotency

Следующие операции должны быть idempotent:

```text
Reconnect
Full state sync
Tournament result delivery
Repeated event reception
Profile snapshot reception
```

Duplicate network event не должен повторно применять спортивный результат.

---

# 66. Ordering

Изменения Tournament State должны иметь упорядочивание.

Participant и Spectator должны иметь возможность понять, что новое состояние новее локального.

Для session state необходимо предусмотреть revision/version sequence.

---

# 67. Tournament Revision

Каждая authoritative модификация Tournament может увеличивать revision.

Например концептуально:

```text
Tournament revision 41
Tournament revision 42
Tournament revision 43
```

Это позволяет обнаружить:

- stale client state;
- пропущенные updates;
- необходимость full resync.

---

# 68. Security Scope MVP

Tournament HUB работает в доверенной локальной среде.

MVP не требует полноценной cryptographic identity.

Однако необходимо соблюдать:

```text
Host approval
Session isolation
Stable profile identity
Input validation
Read-only spectator permissions
```

---

# 69. Future Identity Security

Вне MVP могут появиться:

```text
Player key pair
Signed identity challenge
Signed Tournament Results
Trusted known profiles
```

Архитектура не должна делать это обязательным для local-first использования.

---

# 70. Privacy

По умолчанию Participant не должен передавать Host лишние локальные данные.

Передается только информация, необходимая для:

```text
Group
Tournament
Public profile
Shared statistics
```

Полная личная история остается локальной, кроме тех Tournament Snapshots, участниками которых являются обе стороны и которые необходимы конкретной функции.

---

# 71. Logging

Нужно разделять:

```text
Application logs
Network logs
Tournament audit events
```

Tournament audit особенно полезен для debugging изменения результатов.

Примеры audit actions:

```text
Tournament started
Player added
Player withdrawn
Result entered
Result changed
Technical result applied
Tie-break created
Tournament finished
```

---

# 72. Testing Strategy

MVP требует несколько уровней тестирования.

---

# 73. Domain Tests

Наиболее критический уровень.

Обязательные случаи:

```text
Round Robin generation
Odd player count
Even player count
No duplicate pairs
Round scheduling
Scoring
Standings recalculation
Result editing
Fighter uniqueness
Player withdrawal
Late join
Technical result
Tie-break detection
Tie-break completion
Unique final placements
Tournament completion
```

---

# 74. Property / Invariant Tests

Полезные инварианты:

```text
Игрок не играет сам с собой.

Одна основная пара не создается дважды.

До roster mutation количество основных матчей соответствует формуле Round Robin.

Каждый active player имеет уникального fighter.

Finished tournament не содержит unresolved placement ties.

Standings всегда воспроизводимы из match history.

Повторное применение одного результата не изменяет итог второй раз.
```

---

# 75. Persistence Tests

Проверить:

```text
Profile survives restart
Active tournament survives storage cycle
Finished snapshots immutable
History not duplicated
Result delivery idempotent
```

---

# 76. Networking Tests

Проверить:

```text
Join
Reject
Accept
Disconnect
Reconnect
Initial sync
Missed event recovery
Multiple clients
Multiple spectators
Host unavailable
Protocol mismatch
```

---

# 77. Spectator Tests

Проверить:

```text
Connect during active tournament
Connect after several rounds
Free View
Follow Host
Standings update
Current Match update
Champion transition
Reconnect
```

---

# 78. MVP Non-Functional Requirements

## Offline

После установки основной турнирный сценарий не требует внешнего интернета.

## Recovery

Закрытие UI не должно автоматически уничтожать историю Tournament.

## Consistency

Все connected clients должны сходиться к Host State.

## Responsiveness

Изменения результата должны быстро отображаться на spectator clients в пределах локальной сети.

## Scalability

Нет фиксированного программного лимита на spectator clients.

## Portability

Основная доменная логика не должна зависеть от конкретной presentation platform.

---

# 79. MVP Technical Scope

В MVP необходимо реализовать следующие технические области:

```text
Player Identity
Player Profile
Local Persistence

Local Group
Host / Participant lifecycle
Reconnect

Round Robin Domain
Rounds
Matches
Technical Results
Standings
Tie Break Stage

Fighter Assignment
Full MK11 Roster

Tournament Snapshot
Player History
Basic Achievements

Spectator State
Multiple Spectators
Follow Host / Free View

Result Delivery
Duplicate Protection
```

---

# 80. Outside MVP

Не входит:

```text
Cloud backend
User accounts
Online authentication
Cloud sync

Global leaderboard
Friends
Chat
Push notifications

Single Elimination
Double Elimination
Swiss
Groups + Playoff

Host migration

Cryptographic identity
Signed tournament receipts

Profile transfer

Cross-device cloud backup

Known Players
Head-to-head career layer

Advanced achievements
Advanced privacy configuration

Character draft
Ban system
Winner Lock
```

---

# 81. Open Technical/Product Decisions

Перед freeze технической спецификации необходимо подтвердить:

### 1. Scoring

Текущий кандидат:

```text
2:0 → 3 / 0
2:1 → 2 / 1
```

Но решение пока не принято.

### 2. Standard Tie-Break Order

Нужно определить порядок критериев до создания Tie-Break Stage.

### 3. Host Restart

Зафиксировано требование уведомления при потере Host.

Нужно окончательно определить:

> должен ли active group/tournament автоматически восстанавливаться после полного restart Host.

### 4. Player Avatar

Необходимо решить, будет ли собственный Player Avatar частью MVP.

Fighter chibi avatars уже зафиксированы.

### 5. Pending Result Lifetime

Нужно определить, сколько времени Host хранит недоставленный результат.

### 6. Technical Wins and Career Stats

Нужно решить, входят ли Technical Wins/Losses в обычный career win rate или учитываются отдельно.

### 7. Late Join Rule

Общий принцип technical loss за пропущенную часть турнира принят.

Необходимо точно определить границу между пропущенными и будущими матчами.

---

# 82. Recommended Implementation Order

Технически проект следует развивать в следующей последовательности:

```text
Domain Specification
        ↓
Tournament Engine
        ↓
Persistence
        ↓
Local Tournament
        ↓
Group Session
        ↓
Synchronization
        ↓
Spectator State
        ↓
React Spectator
        ↓
Tournament History
        ↓
Achievements
        ↓
Recovery / Edge Cases
        ↓
MVP stabilization
```

Главное правило:

> Networking и UI не должны определять структуру Tournament Domain.

Сначала фиксируются бизнес-инварианты, затем вокруг них строятся synchronization и presentation layers.

---

# 83. MVP End-to-End Technical Acceptance

Система технически готова к MVP, когда проходит сценарий:

```text
Host profile
+
3 participant profiles
+
1 or more spectator clients
```

и выполняются требования:

1. Host создает Local Group.
2. Participants запрашивают подключение.
3. Host принимает их.
4. Все получают актуальное Group State.
5. Host создает Tournament.
6. Host также может быть Tournament Player.
7. Назначаются уникальные fighters.
8. Формируются Round Robin Rounds.
9. Tournament начинается.
10. Spectator подключается после старта и получает полное состояние.
11. Host вводит результаты.
12. Participant clients получают актуальное состояние.
13. Spectator получает обновления.
14. Один Participant временно disconnect.
15. Tournament продолжается.
16. Participant reconnect.
17. Он получает актуальный Tournament State.
18. Host изменяет ранее введенный результат.
19. Standings полностью пересчитываются.
20. Участник может покинуть Tournament.
21. Оставшиеся матчи получают Technical Result.
22. При необходимости появляется Tie-Break Stage.
23. Все итоговые места становятся уникальными.
24. Tournament переходит в Finished.
25. Формируется immutable Tournament Snapshot.
26. Snapshot доставляется каждому Player.
27. Повторная доставка не создает duplicate history.
28. Career State обновляется.
29. Spectator показывает Champion.
30. Внешний интернет для данного сценария не требуется.

---

# 84. Architecture Summary

Целевая архитектура Tournament HUB:

```text
                    TOURNAMENT HUB

                     Flutter Host
                          │
          ┌───────────────┼───────────────┐
          │               │               │
          ▼               ▼               ▼
       Profile        Tournament       Group
       & Career         Domain          Session
                          │
                          ▼
                    Authoritative
                       State
                          │
             ┌────────────┼─────────────┐
             │            │             │
             ▼            ▼             ▼
        Participant   Participant    Spectator
          Flutter       Flutter        React
             │            │             │
             └────────────┼─────────────┘
                          │
                     Local Network

Tournament finished
        │
        ▼
Immutable Tournament Snapshot
        │
        ├────────► Player History
        ├────────► Career Statistics
        └────────► Achievements
```

Основная техническая идея проекта:

> **Host-authoritative local-first tournament system с persistent player identity, realtime participant synchronization, immutable tournament history и независимым spectator presentation layer.**
