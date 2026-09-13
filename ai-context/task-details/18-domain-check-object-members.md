# Задача 18. Вернуть в карточки Domain viewer описание, поля и методы из Dart-кода

## Статус

✅ Выполнена

## Цель

Сохранить точную объектную карту Domain из задачи 17, но вернуть каждой карточке минимально достаточный контекст: описание, объявленные поля и методы конкретного Dart-объекта.

## Контекст и границы

- Один node по-прежнему соответствует одному реальному Dart declaration с точным именем.
- Поля, getters, constructors и методы извлекаются из тела declaration генератором; ручные списки не поддерживаются.
- Описание берётся из непосредственно предшествующего Dart doc comment `///`.
- Если doc comment отсутствует, generator создаёт нейтральное описание только из kind и фактического количества членов, без предположений о бизнес-назначении.
- В карточке показывается компактная выборка членов с числом скрытых элементов; полный состав доступен в панели деталей.
- File paths, synthetic groups и ручные архитектурные summaries не возвращаются.
- Domain-код не изменяется.

## Применимые правила

### Обязательные правила

- [x] [R-001 · SOLID](../rules/core/001-solid.md) — extraction остаётся ответственностью генератора, viewer отображает generated contract.
- [x] [R-002 · Документирование на русском](../rules/core/002-documentation-russian.md) — schema и ограничения extraction документируются в `docs/development/domain-check.md`.

### Conditional rules

- Scan выполнен: conditional rules отсутствуют; Flutter UI, Domain contracts, persistence и transport не меняются.

## Декомпозиция

- [x] Извлечь doc comments и top-level members каждого declaration.
- [x] Разделить члены на поля и методы, включая constructors и getters.
- [x] Показать описание и компактный состав непосредственно в карточке.
- [x] Показать полные списки полей и методов в панели деталей.
- [x] Обновить generated schema, поиск, документацию и проверки drift.

## Критерии готовности

- [x] Карточка `Tournament` показывает описание и фактическую выборку его полей и методов.
- [x] Карточка `TournamentLifecyclePort` показывает объявленные методы интерфейса.
- [x] Enum сохраняет фактические значения и получает описание.
- [x] Полные списки доступны в detail panel и участвуют в поиске.
- [x] В данных и UI нет file paths, synthetic groups и вручную придуманных назначений объектов.

## Открытые вопросы и блокеры

- В текущем Domain почти нет Dart doc comments; поэтому до появления `///` описания будут намеренно нейтральными.

## Ключевые решения

- Schema v4 хранит `description`, `fields`, `methods` и существующие enum `members` отдельно.
- Member parser рассматривает только top-level содержимое тела declaration и пропускает реализации методов, поэтому локальные переменные и вызовы не попадают в состав объекта.
- Constructors и getters входят в полный список методов; в компактной карточке при наличии выбора приоритет получает публичный метод поведения, а не constructor, getter или private helper.
- Карточка показывает не более одного representative field, одного representative method и счётчик остальных; это сохраняет читаемый размер node.
- Semantic description появляется только из `///`. Сейчас doc comments в Domain отсутствуют, поэтому fallback сообщает kind и точные counts, не приписывая объекту придуманную роль.

## Проверки

- `node tools/domain-check/domain-structure.mjs` — generated schema v4: 87 objects, 167 references.
- `make domain-check-validate` — generated inventory актуален.
- Полный inventory содержит 153 поля, 207 методов/конструкторов и 23 enum values.
- Проверены `Tournament` (16 полей, 22 метода), `TournamentLifecyclePort` (6 методов) и `TournamentLifecycle` (6 значений).
- Проверка подозрительных фрагментов подтвердила отсутствие `return`, `throw`, control-flow и method body в извлечённых членах; две сигнатуры длиннее 400 символов являются фактическими constructors и обрезаются только визуально в карточках.
- `node --check tools/domain-check/domain-structure.mjs` и `node --check tools/domain-check/app.js` — успешно.
- HTTP smoke `/`, `/app.js`, `/styles.css`, `/domain-architecture.json` — ответы `200`.
- Проверено отсутствие `.dart` paths и synthetic `variants` в generated data.
- `git diff --check` — успешно; сообщения относятся только к LF/CRLF.
- Интерактивный browser в среде агента недоступен; визуальная проверка остаётся ограничением handoff.

## Итог

Domain viewer переведён на schema v4. Карточки конкретных Dart-объектов снова объясняют минимальный контекст и показывают фактические поля, методы или enum values; detail panel раскрывает полный состав, а поиск учитывает все новые данные. Источником структуры остаётся Domain-код, ручные группы, file paths и придуманные summaries не возвращены.
