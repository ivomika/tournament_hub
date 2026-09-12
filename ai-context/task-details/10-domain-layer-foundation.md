# Задача 10. Добавить Domain layer TournamentHUB

## Статус

✅ Выполнена

## Цель

Добавить в Flutter-приложение framework-free `lib/domain`, который реализует спроектированные Domain-области и содержит как предметные правила, так и application business logic contracts.

## Контекст и границы

- Входит: области `tournament`, `tournament_format`, `character_assignment`, `profile`, `game`, `statistics` и `history`; typed value objects, entities/models, failures, ports, repositories и public exports.
- Входит: базовые инварианты модели, которые можно выразить без конкретных форматов и Infrastructure.
- Не входит: конкретные реализации Double Elimination, Single Elimination и Round Robin; persistence, serialization, WebSocket, Flutter UI, DI и app routing.
- Источник проектирования: `/Users/akimoviv/Documents/Obsidian Vault/Projects/TournamentHUB/domain`.

## Применимые правила

### Обязательные правила

- [x] [R-001 · SOLID](../rules/core/001-solid.md) — каждая Domain-область владеет только своими entities/models, value objects, ports, repositories и failures; infrastructure details исключены из `lib/domain`.
- [x] [R-002 · Документирование на русском](../rules/core/002-documentation-russian.md) — границы Domain layer и её отличие от app, presentation и infrastructure фиксируются в `docs/architecture/domain-layer.md`.

### Conditional rules

- Scan выполнен: conditional rules пока отсутствуют.

## Декомпозиция

- [x] Сопоставить спроектированные Obsidian-области с Flutter Domain layer.
- [x] Создать структуру и public export `lib/domain`.
- [x] Реализовать typed value objects, entities/models и failures областей.
- [x] Реализовать Domain ports и repositories без concrete Infrastructure.
- [x] Добавить тесты ключевых инвариантов и проверить отсутствие Flutter imports.
- [x] Обновить документацию и завершить задачу.

## Критерии готовности

- [x] `lib/domain` содержит все семь спроектированных областей и не импортирует Flutter или platform APIs.
- [x] `Tournament` остаётся aggregate root, но format progression и distribution делегированы ports.
- [x] Domain ports выражают application business logic без отдельного top-level application/usecase слоя.
- [x] Concrete format implementations и Infrastructure отсутствуют в Domain.
- [x] Ключевые инварианты проверены unit-тестами, `flutter analyze` и `flutter test` проходят.
- [x] Архитектурные границы Domain зафиксированы в `docs/`.

## Открытые вопросы и блокеры

- Полный набор StatisticType и правила влияния TechnicalMatchResult на статистику остаются открытыми: слой фиксирует типы и contracts, но не выдумывает эти правила.
- Конкретная структура TournamentFormatSettings принадлежит внешним implementations TournamentFormatPort и не будет добавлена в Domain.

## Ключевые решения

- `domain` включает Domain Business Logic и Application Business Logic. Ports являются входными business contracts; отдельный слой `application` и классы `*UseCase` не создаются.
- Поддерживается только framework-free Dart: Domain не импортирует Flutter, Riverpod, persistence, JSON, WebSocket, HTTP или platform API.
- Concrete tournament formats остаются за `TournamentFormatPort`; Domain хранит только key, settings и immutable format state contract.

## Проверки

- Проектные Obsidian-документы Domain прочитаны и сопоставлены с областью реализации.
- `make analyze` — успешно, Flutter analyzer не нашёл замечаний.
- `flutter test` — успешно, 5 тестов прошли.
- Проверка семи Domain-областей — успешно.
- Поиск Flutter, Riverpod, persistence, transport и platform imports в `lib/domain` — совпадений нет.
- Поиск concrete Double Elimination, Single Elimination и Round Robin implementations в `lib/domain` — совпадений нет.
- `git diff --check` — успешно.

## Итог

Добавлен framework-free `lib/domain` с семью предметными областями, typed identity, aggregate Tournament, результатами матчей, статистикой, history snapshots и Domain contracts. Application Business Logic выражена Domain ports; Infrastructure и concrete tournament formats намеренно не добавлялись.
