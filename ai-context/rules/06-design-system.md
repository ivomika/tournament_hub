# Design-system enforcement

## Trigger

Изменение screen/component/theme/token, layout, typography, color, shape, motion, artwork composition или Flutter/Web visual parity.

## Обязательно

- Размещать Flutter tokens, theme composition и UI components только в `presentation/design_system` по установленным boundaries.
- Каждый visual component держать в отдельной папке с собственным typed theme contract; runtime widget читает значения из theme, а не из generated tokens.
- Screens строить только из публичного design-system API; direct visual Material primitives, private tokens и component themes в screens запрещены architecture check.
- Использовать generated tokens по stable path manifest только при сборке общей темы.
- Изменение token semantics/value/version документировать как серьёзное design decision.

## Запрещено

- Использовать raw colors, hex, magic dimensions/durations/typography или `Colors.*` вне generated token output.
- Импортировать generated tokens из component/screen/widgetbook use-case.
- Создавать catch-all component files или component без собственной папки/theme.
- Создавать новый token только в одной платформе.

## Канон

- [Design system](../../docs/design/README.md)
- [Design tokens contract](../../docs/design/tokens.md)
- [Design tokens manifest](../../docs/design/tokens.json)

## Evidence

Успешный design-system architecture check, manifest/generator check, component theme tests и visual/adaptive evidence.
