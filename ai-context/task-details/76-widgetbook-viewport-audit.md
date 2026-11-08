#76 · Аудит размеров Widgetbook

## Статус и этап
✅ Выполнено; Mode CODE; Stage DONE. TestGate NOT_REQUIRED: visual layout/preview sizing и test-only render diagnostics; без application state или business logic.

## Цель и scope
Проверить все101 зарегистрированные use cases в Mobile390×844 и Desktop1440×900, включая composition widgets и foundation. Окружение — настоящий Widgetbook с production appBuilder/addons, в test-only capture instrumentation. Проверять exceptions/overflow, размеры public DS widgets, реальные картинки; не считать отсутствие exception достаточным. Найденные fixes продолжают owning component tasks, каждый компонент отдельным коммитом без push.

## План
1. Собрать native screenshots/geometry/errors для обоих presets без изменения production layout.
2. Визуально сверить подозрительные размеры с текущим UI kit и контрактами.
3. Для каждого дефекта открыть owning task, исправить только соответствующий слой (natural component sizing либо preview bounds), добавить целевую регрессию и сохранить отдельным коммитом.
4. Повторить audit, affected native/source tests и architecture/analyzer; составить coverage/limitations report. Крупный текст дополнительно в affected fixtures.

## Применимые правила
Прочитаны AGENTS, README/router, все core R-001/002/004/007, Flutter R-003.a–g/R-005/R-006.a–d и workflow. Conditional rules отсутствуют. Preview использует реальные widgets/current themes/intl; test instrumentation не попадает в runtime; raw styling в consumers запрещён.

## Acceptance Criteria
- [x] Все use cases проверены в двух viewport; есть coverage/evidence.
- [x] Найденные layout defects исправлены и подтверждены regression.
- [x] Каждый исправленный компонент — отдельный локальный commit, push отсутствует.
- [x] Итоговый audit/analyze/architecture и affected tests проходят; ограничения отражены.

## Changelog
Prompt пользователя (дословно):
> Проверь остальные компоненты в Widgetbook на такие же проблемы с размерами в Mobile и Desktop. Исправь найденное, каждый компонент отдельным коммитом без push.

## Итог
404 native previews:101×Mobile/Desktop×textScale1/1.6, layout errors0. Исправлены Colors, NumberStepper, Button, RosterRow; safe focus inset Borders/NavigationItem/SegmentedChoice/Field. Каждый компонент отдельным local commit, без push. Native screenshots исправлений просмотрены; geometry/errors обоих scales сохранены в docs/design/widgetbook-viewport-audit/. Повторяемый test-only audit содержит safe-inset assertions для focused previews.

Проверки:94 DS+Widgetbook bootstrap tests PASS; оба full audit прогона PASS; analyzer no issues; architecture328 files PASS, top-level49/self-test51/theme-boundary35 PASS; diff check PASS. Source comparison Stepper/RosterRow PASS. Нативный macOS Widgetbook заново собран/запущен (VM60082); другие native platforms NOT_RUN. Report: docs/design/widgetbook-viewport-audit.md.
