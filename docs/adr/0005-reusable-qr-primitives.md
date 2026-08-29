# ADR-0005: Переиспользуемые QR primitives в Flutter design system

- Статус: Accepted
- Дата: 2026-08-29
- Владельцы: Tournament Hub team
- Связанная задача: [TH-20260829-067](../../ai-context/tasks/TH-20260829-067.md)
- Supersedes: [ADR-0004](0004-pretty-qr-code-adapter.md)

## Контекст

ADR-0004 изолировал `pretty_qr_code` внутри `ConnectionQrCard`, но renderer, quiet zone и spectator-specific presentation оказались одной границей. QR требуется минимум для Participant и Spectator, поэтому сценарная карточка не должна владеть базовым QR renderer-ом или правилами scanability.

## Решение

Ввести два публичных Flutter design-system primitive:

- `QrCode` принимает opaque value, безопасный semantic label, scan state и semantic size preset; владеет encoder/renderer adapter, error correction, fixed visual shape, minimum module pitch и fallback.
- `QrQuietZone` создаёт непрозрачную светлую подложку и вычисляет padding не менее четырёх модулей из фактической размерности QR. Consumer не может уменьшить quiet zone или сделать её прозрачной.

`QrCode` всегда композирует `QrQuietZone`, поэтому прямое использование primitive безопасно без внешней карточки. `ConnectionQrCard` становится scenario wrapper для состояния, ручного адреса и actions и больше не импортирует QR package.

`pretty_qr_code` `3.6.x` сохраняется как внутренний adapter только внутри папки `qr_code`. Публичный API не экспортирует package types и не владеет URI, LAN lifecycle, secret или role contract.

Матрица сохраняет однотонный связный smooth shape, скруглённые finder-маркеры и error correction `M`. Логотип, gradient, opacity, overlay, animation и consumer-defined renderer knobs запрещены. Scanability подтверждается raster decode на нескольких payload, size и DPR; physical scan остаётся integration gate сценарных задач.

## Альтернативы

- Оставить renderer внутри `ConnectionQrCard`: отклонено, потому что Participant и Spectator начинают дублировать QR implementation.
- Публично отдать `PrettyQrDecoration` или raw ECC/shape: отклонено, потому что consumer может создать нечитаемую матрицу.
- Сделать `QrQuietZone` только внешним optional wrapper: отклонено, потому что безопасная вставка перестаёт гарантироваться.
- Перейти на собственный encoder/painter: отклонено как лишняя ответственность без продуктовой ценности.

## Последствия

- QR adapter boundary перемещается из `connection_qr_card` в `qr_code` и защищается architecture check.
- `ConnectionQrCard` сохраняет совместимый scenario API, но композирует public primitive.
- Два typed theme contracts разделяют scan-safe QR values и scenario-card values.
- Новые QR сценарии используют одинаковый deterministic renderer, подложку и quiet zone.

## Migration и rollback

Сначала создаются primitives, затем `ConnectionQrCard` переводится на `QrCode`; scenario consumers не меняются. Для rollback можно вернуть renderer внутрь карточки по ADR-0004, сохранив `ConnectionQrCard` API. Persistence, protocol и пользовательские данные не мигрируются.

## Проверка

- Architecture fitness check разрешает `pretty_qr_code` только внутри `qr_code` adapter.
- Component tests проверяют theme invariants, semantics, fallback, minimum module pitch и отсутствие payload в semantics.
- Widgetbook/goldens покрывают size/state matrix.
- Raster QR декодируется обратно в исходный IPv4, IPv6 и synthetic Participant payload при DPR 1/2/3.
