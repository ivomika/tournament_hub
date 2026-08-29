# ADR-0008: Семантические page-layout presets

- Статус: Accepted
- Дата: 2026-08-29
- Владельцы: Tournament HUB team
- Связанная задача/open decision: [TH-20260829-077](../../ai-context/tasks/TH-20260829-077.md)

## Контекст

`AppShell` задаёт общий canvas, navigation и readable maximum width, но screen-level композиция исторически строилась как одна mobile-колонка либо через универсальный `AdaptiveSplit`. На expanded viewport такой подход не выражает роль dominant object, secondary context и supporting content: широкое полотно остаётся пустым или случайно делится одинаково на экранах с разными задачами.

Нужен устойчивый public presentation contract, который позволит screen называть смысл композиции, не задавая локальные breakpoints, flex ratios, gaps и maximum widths. Контракт не должен знать lifecycle, domain entities, routes или тип устройства.

## Решение

- Flutter design system предоставляет `PageLayout` с typed `PageLayoutPreset`: `focused`, `split`, `workspace`, `archive`, `hero`.
- Screen передаёт semantic regions `primary`, опциональный `secondary` и опциональный полноширинный `supporting`. Визуальные размеры и breakpoint принадлежат `PageLayoutTheme`.
- `primary` всегда предшествует `secondary` и `supporting` в source, focus и semantics order.
- На compact/medium все regions образуют одну вертикальную последовательность. Desktop-only rail не существует в widget tree как отдельная копия content.
- На expanded:
  - `focused` ограничивает readable width и имеет documented terminal/form rationale;
  - `split` создаёт dominant primary и компактный contextual secondary;
  - `workspace` отдаёт dominant рабочей области 60% и secondary context 40%;
  - `archive` отдаёт основную ширину списку/snapshot, secondary используется для filters/metadata;
  - `hero` делает champion/current identity dominant, а ranking/context — secondary.
- `supporting` располагается под основной expanded-композицией и использует её полную ширину.
- Preset не выбирается по lifecycle state внутри компонента: screen явно выбирает его исходя из dominant object.
- Цвета, gaps, breakpoints, maximum width и flex ratios поступают только из typed theme и generated tokens через `TournamentTheme`.
- `AdaptiveSplit` сохраняется для локальных двухпанельных компонентов и постепенно заменяется только там, где необходим page-level semantic contract.

## Альтернативы

- Расширить `AdaptiveSplit` множеством необязательных ratios и flags: отклонено, потому что public API продолжил бы описывать геометрию вместо назначения страницы.
- Настраивать `Row`, `Expanded` и `ConstrainedBox` в каждом screen: отклонено из-за локальных magic dimensions, расхождения breakpoints и недоступного duplicated content.
- Автоматически выбирать preset по имени screen или lifecycle: отклонено, потому что presentation component получил бы domain/navigation authority.
- Заполнять desktop whitespace дополнительными декоративными cards: отклонено, поскольку не улучшает информационную иерархию и конкурирует с dominant object.

## Последствия

- Expanded screen отличается от mobile структурой композиции, сохраняя один content tree и логический порядок.
- Screen-код явно документирует роль dominant object выбором preset.
- Новые page-level layouts должны использовать `PageLayout`, если соответствуют одному из presets; уникальная композиция требует отдельного решения, а не локального набора чисел.
- Presets ограничивают свободу точечной настройки. Это намеренное ограничение для согласованности и проверяемости design system.
- Typography, lifecycle, actions и navigation contract не меняются.

## Migration и rollback

1. Добавить `PageLayout` и `PageLayoutTheme` как public DS API.
2. Перевести Host Open, Running, Distribution и Finished на presets `workspace`, `split` и `hero`.
3. Сохранить compact source order и существующий `ActionDock` contract.
4. Остальные screens мигрируют отдельно после visual review; `AdaptiveSplit` не удаляется в этой задаче.

При регрессии отдельный consumer возвращается к прежней композиции без изменения его content/callbacks. Если preset model окажется недостаточным, новое ADR supersedes этот документ; локальные geometry overrides не добавляются.

## Проверка

- Component tests проверяют compact stack и expanded ratios/regions для каждого preset.
- Widgetbook строит Host consumers на compact и expanded viewport без overflow.
- Golden review подтверждает структурное отличие Host desktop и отсутствие mobile regression.
- Architecture check запрещает raw visual values и domain/application/data dependencies в component.
- Полный `make check` остаётся release gate.
