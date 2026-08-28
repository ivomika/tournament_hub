# ADR-0003: Theme-driven границы Flutter design system

- Статус: Accepted
- Дата: 2026-08-27
- Владельцы: Tournament Hub project
- Связанная задача: `TH-20260827-046`

## Контекст

Первая версия Widgetbook разместила generated tokens вне `presentation`, объединила компоненты и screens в крупные файлы и позволила widgets напрямую читать primitive tokens. Такая структура не гарантирует единообразие, не отделяет component semantics от primitives и позволяет screen обходить design system.

## Решение

Вся Flutter design system живёт в `lib/presentation/design_system`:

```text
design_system/
  tokens/                  # generated primitives; private для runtime widgets
  theme/                   # единственное место mapping primitives -> themes
  components/
    <component>/
      <component>.dart
      <component>_theme.dart
  design_system.dart       # публичный barrel без primitive/theme internals
```

Каждый visual component читает только собственный typed `ThemeExtension` через `Theme.of(context)`. Только common theme composition импортирует generated tokens и создаёт component themes. Screen files находятся отдельно по одному screen на файл и компонуют публичные DS components; они не создают Material visual controls/surfaces/text напрямую.

Source-level architecture check является обязательным fitness function и запускается из `make check`. Он запрещает raw colors, direct token imports, component без theme/папки и Material visual primitives в screens.

## Альтернативы

- Прямое использование semantic constants компонентами: проще, но не даёт component-level theming и позволяет обходить общую тему.
- Один глобальный `ThemeExtension`: меньше файлов, но превращается в неограниченный catch-all и связывает все components.
- Только review checklist: отклонён, потому что нарушение должно останавливать tests автоматически.

## Последствия

- Файлов и typed theme contracts становится больше; ownership каждого visual решения однозначен.
- Изменение component визуала проходит через его theme и common theme composition.
- Screens становятся декларативными composition roots presentation fixtures.
- Новый component без folder/theme или новый raw value ломает `make check`.

## Migration и rollback

Существующие tokens/theme/components/screens задачи `045` переносятся без изменения продуктового behavior. Rollback возможен только новым ADR; отключение architecture check без замены fitness function запрещено.

## Проверка

- Positive scan production sources.
- Negative fixtures на каждую запрещённую зависимость/конструкцию.
- Analyzer и adaptive widget tests для всех screen compositions.
