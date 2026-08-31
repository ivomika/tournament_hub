# ADR-0013: Skia как renderer по умолчанию на macOS

- Статус: Accepted
- Дата: 2026-08-31
- Владельцы: Tournament HUB team
- Связанная задача: [TH-20260831-110](../../ai-context/tasks/TH-20260831-110.md)

## Контекст

Flutter 3.47 включил Impeller на macOS по умолчанию. На поддерживаемом Intel MacBookPro16,1 с Intel UHD 630 и AMD Radeon Pro 5300M приложение запускалось с `MetalSDF`; при визуальной проверке наблюдались артефакты и деградация производительности. В приложении нет пользовательских fragment shaders: проблема относится к platform renderer/Metal path, а не к domain или design-system semantics.

## Решение

Tournament HUB отключает Impeller для macOS приложения по умолчанию через `FLTEnableImpeller=false` в верхнеуровневом `macos/Runner/Info.plist`. Skia остаётся renderer-ом Flutter с Metal backend. Это решение действует для debug, profile и release, если конфигурация не переопределена внешним запуском.

Другие платформы не изменяются. Impeller можно вернуть отдельным решением после повторного A/B-аудита артефактов и frame timings на Intel и Apple Silicon macOS.

## Последствия

- Устраняется риск текущих Impeller/MetalSDF артефактов на Intel macOS ценой возврата к Skia runtime shader compilation.
- Первый запуск и отдельные transitions могут иметь shader compilation jank; это измеряется отдельно в performance audit.
- Решение не является оптимизацией widget tree и не скрывает необходимость профилирования bracket/CustomPaint.

## Альтернативы

- Оставить Impeller включённым — отклонено до устранения наблюдаемых артефактов и подтверждения стабильных frame timings.
- Отключать renderer только в debug — отклонено: проблема воспроизводится как platform rendering risk, а не только инструментальная особенность Debug.
- Переписать gradients/CustomPaint — отклонено как неверный первый шаг без A/B подтверждения renderer.

## Migration и rollback

Для возврата Impeller заменить значение `FLTEnableImpeller` на `true` или удалить explicit opt-out после нового принятого ADR/обновления этого решения. Network, persistence, protocol и user data не мигрируются.

## Проверка

- До решения зафиксирован runtime log `Using the Impeller rendering backend (MetalSDF)`.
- После изменения ожидается `Using the Skia rendering backend (Metal)` в verbose macOS run.
- `Info.plist` валидируется `plutil`, macOS application собирается в debug/profile, architecture/analyze gates проходят.
