# ADR-0002: Widgetbook как Flutter presentation catalog

- Статус: Accepted
- Дата: 2026-08-27
- Владельцы: Tournament Hub project
- Связанная задача: `TH-20260827-045`

## Контекст

Flutter application должен реализовать adaptive screens и reusable components по design system, но production navigation и Domain пока не готовы. Без изолированного каталога трудно проверять mobile/desktop composition, edge states и единообразие компонентов до интеграции полного flow.

## Решение

Использовать stable Widgetbook 3.x как development-only presentation catalog с отдельным entry point `lib/main_widgetbook.dart`. Каталог вручную организует design tokens, components и screen fixtures; `ViewportAddon` предоставляет ровно два project targets: Mobile и Desktop.

Design values поступают из generated Dart bindings, владельцем которых остаётся `docs/design/tokens.json`. Widgetbook fixtures являются immutable presentation data и не реализуют Domain decisions, navigation transitions или network behavior. Production `main.dart` не импортирует Widgetbook.

## Альтернативы

- Собственный gallery screen: меньше dependency, но потребуется самостоятельно реализовать navigation, viewport controls и catalog UX.
- Golden-only coverage: полезно для regression, но не заменяет интерактивное исследование states и responsive composition.
- Widgetbook 4 prerelease: отклонён до stable release, чтобы не закреплять beta API в foundation.

## Последствия

- Появляется dependency Widgetbook и отдельный development entry point.
- Reusable presentation widgets могут разрабатываться до готовности Domain/application layers.
- Catalog completeness проверяется отдельно; наличие screen preview не означает готовность production flow.
- Обновление major Widgetbook требует новой оценки migration и compatibility.

## Migration и rollback

Каталог изолирован от production entry point. Для rollback удаляются Widgetbook dependency, entry point и catalog directory; reusable theme/components/screens остаются применимыми в основном приложении.

## Проверка

- Production import scan не допускает `widgetbook` вне catalog entry/tree.
- Analyzer и widget tests pump production app, Widgetbook app и adaptive screen fixtures.
- Token generator check подтверждает соответствие manifest.
