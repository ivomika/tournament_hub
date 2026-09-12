# Domain layer

## Решение

`apps/tournament_app/lib/domain` содержит и Domain Business Logic, и Application Business Logic TournamentHUB. Отдельный верхнеуровневый слой `application` и классы вида `CreateTournamentUseCase` не создаются.

## Области

- `tournament` — active Tournament aggregate, lifecycle, participants и matches.
- `tournament_format` — versioned contract формата без его concrete implementations.
- `character_assignment` — связи Participant с Character и распределение.
- `profile` — устойчивая identity профиля.
- `game` — игра и versioned roster персонажей.
- `statistics` — authoritative statistics и controlled shared projection.
- `history` — immutable terminal snapshots.

## Границы зависимостей

- Presentation преобразует пользовательские намерения в команды Domain и отображает его read models.
- Domain не импортирует Flutter, Riverpod, persistence, serialization, WebSocket, HTTP или platform APIs.
- Infrastructure реализует Domain ports и repositories, но не меняет их business semantics.
- App отвечает за bootstrap, composition, DI, routing и configuration.

## Application Business Logic

Domain ports выражают входные операции, которые координируют aggregate, repositories и другие Domain contracts. Это application business logic, но оно остаётся частью `domain`, поскольку его правила и инварианты не зависят от UI или Infrastructure.

Concrete Double Elimination, Single Elimination и Round Robin implementations находятся за `TournamentFormatPort` и не входят в этот слой.
