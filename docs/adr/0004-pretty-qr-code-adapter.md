# ADR-0004: pretty_qr_code как Flutter QR renderer

- Статус: Superseded by [ADR-0005](0005-reusable-qr-primitives.md)
- Дата: 2026-08-29
- Владельцы: Tournament Hub team
- Связанная задача/open decision: [TH-20260829-063](../../ai-context/tasks/TH-20260829-063.md); OD-002/OD-003 не закрываются этим решением

## Контекст

Flutter design system нужен QR-компонент для локального spectator URL. QR должен оставаться сканируемым, но внешняя композиция должна соответствовать visual language `Competitive / Cinematic / Clean`. Renderer не должен владеть LAN endpoint, session contract или Host lifecycle.

## Решение

Использовать `pretty_qr_code` `3.6.x` под внутренним адаптером `ConnectionQrCard`. Публичный API design system принимает готовые `encodedValue`, безопасный `displayAddress`, typed presentation state и callbacks; типы пакета наружу не экспортируются.

Матрица рендерится однотонным связным smooth shape на светлой surface, с контролируемым скруглением модулей, error correction `M` и стандартной quiet zone в четыре модуля. Уровень `M` выбран потому, что внутри матрицы нет перекрывающего логотипа: он сохраняет штатную коррекцию ошибок и делает короткий локальный URL визуально менее плотным. Логотипы, градиенты, прозрачность, разрозненные декоративные точки и анимация внутри QR запрещены.

## Альтернативы

- `qr_flutter`: зрелый renderer, но предоставляет меньше возможностей для будущего visual adapter и экспорта.
- `artistic_qr`: отклонён из-за меньшей зрелости и platform coverage.
- Собственный encoder/painter: увеличивает объём security/scanability ответственности без продуктовой ценности.
- Прямая зависимость screens от `pretty_qr_code`: отклонена, потому что связывает screen composition с конкретным package API.

## Последствия

- Добавляется MIT runtime dependency и transitive package `qr`.
- QR renderer заменяем внутри design system без изменения Host/application consumers.
- Scanability важнее декоративной вариативности; связный shape допускается только вместе с decode-проверкой, а низкоуровневые настройки не входят в публичный API.
- URI/session/privacy contract остаётся за application/network boundary и будущими решениями.

## Migration и rollback

Новый компонент внедряется сначала в Widgetbook, затем используется экраном Host/Open в задаче 064. Для rollback удалить dependency и заменить внутренний renderer `ConnectionQrCard`; публичные state/address/callback contracts сохраняются. Persistence, protocol и пользовательские данные не мигрируются.

## Проверка

- Design-system architecture fitness check не допускает import пакета из screens.
- Component tests покрывают state, semantics, actions и responsive composition.
- Widgetbook/golden проверяют mobile, desktop, long address и non-ready states; QR из готового изображения декодируется обратно в исходный URL.
- Физическое сканирование безопасного локального URL выполняется при интеграции Host/Open.
