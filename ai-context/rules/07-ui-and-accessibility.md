# UI and accessibility enforcement

## Trigger

Изменение пользовательского screen/navigation, interaction, async/network state, text/artwork, focus/keyboard, animation или adaptive composition.

## Обязательно

- Сверить переходы и guards с screen map.
- Покрыть применимые presentation states и accessibility constraints из design canon.
- Проверить затронутые width classes и способы ввода.

## Запрещено

- Использовать navigation как скрытый Domain transition.
- Делать color/hover/motion/artwork единственным носителем информации.
- Показывать internal exception/stack trace пользователю.

## Канон

- [Screen map](../../docs/product/screen-map.md)
- [Design system](../../docs/design/README.md)

## Evidence

Widget/component/golden/manual checks для states, routes/guards, widths, semantics, keyboard/focus и reduced motion.
