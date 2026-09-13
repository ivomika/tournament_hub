# Задача 21. Вернуть размеры карточек по структурной важности Domain-объектов

## Статус

✅ Выполнена

## Цель

Вернуть три визуальных размера карточек Domain viewer и определять их структурную важность воспроизводимо из Dart-кода, без ручного ранжирования объектов в UI.

## Контекст и границы

- Восстанавливается принятая в задаче 15 иерархия `prominent` / `standard` / `compact`.
- Generator извлекает `role` из фактического каталога declaration: `entities`, `models`, `ports`, `repositories`, `value_objects`, `failures`.
- `prominent` получает корневая entity, имя которой совпадает с PascalCase-именем Domain area: `Tournament`, `Profile`, `Game`.
- `compact` получают value objects, failures и enums.
- Остальные declarations получают `standard`.
- Viewer использует generated `importance`; ручные списки и оценка связности во время отображения не применяются.
- File paths не возвращаются в UI; Domain-код и семантика edges не меняются.

## Применимые правила

### Обязательные правила

- [x] [R-001 · SOLID](../rules/core/001-solid.md) — generator отвечает за классификацию, viewer только применяет готовый визуальный tier.
- [x] [R-002 · Документирование на русском](../rules/core/002-documentation-russian.md) — критерии role/importance и последствия для layout фиксируются в `docs/development/domain-check.md`.

### Conditional rules

- Scan выполнен: conditional rules отсутствуют; Flutter UI и проектная дизайн-система не меняются.

## Декомпозиция

- [x] Добавить в generated schema фактический `role` и вычисленный `importance`.
- [x] Перевести `nodeTier` на generated importance.
- [x] Вернуть full-width prominent cards и компактные value objects/failures/enums.
- [x] Сделать role/importance доступными поиску и detail panel.
- [x] Обновить schema, документацию и проверки drift.

## Критерии готовности

- [x] `Tournament`, `Profile`, `Game` имеют `prominent` и занимают полную внутреннюю ширину cluster.
- [x] Value objects, failures и enums имеют `compact`.
- [x] Entities/models/ports/repositories без root-match имеют `standard`.
- [x] Каждый node содержит generated `role` и `importance`.
- [x] Viewer не содержит ручного списка важных declarations и не показывает file paths.
- [x] Zoom, fit, pan, focus и layout продолжают работать со смешанными размерами.

## Открытые вопросы и блокеры

- Нет.

## Ключевые решения

- Schema v5 добавляет каждому node поля `role` и `importance`.
- `role` извлекается из каталога declaration и не отображает file path в UI.
- Root entity определяется общей формулой `declarationName == PascalCase(areaName)` при `role == entity`; ручного списка `Tournament`/`Profile`/`Game` в generator или viewer нет.
- `prominent` применяется к root entity, `compact` — к value objects/failures/enums, `standard` — ко всем остальным declarations.
- `nodeTier` больше не классифицирует объект самостоятельно и возвращает generated `importance`.
- Prominent node занимает обе колонки cluster; standard/compact сохраняют одну колонку и используют разные фиксированные высоты.

## Проверки

- `node tools/domain-check/domain-structure.mjs` — generated schema v5: 87 objects, 167 references.
- `make domain-check-validate` — generated inventory актуален.
- Получено 3 prominent, 29 standard и 55 compact nodes.
- Prominent inventory строго равен `Game`, `Profile`, `Tournament`.
- Roles: 10 entities, 3 models, 11 ports, 8 repository declarations, 37 value objects, 18 failure declarations.
- Проверено наличие `role`/`importance` у всех 87 nodes и отсутствие `.dart` paths в JSON.
- Static assertions подтвердили `node.importance`, full-width span prominent и CSS всех трёх tiers.
- `node --check` для generator и viewer — успешно.
- HTTP smoke четырёх ресурсов — ответы `200`; served schema имеет version 5 и три prominent nodes.
- `git diff --check` — успешно; предупреждения относятся только к LF/CRLF.
- Browser backend недоступен по результату задачи 19; визуальная приёмка смешанных размеров остаётся за пользователем.

## Итог

Domain viewer снова использует три размера карточек. Важность генерируется воспроизводимо из фактической роли declaration и соответствия имени корневой entity имени Domain area; viewer не содержит ручной классификации. Крупные root entities формируют визуальные опорные точки, value objects/failures/enums остаются компактными, остальные контракты и модели имеют стандартный размер.
