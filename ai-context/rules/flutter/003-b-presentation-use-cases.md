# R-003.b. Вызовы use cases через state

## Применение

Scope: Flutter-клиент `apps/tournament_app` и его тесты, включая app/domain/infrastructure/presentation. К другим приложениям и инструментам проекта это правило не применяется; их архитектура определяется отдельно.

Обязательное правило. Проверяется при изменении widgets, экранов, UI-state/controllers и пользовательских сценариев.

## Ограничения

- В presentation use cases вызывает только state/controller.
- Widget отправляет действие в state/controller; нельзя получать, хранить или вызывать use case непосредственно в widget, включая callbacks и lifecycle.
- State/controller не вызывает domain ports напрямую и не размещает бизнес-правила; допустима логика состояния и отображения UI.
- Бизнес-правила и оркестрация бизнес-сценария находятся в domain.
- Передача зависимостей state/controller выполняется через конструктор при сборке приложения.
- Routing и bootstrap создают зависимости, но не обходят state для запуска экранных бизнес-сценариев.

## Проверка

Проследить путь изменённого действия от widget к state и use case. Проверить отсутствие обращений widgets к use cases, а state — к ports. Допустимые domain-вызовы и запуск bootstrap описаны в [архитектурном решении](../../../docs/architecture/layer-boundaries.md).
