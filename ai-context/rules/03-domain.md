# Domain enforcement

## Trigger

Изменение tournament lifecycle, participants, assignment, formats, matches, results, scoring, tie-break, withdrawal, correction, ranking или champion.

## Обязательно

- Найти точное domain requirement в каноне и назвать owner object/engine/policy.
- Реализовать правило на нижнем Domain boundary через versioned contract.
- Добавить unit/property/invariant evidence.

## Запрещено

- Копировать domain rule в widget, provider, transport или React.
- Изменять semantics через migration/UI workaround.
- Реализовывать вопрос, остающийся open decision.

## Канон

- [Tournament rules](../../docs/domain/tournament-rules.md)
- [Product guide](../../docs/product/README.md)

## Evidence

Ссылка на requirement/open decision, Domain tests и подтверждение отсутствия дублированной business logic.
