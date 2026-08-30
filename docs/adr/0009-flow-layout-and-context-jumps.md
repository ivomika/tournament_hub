# ADR-0009: Flow-layout и контекстные переходы длинных экранов

- Статус: Accepted
- Дата: 2026-08-30
- Владельцы: Tournament HUB team
- Связанная задача/open decision: [TH-20260830-082](../../ai-context/tasks/TH-20260830-082.md)
- Расширяет: [ADR-0007](0007-unified-host-action-contract.md), [ADR-0008](0008-semantic-page-layout-presets.md)

## Контекст

Full-page аудит показал, что `split`, `workspace` и `archive` не подходят для экранов, где dominant/context region заканчивается значительно раньше длинного operational stream. На `Host Running`, `Host Finished` и `History Detail` это создаёт пустой desktop-столбец, а на mobile последовательность матчей достигает нескольких экранов и уводит текущий контекст далеко от закреплённого действия.

`Structure` уже имеет единый renderer `MatchList` для всех форматов и viewport. Исправление не должно возвращать format-specific layouts, дублировать content или добавлять ещё один fixed-слой поверх `ActionDock` и global navigation.

## Решение

- `PageLayoutPreset.flow` описывает страницу как короткую верхнюю композицию `primary + optional secondary` и полноширинный `supporting` operational stream под ней.
- На compact/medium сохраняется единый source order `primary → secondary → supporting`; на expanded `primary` и короткий `secondary` образуют верхний hybrid-row, а `supporting` всегда занимает полную ширину.
- `flow` выбирает screen по semantic-роли контента. Он не измеряет runtime-высоту, не знает route, lifecycle или tournament format и не содержит screen-specific geometry.
- `Structure` сохраняет один renderer и порядок `Сейчас → Далее → Завершённые`. Допустим единый progressive disclosure: текущие и будущие матчи раскрыты, последние три завершённых видимы, более старые раскрываются явным действием с количеством.
- Быстрый возврат к operational context в Host Running использует необязательное contextual action внутри существующего `ActionDock`. Оно отображается как один компактный icon action рядом с primary/overflow, но не становится lifecycle mutation и не создаёт новую fixed-панель.
- На terminal/read-only экранах sticky current context отсутствует. Первый meaningful block показывает winner/result snapshot; длинные standings и Structure продолжаются на всю ширину.
- Переход по anchor меняет только scroll/focus presentation state и не является Domain transition или route navigation.

## Альтернативы

- Оставить длинный content в secondary rail и закрепить весь rail: отклонено из-за потери полезной ширины и сохранения двух несвязанных вертикальных потоков.
- Автоматически переключать split/flow по измеренной высоте children: отклонено как нестабильная geometry heuristic, зависящая от текста и runtime layout.
- Растягивать dominant card или добавлять декоративные surfaces: отклонено, потому что это маскирует пустоту без улучшения информационной иерархии.
- Добавить отдельную fixed jump-панель: отклонено из-за конкуренции с `ActionDock` и mobile navigation.
- Автоматически прокручивать к следующему матчу после любого обновления: отклонено, потому что внешнее состояние не должно отнимать у пользователя позицию чтения.

## Последствия

- Длинный operational stream перестаёт формировать бесконечный узкий rail и использует readable ширину страницы.
- Верхний current/champion block остаётся dominant, а desktop primary action сохраняется справа в header toolbar.
- `ActionDock` получает необязательный presentation-only contextual action; существующие consumers совместимы без изменений.
- Progressive disclosure сокращает старую историю, но требует stateful presentation и отдельной проверки focus/semantics.
- Full-page и viewport goldens остаются разными контрактами: первые проверяют поток целиком, вторые — fold и fixed regions.

## Migration и rollback

1. Добавить `flow` в `PageLayout` и тесты порядка/expanded composition.
2. Добавить optional contextual action в `ActionDock` без изменения primary/overflow contract.
3. Перевести Host/Participant `Running`/`Finished`, `Host Open`, `Participant Lobby` и `History Detail` на `flow`, сохранив role-specific actions и permissions.
4. Заменить оставшиеся screen-level `AdaptiveSplit` в Registration/Join на semantic `PageLayout`; локальные component-level split не затрагивать.
5. Добавить единый completed disclosure в `MatchList` и anchor callbacks на уровне screen.
6. Обновить viewport/full-page goldens после visual review всего Flutter screen catalog.

Rollback выполняется переводом конкретного screen на прежний preset и отключением optional contextual/disclosure parameters; domain/data migration отсутствует.

## Проверка

- Component tests проверяют compact source order, expanded flow-row и полноширинный supporting region.
- ActionDock tests проверяют один видимый contextual action, focus/tooltip, mobile height ceiling и desktop placement перед primary.
- MatchList tests проверяют порог последних трёх, `Показать ещё (N)`, полное раскрытие и сохранение identity/state.
- Screen/widget tests проверяют anchor-scroll без Domain/navigation side effects.
- Viewport и full-page goldens покрывают mobile/desktop `Host Running`, `Host Finished` и `History Detail`.
- Architecture/design token/link checks и полный `make check` остаются обязательными.
