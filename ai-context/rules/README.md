# Rule router

Rules содержат только исполняемые ограничения. Продуктовые, архитектурные, domain и design facts принадлежат `docs`; rule обязан ссылаться на канон и не повторять его значения или state machines.

## Перед каждой задачей

1. Прочитать этот router.
2. Прочитать пять core rules.
3. Сопоставить scope с conditional triggers.
4. Прочитать каждое сработавшее conditional rule и указать его в карточке.
5. При изменении scope повторить routing до следующего изменения файлов.

## Core rules — всегда применимы

- [00 Task workflow](00-task-workflow.md)
- [01 Authority and decisions](01-authority-and-decisions.md)
- [08 Testing and quality](08-testing-and-quality.md)
- [10 Scope control](10-scope-and-prohibitions.md)
- [11 Git and change safety](11-git-and-safety.md)

Core rule нельзя отметить `Не применимо`. В карточке для каждого core rule указывается ожидаемый, а перед завершением фактический evidence.

## Conditional rules — по trigger

| Rule | Trigger summary |
|---|---|
| [02 Architecture](02-architecture.md) | Structure, layers, dependencies, DI, authority, engines, Host/client boundaries |
| [03 Domain](03-domain.md) | Lifecycle, tournament formats, participants, assignment, results, ranking |
| [04 Data](04-data-and-persistence.md) | Persistence, DTO, transaction, version, schema, migration, history/cache |
| [05 Network/security](05-network-and-security.md) | External payload, LAN/protocol/session, projections, reconnect, logs |
| [06 Design system](06-design-system.md) | Screen/component/theme/token/layout/color/type/motion/artwork |
| [07 UI/accessibility](07-ui-and-accessibility.md) | Navigation, interaction, presentation states, focus/input/adaptive UI |
| [09 Docs/assets](09-docs-and-assets.md) | Serious decision, architecture/rule change, docs/contracts/tokens/assets |

Если trigger совпал хотя бы частично, rule применяется. Сомнение трактуется как trigger: прочитать rule и зафиксировать applicability. Conditional rule без совпадения не добавляется в карточку; вместо семи строк `Не применимо` карточка содержит одну запись о завершённом trigger scan.

## Enforcement

### До `В работе`

- Core evidence заполнен.
- Conditional trigger scan перечисляет затронутые области.
- Все сработавшие rules связаны и влияют на scope/plan/criteria/checks.
- Open decisions/blockers отражены в статусе и границах.

### Перед `Выполнена`

- Core и conditional evidence заменён фактическим.
- Routing повторно сверён с итоговым diff.
- Невыполненное обязательное правило оставляет задачу активной или блокированной.

## Формат rule

Каждый rule содержит только `Trigger`, `Обязательно`, `Запрещено`, `Канон`, `Evidence`. Изменение rule является серьёзным решением и регистрируется по [decision policy](../../docs/governance/decision-policy.md).
