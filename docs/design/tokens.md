# Design tokens contract

## Source of truth

[`tokens.json`](tokens.json) — единственный владелец token paths, raw values и units. Prose documentation, rules, Flutter и Web не копируют эти значения как независимый baseline.

## Groups

- `space.*` — spacing scale.
- `breakpoint.*` — inclusive responsive boundaries.
- `layout.*` — page padding, content-width limits и минимальные размеры структурных колонок.
- `color.*` — semantic background/surface/text/accent/status colors.
- `font.size.*`, `font.lineHeight.*`, `font.weight.*` — typography primitives.
- `radius.*`, `border.*` — shape primitives; border scale различает обычную границу и emphasis для крупных/дистанционно читаемых связей.
- `control.*` — targets и control heights.
- `artwork.size.*` — semantic fighter-artwork hierarchy для compact, standard, matchup и hero representations.
- `motion.*` — duration primitives.

Путь является public design contract. Consumers используют путь, а не raw value.

## Versioning

- `schemaVersion` меняется при несовместимом формате manifest/parser.
- `manifestVersion` использует SemVer.
- Removal/rename/type/semantic change token path — major.
- Additive token group/path или согласованная value change — minor.
- Description/source metadata correction без consumer effect — patch.

Изменение manifest — серьёзное design decision: task card, rationale/consequences, design docs и при смене token source/model ADR обязательны.

## Platform consumption

Generator создаёт Flutter primitives в `presentation/design_system/tokens/tokens.g.dart`; generated bindings не редактируются вручную. Только общая theme composition читает primitives и преобразует их в typed component themes. Отдельные platform values и direct token access из widgets/screens запрещены.

## Exceptions

Artwork crop/math/platform-required literal допускается только с task ID, причиной, локальным scope и доказательством, что он не является reusable token. Повторное значение требует token proposal.

## Validation

- JSON parse и required metadata/groups.
- Unique path, supported `type`, numeric units и color syntax.
- Breakpoint continuity/non-overlap.
- Spacing/motion values monotonic там, где scale упорядочена.
- Contrast проверяется для фактических foreground/background semantic pairs.
- Rules/prose не дублируют raw baseline values.
