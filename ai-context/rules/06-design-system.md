# Design-system enforcement

## Trigger

Изменение screen/component/theme/token, layout, typography, color, shape, motion, artwork composition или Flutter/Web visual parity.

## Обязательно

- Использовать design tokens по stable path из manifest, а не копировать raw values.
- Следовать component/layout semantics из design canon.
- Изменение token semantics/value/version документировать как серьёзное design decision.

## Запрещено

- Дублировать token values или breakpoint numbers в rule/code comments.
- Добавлять magic visual values без documented exception.
- Создавать новый token только в одной платформе.

## Канон

- [Design system](../../docs/design/README.md)
- [Design tokens contract](../../docs/design/tokens.md)
- [Design tokens manifest](../../docs/design/tokens.json)

## Evidence

Использованные token paths, manifest validation и visual/adaptive evidence затронутых компонентов.
