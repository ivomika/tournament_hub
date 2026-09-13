# Задача 22. Упростить содержимое карточек Domain viewer и уменьшить compact-tier

## Статус

✅ Выполнена

## Цель

Убрать из обзорных карточек поля и методы, оставив только тип declaration, точное имя и краткое описание, а полный API показывать исключительно в панели Details.

## Контекст и границы

- Изменяются карточки на интерактивной карте и в inventory.
- Generated schema продолжает хранить enum values, поля и методы как факты о Domain-коде.
- Поиск может учитывать полный API, даже если он не отображается в карточке.
- Панель Details сохраняет полные списки enum values, полей, методов и связей.
- Визуальные tiers сохраняются, но их высота уменьшается до `176px` / `142px` / `118px` для `prominent` / `standard` / `compact`.
- Domain-код, generator и семантика связей не меняются.

## Применимые правила

### Обязательные правила

- [x] [R-001 · SOLID](../rules/core/001-solid.md) — обзорное представление и подробное представление используют один набор данных, но имеют разную ответственность.
- [x] [R-002 · Документирование на русском](../rules/core/002-documentation-russian.md) — принятое разделение обзорной карточки и Details фиксируется в проектной документации.

### Conditional rules

- Scan выполнен: conditional rules отсутствуют; Flutter UI и проектная дизайн-система не меняются.

## Декомпозиция

- [x] Удалить preview полей, методов и enum values из graph cards.
- [x] Удалить preview полей, методов и enum values из inventory cards.
- [x] Сохранить полный API declaration в Details и поисковом индексе.
- [x] Уменьшить все три tier, особенно compact-карточки.
- [x] Обновить документацию и выполнить статические проверки viewer.

## Критерии готовности

- [x] Каждая обзорная карточка показывает только тип, имя и описание.
- [x] Поля, методы и enum values отображаются только в Details выбранного declaration.
- [x] Поиск по членам declaration продолжает работать.
- [x] Высоты graph cards равны `176px`, `142px`, `118px` по tiers.
- [x] Inventory cards не резервируют место под member preview.
- [x] Zoom, fit, pan, focus, selection и layout сохраняют работоспособность.

## Открытые вопросы и блокеры

- Нет.

## Changelog

### Итерация 1

**Prompt пользователя**

> так и давай все таки не будем мне глаза травить из карточек уберем методы и поля и они будут жить только в деталях. Карточка показыввает только тип, название и описание. А компактные карточки сделаем еще меньше

**Изменения**

- Удалены preview членов declaration из graph cards и inventory cards.
- Полный API сохранён в Details и поисковом индексе.
- Высоты `prominent` / `standard` / `compact` уменьшены до `176px` / `142px` / `118px`, inventory cards — до `140px`.

**Проверки**

- Проверены JavaScript, generated Domain inventory, отсутствие preview-разметки, сохранность API в Details/поиске и HTTP-раздача viewer.

## Ключевые решения

- Graph card и inventory card используют единый обзорный контракт: kind, точное имя declaration и описание.
- `members`, `fields` и `methods` не удаляются из generated schema: они продолжают участвовать в полнотекстовом поиске и выводятся полными списками в Details.
- Удалены отдельные DOM-контейнеры, CSS-правила и JavaScript helpers для member preview, чтобы скрытая возможность не оставалась вторым способом представления API.
- Высоты tiers уменьшены до `176px` / `142px` / `118px`; inventory card уменьшена до `140px` и ограничивает описание тремя строками.

## Проверки

- `node --check tools/domain-check/app.js` — успешно.
- `node --check tools/domain-check/domain-structure.mjs` — успешно.
- `make domain-check-validate` — 87 Domain objects и 167 code references, drift отсутствует.
- Static assertions подтвердили отсутствие member preview в HTML/JS/CSS, наличие полного API в Details и поиске, новые высоты tiers и `140px` для inventory cards.
- HTTP smoke `index.html`, `app.js`, `styles.css`, `domain-architecture.json` — ответы `200`; served assets содержат новый карточный контракт.
- `git diff --check` — успешно; предупреждения относятся только к LF/CRLF.
- Browser backend ранее зафиксирован как недоступный в задаче 19; визуальная приёмка новых размеров остаётся за пользователем.

## Итог

Карточки Domain viewer больше не смешивают архитектурный обзор с API declaration: карта и inventory показывают только тип, имя и описание, а поля, методы, конструкторы и enum values живут в Details. Карточки всех tiers стали ниже, compact-tier уменьшен до `118px`, а реестр больше не резервирует пустое место под удалённый preview.
