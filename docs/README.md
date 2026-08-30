# Документация Tournament Hub

Этот каталог — рабочий канон проекта. [`source/`](source/) содержит исходные материалы и assets: они используются для аудита, но не редактируются и не подменяют нормализованные документы ниже.

## Как читать документацию

Новый участник команды читает документы в таком порядке:

1. [Product guide](product/README.md) — что строим, для кого и какой lifecycle допустим.
2. [Open decisions](product/open-decisions.md) — что пока нельзя угадывать или фиксировать в коде.
3. [Architecture](architecture/README.md) — границы слоёв, поток команд и зависимости.
4. [Tournament domain](domain/tournament-rules.md) — правила форматов и инварианты.
5. [Data and protocol](data/README.md) — snapshots, транзакции, versioning и realtime.
6. [Design system](design/README.md) — tokens, компоненты, адаптивность и accessibility.
7. [Screen map](product/screen-map.md) — роли, экраны, guards и переходы.
8. [Decision policy](governance/decision-policy.md) — где фиксировать серьёзные решения.
9. [Development](development/README.md) и [testing](testing/README.md) — как менять и проверять проект.
10. [Operations](operations/README.md) — LAN, безопасность, диагностика и релиз.

Краткие обязательные правила перед каждой задачей находятся в [`ai-context/rules`](../ai-context/rules/README.md).

## Карта документов

| Область | Документ | Назначение |
|---|---|---|
| Аудит | [Design Doc audit](audit/design-doc-audit.md) | Покрытие, противоречия, риски и пробелы исходника |
| Продукт | [Product guide](product/README.md) | Scope, роли, lifecycle, permissions, экраны |
| Решения | [Open decisions](product/open-decisions.md) | Вопросы, блокирующие безопасную реализацию |
| Governance | [Decision policy](governance/decision-policy.md) | Обязательные артефакты серьёзных решений |
| Governance | [Rule change log](governance/rule-change-log.md) | Причины, влияние и migration изменений rules |
| Экраны | [Screen map](product/screen-map.md) | Role flows, logical routes, guards и presentation states |
| Архитектура | [Architecture](architecture/README.md) | System context, слои, contracts, ownership |
| Трассировка | [Traceability](architecture/traceability.md) | Requirement → owner → contract → UI → tests |
| ADR | [ADR index](adr/README.md) | Устойчивые архитектурные решения |
| Домен | [Tournament rules](domain/tournament-rules.md) | DE, SE, RR, результаты, correction, withdrawal |
| Domain contract | [Format engine v1](domain/format-engine-v1.md) | Versioned settings, results, ranking и tie-break contract |
| Данные | [Data and protocol](data/README.md) | Persistence, migrations, transactions, realtime |
| Дизайн | [Design system](design/README.md) | Visual language, tokens, layouts, states, a11y |
| Дизайн | [Full-page layout audit](design/full-page-layout-audit.md) | Full-height screen goldens и наблюдения по scroll/layout |
| Design contract | [Tokens manifest](design/tokens.json) · [usage](design/tokens.md) | Единственные значения design tokens и правила потребления |
| Assets | [Fighter assets](assets/fighters.md) | Manifest contract, identity и pipeline |
| Разработка | [Development guide](development/README.md) | Структура, workflow, DoR/DoD, зависимости |
| Тестирование | [Testing strategy](testing/README.md) | Пирамида, обязательные suites, release gates |
| Эксплуатация | [Operations guide](operations/README.md) | Local server, security, logs, backup, release |
| Roadmap | [Implementation plan](roadmap/implementation-plan.md) | Последовательность полного цикла и exit gates |
| Термины | [Glossary](glossary.md) | Однозначный словарь продукта и системы |

## Иерархия авторитетности

При конфликте действует следующий порядок:

1. Явное решение пользователя в текущей задаче.
2. Нормализованные продуктовые и domain-документы этого каталога.
3. Принятые ADR и versioned contracts, когда они появятся.
4. Архитектурная и дизайн-документация.
5. Обязательные правила разработки в `ai-context/rules`.
6. Карточка активной задачи.
7. Материалы `docs/source`.

Новый устойчивый выбор фиксируется по [политике серьёзных решений](governance/decision-policy.md). Неразрешённый вопрос добавляется в open decisions и не закрывается догадкой.

## Definition of documented

Изменение считается документированным, если:

- требование имеет владельца и канонический документ;
- термины совпадают с glossary;
- новый формат данных или protocol имеет версию и migration/compatibility policy;
- UI-поведение связано с domain state, error/empty/loading/stale состояниями;
- архитектурное решение не живёт только в коде или task card;
- все относительные Markdown-ссылки проходят проверку.
