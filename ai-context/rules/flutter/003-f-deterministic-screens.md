# R-003.f. Обособленные детерминированные экраны

## Применение

Обязательное Flutter-правило при создании/изменении screens, их состояния, контрактов и способов preview.

## Ограничения

- Каждый screen располагается в собственной папке presentation/screens вместе с темой и presentation-контрактом; не объединять все экраны в один файл.
- Screen компонует DS; новые кастомные элементы и повторно используемые блоки реализуются в design_system, не копируются на каждый экран. Layout-примитивы Flutter разрешены, их оформление/layout-параметры берутся из темы screen.
- Screen получает controller/state через presentation-контракт и constructor injection. Не зависит от concrete infrastructure/app, ambient DI/router, domain ports/use cases; контракт не раскрывает эти зависимости.
- В screen нет бизнес-правил, вычисления результатов, orchestration или lifecycle-запуска загрузки/navigation. Он отображает типизированное immutable состояние, наблюдает контракт и делегирует действия. Реальный controller вызывает use cases по R-003.b.
- Screen можно вызвать отдельно с preview-реализацией контракта без реальных сервисов. Одинаковые данные, тема, locale, viewport/ресурсы и capture-фаза дают одинаковый визуальный результат; время/случайность/скрытые dependencies не определяют capture.
- Screen имеет scoped Widgetbook-сценарии и goldens по R-006.c/d, включая mobile/desktop.

## Проверка

Открыть screen отдельно с preview-контрактом; проследить импорты и callbacks, отсутствие business/lifecycle orchestration, источник параметров layout и отсутствие копий DS-компонентов.

Контракты и границы: [Архитектура presentation](../../../docs/architecture/presentation-ui.md).
