#75 · Размеры preview Widgetbook

## Статус и этап
✅ Выполнена; Mode CODE; Stage DONE; TestGate NOT_REQUIRED: tooling visual configuration, без предметной логики.

## Цель и план
Штатный ViewportAddon с двумя preset Mobile390×844/Desktop1440×900, из существующего VisualViewport; None сохраняет свободный размер окна. Реальные constraints и MediaQuery, без device chrome и новых экранов приложения. Добавить addon, проверить real Workbench в обеих средах, analyzer/architecture и restart.

## Применимые правила
R-001/002/004/007; Flutter R-003.a–g, R-005, R-006.a–d прочитаны. Существующая основная тема и intl сохраняются; tool viewport — среда preview, не production design primitives; именованные builders, package imports, scoped tooling. Conditional rules отсутствуют. Canonical workflow прочитан.

## Acceptance Criteria
- [x] Доступен Viewport selector с Mobile/Desktop.
- [x] Реальные constraints и MediaQuery соответствуют preset.
- [x] Тема/intl и работающий каталог не ломаются, проверки PASS.

## Changelog
Prompt пользователя (дословно):
> добавь в виджет бук 2 экрана для desktop и mobile

Уточнение (дословно):
> нужно добавить knobs в виджет бук с размерами экранов

Решение: штатный selector размеров находится в Addons → Viewport (параметры окружения), компонентные Knobs остаются параметрами конкретного use case.

## Проверки и итог
Штатный ViewportAddon подключён к общей оболочке. Реальный Workbench: presets меняют maxWidth/maxHeight и MediaQuery.size в390×844/1440×900. Полный bootstrap suite4 PASS, включая все98 use cases; analyzer PASS; architecture315 файлов PASS; rules/diff PASS. Приложение перезапущено. Через native UI открыт Addons → Viewport, визуально подтверждены None/Mobile/Desktop. Собственные screen widgets и новые product PNG не создавались; golden update не нужен.
