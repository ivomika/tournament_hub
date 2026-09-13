# Задача 20. Добавить горячие клавиши масштаба и фокуса связей в Domain viewer

## Статус

✅ Выполнена

## Цель

Позволить управлять масштабом карты и режимом фокуса связей с клавиатуры без потери существующего поведения controls.

## Контекст и границы

- `+` и `NumpadAdd` увеличивают масштаб на существующий шаг `10%`.
- `−` и `NumpadSubtract` уменьшают масштаб на `10%`.
- `0` и `Numpad0` возвращают масштаб `100%`.
- Физическая клавиша `F` включает и выключает relationship focus независимо от активной раскладки.
- Shortcuts не обрабатываются при вводе в `input`, `select`, `textarea` или `contenteditable` и не перехватывают сочетания с `Ctrl`, `Meta` или `Alt`. Сфокусированные карточки и обычные buttons не блокируют shortcuts.
- Generated schema, graph layout и Domain-код не меняются.

## Применимые правила

### Обязательные правила

- [x] [R-001 · SOLID](../rules/core/001-solid.md) — keyboard handler вызывает существующие операции zoom/focus, не дублируя изменение state.
- [x] [R-002 · Документирование на русском](../rules/core/002-documentation-russian.md) — пользовательские shortcuts фиксируются в `docs/development/domain-check.md` и рядом с controls.

### Conditional rules

- Scan выполнен: conditional rules отсутствуют; Flutter UI и проектная дизайн-система не меняются.

## Декомпозиция

- [x] Выделить единый toggle relationship focus для мыши и клавиатуры.
- [x] Добавить глобальный keyboard handler с защитой form controls и browser shortcuts.
- [x] Добавить `aria-keyshortcuts`, `title` и видимые подсказки клавиш.
- [x] Обновить документацию и проверки.

## Критерии готовности

- [x] `+`, `−` и `0` управляют масштабом карты.
- [x] Shortcuts работают по физическим клавишам при русской и английской раскладке.
- [x] `F` переключает фокус связей тем же способом, что кнопка.
- [x] Ввод в поиск и взаимодействие с range/select не запускают shortcuts; после выбора карточки shortcuts остаются доступны.
- [x] `Ctrl`/`Meta`/`Alt` combinations остаются браузеру и операционной системе.
- [x] Controls сообщают shortcuts визуально и через accessibility attributes.

## Открытые вопросы и блокеры

- Нет.

## Ключевые решения

- Shortcuts сопоставляются по `KeyboardEvent.code`: `Equal`/`NumpadAdd`, `Minus`/`NumpadSubtract`, `Digit0`/`Numpad0`, `KeyF`. Это сохраняет физические клавиши при смене раскладки.
- Обычная клавиша `=` также увеличивает масштаб: она находится на той же физической клавише, что `+`, и не требует `Shift`.
- Zoom shortcuts вызывают существующий `setManualGraphScale`, поэтому сохраняют пределы, центр viewport и persistence.
- Mouse click и `F` используют общий `toggleRelationshipFocus`/`setRelationshipFocus`; reset вызывает тот же setter без промежуточного render.
- Form fields и editable content блокируют shortcuts, но карточки-buttons не блокируют: после выбора declaration управление остаётся доступным.
- Modifier combinations не обрабатываются, чтобы не конфликтовать с browser/OS shortcuts.

## Проверки

- `node --check tools/domain-check/app.js` — успешно.
- `make domain-check-validate` — 87 Domain objects и 167 references, generated schema не изменилась.
- Static assertions подтвердили все восемь keyboard codes, modifier guard, input guard и общий focus toggle.
- Проверено, что selector editable targets не содержит `button` и карточка не отключает shortcuts.
- В HTML присутствуют четыре `aria-keyshortcuts`, видимые `kbd` hints и соответствующие `title`.
- HTTP smoke `/`, `/app.js`, `/styles.css` — ответы `200`; served HTML содержит все shortcut attributes.
- `git diff --check` — успешно; предупреждения относятся только к LF/CRLF.
- Browser backend недоступен по результату проверки в задаче 19; интерактивная визуальная приёмка остаётся за пользователем.

## Итог

Domain viewer поддерживает управление масштабом через `+`/`−`/`0` и переключение relationship focus через `F`. Shortcuts не зависят от раскладки, используют существующие операции controls, не вмешиваются во ввод и системные combinations и обозначены непосредственно в UI.
