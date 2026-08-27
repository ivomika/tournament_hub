# Аудит Tournament Hub Design Doc

## Паспорт аудита

- Источник: [`docs/source/Tournament_Hub_Design_Doc_RU.md`](../source/Tournament_Hub_Design_Doc_RU.md), версия 1.0 от 26.08.2026.
- Дополнительный источник: [`fighters/manifest.json`](../source/fighters/manifest.json) и 37 PNG assets.
- Метод: проверка внутренней согласованности, реализуемости, тестируемости, безопасности, полноты contracts и соответствия дизайн-токенов заявленным инвариантам.
- Ограничение: это аудит спецификации, а не аудит реализации — в текущей ветке приложение отсутствует.

## Итог

Design Doc задаёт сильный baseline: local-first, Host authoritative, чистый Domain, три изолированных format engine, snapshot persistence, read-only Spectator и конкретную дизайн-систему. Его достаточно для направления разработки, но недостаточно для безошибочной реализации: несколько важных механизмов описаны на уровне намерения, а terminal persistence содержит прямое противоречие.

До начала production-реализации критические пункты `A-001–A-004` должны быть закрыты решением и versioned contract. Остальные пункты допускают параллельную подготовку, но должны быть закрыты до соответствующего вертикального среза.

## Сильные стороны

- Один источник истины и явная permission model.
- Чёткая state machine турнира и terminal immutability.
- Разделение Tournament Domain и MK11 Game Definition.
- Запрет business logic в Riverpod, React и infrastructure.
- Отдельные engines DE/SE/RR вместо condition-heavy controller.
- Snapshot как business truth и event log только как reconnect buffer.
- Полные identity-требования после character assignment.
- Конкретные spacing, typography, color, motion и breakpoint tokens.
- Accessibility не оставлена «на потом».
- MVP exclusions хорошо ограничивают разрастание scope.

## Реестр проблем

| ID | Severity | Область | Наблюдение | Требуемое действие |
|---|---|---|---|---|
| A-001 | Critical, resolved | Terminal persistence | §8.3 запрещает broadcast до commit, но §11.7 ставит публикацию terminal event до удаления active snapshot/log. | Нормализовано в data contract: history insert + active/log delete атомарны, publish только после commit. |
| A-002 | Critical | Protocol | Есть envelope events, но нет request/handshake/error schemas, command idempotency, revision checks, auth/session binding и compatibility matrix. | Создать versioned protocol contract до Participant flow. |
| A-003 | Critical | Result correction | «Пересчитать несыгранную зависимую часть» не определяет rollback topology для DE/SE, invalidated matches/events и spectator correction. | Определить алгоритм invalidation и набор событий отдельно для каждого engine. |
| A-004 | Critical | Security | Spectator заявлен без auth, Participant использует QR/code, но entropy, срок жизни, bind interfaces, origin policy и threat model отсутствуют. | Принять LAN security model и connection URI contract. |
| A-005 | High | Format versioning | Snapshot versioning описан, но версия ruleset/engine не закреплена. Старый history может изменить смысл после обновления engine. | Хранить `formatId` + `rulesetVersion`; registry обязан уметь читать опубликованные версии. |
| A-006 | High | DE ranking | Требуется full ranking, но порядок игроков, выбывших на одной стадии, не определён. | Зафиксировать exact places либо допустимые ranges и tie policy. |
| A-007 | High | FT settings | DE/SE main/final FT названы settings, но допустимые значения, defaults, validation и изменение в Draft не описаны. | Определить typed settings schema и диапазоны. |
| A-008 | High | RR tie-break | Повторный mini RR может не завершиться теоретически и операционно. Нет лимита, resume semantics и UI для вложенных tie groups. | Зафиксировать unbounded domain model и UX; решить нужен ли safety limit/manual resolution. |
| A-009 | High | Match score | DE/SE используют FT, но модель отдельных bouts и допустимый ввод score не определены; result описан только winner/loser. | Решить, хранятся ли bouts/score или только итог серии. |
| A-010 | High | Active tournament | Запрещён второй active tournament, но create при существующем Draft/Open и cancel confirmation не специфицированы. | Описать Main guard и explicit replace/cancel flow. |
| A-011 | High | Local cancellation | Participant может локально сохранить участие как `Cancelled`, что конфликтует с authoritative tournament terminal state. | Ввести отдельный local binding state/reason, не подменяющий Host tournament status. |
| A-012 | High | Event log | Нет retention limit, gap policy, compaction и поведения при недоступном диапазоне replay. | Определить bounded log и fallback на full snapshot. |
| A-013 | High | Time | Не определены UTC, offset, monotonic ordering и реакция на изменение системных часов. | Зафиксировать time contract; ordering не должен зависеть от wall clock. |
| A-014 | High | Platforms | «Flutter mobile/desktop» не перечисляет поддерживаемые OS и release matrix. | Зафиксировать Android/iOS/Windows/macOS scope и минимальные версии. |
| A-015 | Medium | Join UX | Join в Distribution, Running и Finished всегда отвечает «Турнир уже начат», что неточно для Finished. | Ввести lifecycle-specific error codes и локализованные сообщения. |
| A-016 | Medium | Network lifecycle | Не описаны port conflict, несколько interfaces, DHCP/address change, app background и server restart. | Добавить Host server operational state machine. |
| A-017 | Medium | IDs/revision | `uuid` указан, но нет списка stable IDs, aggregate revision, optimistic concurrency и duplicate request behavior. | Ввести typed identifiers, revision и idempotency rules. |
| A-018 | Medium | Privacy | Shared profile и spectator payload перечислены без минимизации полей и redaction rules. | Создать role-specific projection schemas и запретить публикацию local history/settings. |
| A-019 | Medium | Design tokens | Palette проходит заявленный контраст для primary/secondary/tertiary text; `text.disabled` даёт около 2.81:1 на primary surface. Не заданы focus-ring, border и overlay tokens. | Не использовать disabled text для значимой информации; добавить недостающие semantic tokens. |
| A-020 | Medium | Typography | Font family и лицензия не зафиксированы; «один sans-serif» недостаточно для одинакового Flutter/Web результата. | Выбрать bundled/system font policy и fallback stack. |
| A-021 | Medium | Components | Есть принципы, но нет полного component inventory, density variants, validation и screen-state matrix. | Создать component contracts и UI checklist. |
| A-022 | Medium | Assets/IP | Manifest корректен технически, но provenance, лицензия и право распространения MK11 artwork не описаны. | До релиза оформить asset/license review. |
| A-023 | Medium | Observability | Stack traces запрещены в UI, но нет structured logging, redaction, export и diagnostics policy. | Ввести локальную observability policy без секретов/PII. |
| A-024 | Medium | Backup/reset | Account deletion описан, но crash-safe deletion, recovery и очистка server/cache не определены. | Описать атомарный reset и post-condition tests. |
| A-025 | Low | Terminology | Русский и английский смешиваются (`match`, `participant`, `Current`, `Guest`) без канонического словаря. | Использовать glossary и единые identifiers/UI labels. |

