# ADR-0007: Единый action contract для Host lifecycle

- Статус: Accepted
- Дата: 2026-08-29
- Владельцы: Tournament HUB team
- Связанная задача/open decision: [TH-20260829-075](../../ai-context/tasks/TH-20260829-075.md)
- Заменяет: [ADR-0006](0006-screen-level-action-dock.md)

## Контекст

ADR-0006 разрешил закреплённый `ActionDock` только на Host Running, Result Entry и Distribution. Draft, Open, Finished и Cancelled сохранили header/inline actions. В результате последовательный Host flow меняет placement и визуальный язык кнопок между этапами, а один screen может отдельно определять mobile и desktop action labels.

Пользователь подтвердил, что компактный закреплённый снизу паттерн удобен, и потребовал привести остальные Host-экраны к тому же подходу. При этом ограничение по высоте, одно видимое primary действие и отделение destructive actions остаются обязательными.

## Решение

- Все Host lifecycle screens — Draft, Open, Distribution, Running, Result Entry, Finished и Cancelled — определяют действия одним `ActionDock` contract.
- На compact/mobile этот contract отображается закреплённым снизу над role navigation.
- На desktop тот же экземпляр action contract проецируется в компактный toolbar у заголовка; screen не определяет второй набор labels/callbacks.
- Одновременно видимо одно primary action. Secondary и destructive actions находятся в одном overflow.
- Destructive action требует confirmation; закрытие menu/dialog возвращает focus инициатору.
- Finished и Cancelled используют тот же placement, но содержат только navigation/read-only actions и не получают Host mutation controls.
- Inline-кнопка не дублирует действие из action contract.
- `ActionDock` остаётся presentation-only и принимает готовые widgets/callbacks; lifecycle authority, permissions и routing в него не переносятся.
- Participant, Spectator и общие разделы не используют Host action placement автоматически.

## Альтернативы

- Сохранить разные placement по «критичности» экрана: отклонено из-за скачущей мышечной памяти и визуальной несогласованности Host flow.
- Всегда показывать несколько закреплённых кнопок: отклонено из-за потери mobile viewport и конкуренции действий.
- Перенести `ActionDock` на все роли и разделы: отклонено, потому что read-only projections и обычная navigation имеют другие задачи.
- Оставить отдельные `pageActions` для desktop: отклонено из-за дублирования labels/callbacks и риска расхождения поведения.

## Последствия

- Primary Host action остаётся в одном предсказуемом месте на каждом lifecycle state.
- Mobile сохраняет компактность: одно действие плюс overflow.
- Desktop не получает нижнюю панель, но использует тот же action contract в header toolbar.
- AppShell отвечает только за adaptive placement одного presentation contract; domain behavior не меняется.
- Terminal navigation становится визуально последовательной с активным Host flow.

## Migration и rollback

1. Добавить `ActionDock.toolbar`, сохраняющий actions и overflow semantics.
2. На desktop проецировать переданный `actionDock` в PageHeader вместо отдельного `pageActions` набора.
3. Перевести все Host lifecycle screens на один `actionDock` и убрать inline-дубли.
4. Сохранить `pageActions` для не-Host consumers.

При нарушении viewport, focus или semantics gates откатывается adaptive projection в AppShell; screen callbacks остаются в едином contract и не требуют domain migration.

## Проверка

- Widget tests подтверждают наличие ActionDock на всех семи Host lifecycle screens.
- Mobile tests проверяют одно видимое primary, overflow, confirmation, 200% text и fixed-region ceiling.
- Desktop tests подтверждают toolbar у PageHeader и отсутствие bottom dock.
- Golden review покрывает Host screens на mobile и desktop.
- Architecture check подтверждает отсутствие domain/application/data imports в component и screens.
