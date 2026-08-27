# ADR-0001: JSON manifest как источник значений design tokens

- Статус: Accepted
- Дата: 2026-08-27
- Владельцы: Tournament Hub project
- Связанная задача: `TH-20260827-043`

## Контекст

Значения spacing, colors, typography, breakpoints, shape и motion были записаны prose-таблицами и частично повторялись в rules. Flutter и React могли получить разные literals, а изменение значения не имело единого versioned artifact.

## Решение

`docs/design/tokens.json` — единственный канонический источник machine-readable token paths и values. `docs/design/README.md` объясняет semantics/usage, но не копирует значения. Rules ссылаются на manifest и запрещают raw-value duplication.

Flutter/Web generators в будущей реализации читают один manifest и создают platform bindings. Ручное расхождение platform token values запрещено.

## Альтернативы

- Только Markdown tables: удобно читать, но нет надёжной генерации/валидации.
- Отдельные Dart/TypeScript sources: создают два источника истины.
- External design-token service: добавляет cloud/tool dependency вне MVP.

## Последствия

- Любой token value имеет stable JSON path и manifest version.
- Изменение token model/value становится серьёзным design decision.
- Prose docs обязаны ссылаться на paths, не повторять числа/hex.
- До появления generators manifest проверяется JSON/structural scripts.

## Migration и rollback

Первый manifest нормализует значения Design Doc без изменения визуальной семантики. Rollback к Markdown-only source запрещён без superseding ADR; технически предыдущая manifest version сохраняется в Git.

## Проверка

- JSON parse и required groups.
- Unique/stable token paths и units.
- Duplicate raw token value scan в rules/design prose.
- Будущие Flutter/Web generated bindings сравниваются с manifest fixtures.
