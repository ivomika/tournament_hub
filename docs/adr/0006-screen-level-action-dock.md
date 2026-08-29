# ADR-0006: Screen-level ActionDock для критичных mobile-действий

- Статус: Superseded by [ADR-0007](0007-unified-host-action-contract.md)
- Дата: 2026-08-29
- Владельцы: Tournament HUB team
- Связанная задача/open decision: [TH-20260829-069](../../ai-context/tasks/TH-20260829-069.md)

## Контекст

`AppShell` размещает все `pageActions` вертикальным блоком над mobile navigation bar. Три действия вместе с навигацией занимают значительную часть viewport и отодвигают текущий матч или форму результата. На desktop тот же contract превращается в высокий trailing stack, визуально оторванный от заголовка.

Пользователю при этом нужен постоянный доступ к критичному следующему действию. Требуется отделить lifecycle-critical mobile action от обычных header/inline actions без переноса domain authority в presentation.

## Решение

Вводится screen-level pattern `ActionDock` со следующими границами:

- dock принимает готовые widgets/callbacks и не знает о lifecycle, routes, repositories или transport;
- на mobile одновременно отображается одно primary action;
- secondary actions открываются через доступный overflow;
- destructive action отделяется от primary, явно описывает последствие и требует confirmation;
- dock учитывает `SafeArea`, `MediaQuery.viewInsets`, text scale и возвращает фактическую высоту через layout, чтобы scroll content имел достаточный bottom inset;
- dock не дублирует то же действие inline;
- dock разрешён только на `Host Running`, `Host Result Entry` и валидном `Host Distribution`;
- на остальных экранах действия остаются в header, inline либо overflow;
- desktop использует header/toolbar placement и не показывает bottom dock.

Pattern сначала остаётся screen-level API. Его promotion в общий публичный catalog допускается после прохождения adaptive, semantics и focus gates на реальных Host screens.

## Альтернативы

- Постоянный вертикальный блок всех действий: отклонён из-за потери полезной высоты и слабой иерархии.
- Универсальный fixed action bar на каждом экране: отклонён, потому что read-only и редкие действия начинают конкурировать с главным контентом.
- Floating action button: отклонён, потому что длинные русские labels и destructive/disabled причины плохо укладываются в icon-only contract.
- Domain-aware shell: отклонён, потому что presentation не должна владеть lifecycle permissions.

## Последствия

- Критичное действие остаётся доступно без прокрутки, а mobile body получает больше места.
- Screens обязаны явно выбирать placement и не могут передавать произвольный набор sticky actions.
- Появляется отдельная adaptive/focus test matrix.
- На desktop и mobile используются разные композиции одного action contract.

## Migration и rollback

1. Реализовать screen-level `ActionDock` и его theme contract.
2. Перенести только три разрешённых Host screen.
3. Пересобрать desktop header/toolbar placement.
4. Убрать прежний generic mobile `pageActions` path после миграции всех callers.

При нарушении viewport, keyboard или focus gates экран возвращается к inline action; domain callbacks и state остаются неизменными.

## Проверка

- Component tests: primary, overflow, destructive confirmation, loading/disabled/error.
- Adaptive tests: compact/medium/expanded, 320×720, landscape, 200% text scale и открытая клавиатура.
- Accessibility: semantics, keyboard order, focus restoration, reduced motion.
- Architecture: component не импортирует domain/application/data и screens используют публичный presentation API.
