# R-006.d. Единое ведение Widgetbook

## Применение

Обязательное Flutter-правило при изменении визуальных элементов, screens, preview/scenarios и каталога Widgetbook.

## Ограничения

- Оболочка и каталог Widgetbook находятся в presentation/widgetbook; main запускает их через тонкий app-bootstrap. Product DS/screens не импортируют Widgetbook.
- Scopes зеркалят foundation/components/widgets/screens. Каждый use case находится в собственной папке своего scope/элемента; registry собирает регистрации, не содержит реализации всех примеров в одном файле.
- Use case использует реальный элемент/экран и его тему; не рисует независимую копию UI. Детерминированные данные и именованные builders/preview widgets общие с golden tests.
- Screens открываются с preview-реализацией presentation-контракта без реального DI, routing, БД, сети и бизнес-use cases. Widgetbook не выполняет бизнес-логику.
- Каждый основной вид/значимое состояние имеет именованный сценарий. Knobs — дополнение для исследования, не замена фиксированных сценариев и golden.
- Новые callbacks/helpers соблюдают R-006.a/b; product text — intl по R-005. Метаданные tooling-каталога не используются как локализация продукта.
- Пустой каркас не наполняется demo/product widgets без запроса; папки конкретных use cases создаются по мере реализации.

## Проверка

Проверить расположение use cases, направление импортов, переиспользование сценариев и возможность открыть screen независимо. Сверить сценарии каталога с golden coverage.

Организация и процесс: [Визуальный workflow](../../../docs/development/visual-workflow.md).
