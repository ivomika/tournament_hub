# Задача 16. Добавить в Domain architecture checker фактическую карту файлов и declarations

## Статус

✅ Выполнена

## Цель

Дополнить логическую Domain-карту проверяемыми фактами об исходниках: показать, в каких Dart-файлах находятся архитектурные объекты, какие declarations объявлены в каждом файле и где расположены enum.

## Контекст и границы

- Входит: формат `domain-architecture.json`, viewer, валидатор source facts, документация и task metadata.
- Логические nodes и edges сохраняются; source facts добавляются отдельным слоем и не подменяют архитектурную модель.
- В inventory входят файлы `apps/tournament_app/lib/domain`; barrel `domain.dart` фиксируется отдельно и не приписывается одному логическому node.
- Domain-код и публичные contracts не изменяются.
- Задача продолжает принятые визуальные решения задачи 15.

## Применимые правила

### Обязательные правила

- [x] [R-001 · SOLID](../rules/core/001-solid.md) — логическая архитектура, source facts и их валидация разделены: viewer читает данные, а отдельный validator проверяет их против файловой системы.
- [x] [R-002 · Документирование на русском](../rules/core/002-documentation-russian.md) — новый schema contract, правила сопровождения и ограничения фиксируются в `docs/development/domain-check.md`.

### Conditional rules

- Scan выполнен: conditional rules отсутствуют; задача не меняет Flutter UI, Domain contracts, persistence или transport.

## Декомпозиция

- [x] Добавить структурированный generated-слой `files` с path, nodeId и declarations.
- [x] Показать file path и количество files/enum на карточках.
- [x] Добавить source facts и отдельное отображение enum в detail panel.
- [x] Включить path, declaration name и kind в поиск, добавить фильтр по наличию enum.
- [x] Добавить валидатор соответствия JSON фактическим Dart-файлам и declarations.
- [x] Документировать schema и порядок сопровождения.

## Критерии готовности

- [x] Каждый логический node связан хотя бы с одним существующим Dart-файлом.
- [x] Каждый declaration из inventory существует в указанном файле и на указанной строке.
- [x] Пользователь видит путь файла и enum без чтения свободного `members`.
- [x] Поиск находит node по path, declaration name и kind; enum можно отфильтровать.
- [x] Логические edges, drag-to-pan, внутренний scroll и принятые визуальные различия связей сохранены.

## Открытые вопросы и блокеры

- Нет.

## Ключевые решения

- `nodes` описывают архитектурный смысл, `files` — проверяемые факты исходников.
- Declaration хранит `name`, `kind` и `line`; kind не выводится эвристикой в browser UI.
- Drift предотвращается отдельным Node.js validator без запуска Flutter build.
- Факты вынесены в generated `domain-source-facts.json`, а явное сопоставление path с node хранится в `domain-architecture.json` schema v2.
- Barrel `domain/domain.dart` учитывается отдельно и не искажает принадлежность логических nodes.

## Проверки

- `node tools/domain-check/source-facts.mjs --check` — 67 файлов и 87 declarations соответствуют исходникам.
- Проверены 45 nodes: каждый имеет хотя бы один source file.
- Проверены 6 enum: `StatisticType`, `MatchState`, `ParticipantStatus`, `ParticipantType`, `TechnicalResultReason`, `TournamentLifecycle`.
- `node --check tools/domain-check/app.js` и `node --check tools/domain-check/source-facts.mjs` — успешно.
- HTTP smoke для `/`, `/app.js`, `/styles.css`, `/domain-architecture.json`, `/domain-source-facts.json` — все ресурсы отвечают `200`.
- Static UI assertions подтвердили source metrics, enum filter, source search и detail markup.
- `git diff --check` — успешно; предупреждения относятся только к LF/CRLF.
- Встроенный browser для визуального smoke test в среде агента недоступен; интерактивная проверка остаётся ограничением handoff.

## Итог

Подход реализован и технически проверен, но отклонён пользователем после просмотра: file-centric details и сохранение ручных сгруппированных nodes не дают требуемого представления Domain. Реализация заменяется задачей 17 и не должна оставаться в итоговом viewer.