## Проверка fighter assets

- Manifest schema version: `1`.
- В manifest: 37 записей; PNG-файлов: 37.
- Missing и unlisted files: отсутствуют.
- Все проверенные PNG имеют размер 512×512.
- Stable ID совпадает с basename asset.
- Поле `asset` указывает runtime-путь `assets/fighters/...`, а не путь внутри `docs/source`; при копировании в приложение необходим детерминированный import/validation script.
- Прозрачность и визуальный crop не проверены автоматически; это отдельный visual QA gate.

## Проверка design tokens

Расчёт WCAG contrast для основных сочетаний с `surface.primary #15191F`:

| Token | Ratio | Вывод |
|---|---:|---|
| `text.primary` | 17+ : 1 | проходит AA/AAA |
| `text.secondary` | 9.62 : 1 | проходит AA/AAA |
| `text.tertiary` | 4.97 : 1 | проходит AA для normal text |
| `text.disabled` | 2.81 : 1 | допустим только для недоступного control, не для значимой информации |
| `accent.primary` | 9.46 : 1 | проходит как foreground на primary surface |
| success/danger/info | 5.40–8.32 : 1 | проходят для текста на primary surface, но пары на собственных containers ещё не заданы |

## Coverage matrix

| Design Doc | Нормализованный владелец |
|---|---|
| §1–4, §20–21 | [Product guide](../product/README.md) |
| §5–6 | [Tournament rules](../domain/tournament-rules.md) |
| §7–9, §16–17, §22–24 | [Architecture](../architecture/README.md) |
| §10–13 | [Data and protocol](../data/README.md) |
| §14–15 | [Operations](../operations/README.md) и data contracts |
| §18–19 | [Design system](../design/README.md) |
| Fighter manifest/assets | [Fighter assets](../assets/fighters.md) |
| Неопределённые решения | [Open decisions](../product/open-decisions.md) |

## Правило использования аудита

Аудит не переопределяет продуктовые правила. Он показывает, где реализация безопасна, где нужен contract, а где требуется решение пользователя/владельца продукта. Закрытие пункта требует ссылки на документ, ADR или versioned schema и тест, подтверждающий решение.
