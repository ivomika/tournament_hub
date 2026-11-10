# 102. Стабильный запуск macOS на Intel

## Статус
✅ Stage DONE; Mode CODE; TestGate NOT_REQUIRED: конфигурация графического backend/локального запуска, без изменения бизнес-логики, Dart bootstrap или контрактов приложения.
Specification/plan/checks v1.

## Контекст и scope
Intel UHD630 + AMD Radeon Pro5300M, Flutter SDK из Documents/sdk/flutter. Предыдущие runtime логи показывали Impeller MetalSDF; в живом Widgetbook наблюдались пропадающий текст/артефакты и задержки. Основная гипотеза — backend/драйвер, не layout. Проверить поддерживаемый Skia/Metal fallback и закрепить macOS launch config для приложения и Widgetbook. iOS/Android, версии SDK, доменная логика и визуальные компоненты не меняются.

## План
1. Проверить SDK/engine selection code, оборудование, запущенные экземпляры.
2. Сравнить старт/отрисовку на существующем Impeller и Skia/Metal.
3. При подтверждении использовать официальный macOS Info.plist opt-out, чтобы работал запуск через IDE, flutter run и .app.
4. Проверить plist сборки, native startup log, переключения Widgetbook, hot restart/runtime errors; документировать границы проверки; local commit без push.

## Acceptance
- [x] macOS build использует Skia/Metal без специальных ручных CLI-флагов.
- [x] Нативный запуск и проверенные интерактивные переходы без наблюдавшихся артефактов; фактические ограничения указаны.
- [x] Plist/build/config checks и релевантная регрессия пройдены.
- [x] Документация и local commit без push.

## Применимые правила
Core R-001/002/004/007: минимальная конфигурация, русская документация, проверки по риску. Flutter R-003.a–g/R-005/R-006.a–d прочитаны; конфигурация не добавляет app/presentation dependencies, UI-стили и данные не меняются, новые goldens не требуются для native renderer config. Conditional scan: иных правил нет. Workflow: NOT_REQUIRED для конфигурации запуска; новые тесты наличия флага не создаются ради gate.

## Changelog
Prompt пользователя (дословно):
> Еще исправь запуск приложения на macos там очень сильно зависает отображение и еще встречаются сильные артефакты. у меня mac на intel

Основание: https://docs.flutter.dev/perf/impeller#macos ; локальный FlutterDartProject.mm читает FLTEnableImpeller из Info.plist, FlutterEngine.mm выбирает Skia Metal при false; явный CLI-флаг имеет приоритет.

Эксперимент: исходная сборка — startup Impeller(MetalSDF); копия тех же assets с FLTEnableImpeller=false — startup Skia(Metal). Проверены welcome, каталог, Results DE, открытие Viewport overlay/dropdown; на Skia элементы видны. В коротком baseline Impeller дефект не был устойчиво воспроизведён, поэтому не заявляется доказанный FPS uplift; ранее дефект наблюдался в этом же сеансе проекта. Решение: opt-out для всего macOS Runner, без architecture/runtime branching и без изменения mobile targets.

Итог: macOS Runner использует официальный FLTEnableImpeller=false; исходная и временная A/B-сборки проверены на этом Intel Mac. Обычный старт пересобранного bundle без override подтвердил Skia(Metal), переходы/overlay/modal визуально проверены без обнаруженных артефактов. macOS15.8.2/x86_64, Flutter3.47.0. Plist lint/Debug build — PASS, built plist=false, Widgetbook startup tests6 passed, architecture533 files clean, rules/diff check passed. Другие платформы и UI не изменены. Подробности/ограничения: docs/development/macos-rendering.md. Изменение требует полного stop/start native engine; hot restart не заменяет renderer. Local commit, no push.
