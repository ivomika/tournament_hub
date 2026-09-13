# Задача 17. Перестроить Domain viewer на карту реальных Dart-объектов

## Статус

✅ Выполнена

## Цель

Показывать Domain таким, как он объявлен в коде: один node на каждый class, interface, sealed/abstract class и enum с точным именем, без придуманных групп вроде `Statistic variants` и без file paths в UI.

## Контекст и границы

- Задача заменяет rejected-представление source files из задачи 16.
- Структура генерируется из `apps/tournament_app/lib/domain`, а не группируется вручную исполнителем.
- Domain areas соответствуют фактическим верхнеуровневым каталогам внутри `domain`.
- Edges означают фактическое упоминание одного объявленного Domain-типа внутри объявления другого; `extends` и `implements` сохраняются как синтаксические факты.
- File paths, дерево каталогов, придуманные summaries и ручные группы в UI не входят.
- Domain-код не изменяется.

## Применимые правила

### Обязательные правила

- [x] [R-001 · SOLID](../rules/core/001-solid.md) — генератор отвечает за извлечение структуры, viewer только отображает generated schema; ручная интерпретация объектов удаляется.
- [x] [R-002 · Документирование на русском](../rules/core/002-documentation-russian.md) — generated schema, смысл edges и ограничения parser фиксируются в `docs/development/domain-check.md`.

### Conditional rules

- Scan выполнен: conditional rules отсутствуют; Flutter UI, Domain contracts, persistence и transport не меняются.

## Декомпозиция

- [x] Генерировать отдельный node для каждого Domain declaration.
- [x] Генерировать area из фактического Domain module и edges из type references.
- [x] Показывать точное имя, declaration kind, signature и значения enum.
- [x] Удалить file paths, source grouping и ручные архитектурные nodes из UI/data.
- [x] Сохранить кластерную карту, пунктир межкластерных связей, раздельные порты, фокус, scroll и drag-to-pan.
- [x] Добавить repeatable generate/check команды и документацию.

## Критерии готовности

- [x] `ProfileStatistic`, `ParticipantTournamentStatistic` и `TournamentStatistic` отображаются отдельными nodes; `Statistic variants` отсутствует.
- [x] Каждый declaration из Domain-кода представлен ровно один раз под точным именем.
- [x] Все enum представлены отдельными nodes с фактическими значениями.
- [x] Viewer не показывает file paths и не использует ручные source mappings.
- [x] Generated inventory воспроизводим и проверяется на drift.

## Открытые вопросы и блокеры

- Нет.

## Ключевые решения

- Идентичность node — точное имя Dart declaration.
- Declaration kind берётся из синтаксических modifiers, area — из физической границы Domain module.
- Generator удаляет comments и string literals перед поиском type references, чтобы не создавать связи из текста.
- Лексическая reference означает точное упоминание identifier, но не интерпретируется как runtime call, ownership или иной придуманный тип связи.
- Уникальность имён declarations обязательна; неоднозначность завершает генерацию ошибкой.

## Проверки

- `make domain-check-validate` — подтверждены 87 Domain objects и 167 code references.
- Проверены отдельные nodes `ProfileStatistic`, `ParticipantTournamentStatistic`, `TournamentStatistic`; synthetic `Statistic variants` отсутствует.
- Проверены 6 enum nodes и наличие фактических значений у каждого.
- Проверено отсутствие `.dart` paths и source mappings в generated viewer data.
- `node --check` для `app.js` и `domain-structure.mjs` — успешно.
- Static assertions подтвердили сохранение drag-to-pan, `is-inter-cluster` и раздельных edge ports.
- HTTP smoke для `/`, `/app.js`, `/styles.css`, `/domain-architecture.json` — все ресурсы отвечают `200`.
- `git diff --check` — успешно; предупреждения относятся только к LF/CRLF.
- Встроенный browser в среде агента недоступен, поэтому визуальная интерактивная проверка остаётся ограничением handoff.

## Итог

Domain viewer переведён на generated schema v3: 87 реальных Dart declarations отображаются отдельными nodes с точными именами и синтаксическими kinds, 6 enum показывают свои значения, 167 edges отражают фактические type references. Ручные группы, summaries, source mappings и file paths удалены. Принятые навигационные и визуальные возможности viewer сохранены; Domain-код не изменён.
