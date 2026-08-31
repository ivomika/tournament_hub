# ADR-0012: Lifecycle локального Spectator server

- Статус: Accepted
- Дата: 2026-08-30
- Владелец: Architecture/Operations
- Задача: `TH-20260830-099`

## Контекст

Host должен раздавать Spectator Web и committed public projection по LAN, но недоступность сети, conflict порта, смена интерфейса и background mobile не могут менять tournament lifecycle. OD-013 блокирует реализацию без устойчивой lifecycle/recovery policy.

## Решение

Infrastructure adapter реализует `stopped → starting → serving | degraded | failed → stopping → stopped` за application port. Он bind-ится на IPv4 any-address: сначала configured/default `8080`, при `addressInUse` один раз повторяет с OS-assigned ephemeral port. Другие bind errors дают typed `failed`; Host tournament продолжает offline.

Публичный endpoint выводится из фактического bound port и выбранного non-loopback private IPv4. Bind на any-address переживает смену интерфейса без restart; endpoint projection пересчитывается при network change. Если LAN interface отсутствует, server может оставаться bound, но UI показывает unavailable до появления безопасного адреса.

На Android/iOS `paused`, `hidden` и `detached` останавливают server/sessions; `resumed` запускает новый instance и заставляет clients выполнить full handshake/sync. На Windows/macOS обычный inactive window не останавливает server. Progression, persistence и terminal commit от server availability не зависят.

HTTP surface: read-only `GET /api/spectator/v1/snapshot`, WebSocket `/ws`, static bundle `GET/HEAD`; mutation methods/routes возвращают `405/404`. Browser Origin разрешён только same-origin; отсутствующий Origin допустим для non-browser contract clients. Limits/redaction/versioning принадлежат Spectator v1 contract.

## Отклонённые варианты

- Фиксированный port без fallback: делает обычный conflict фатальным.
- Bind только к одному interface: ломает session при Wi-Fi change.
- LAN server как tournament invariant: блокирует offline core flow.
- Продолжать mobile server в background: ненадёжно и конфликтует с OS lifecycle/permissions.
- Разрешить cross-origin `*`: расширяет LAN attack surface без необходимости.

## Последствия

Application получает только typed status, endpoint и publish API; Shelf/WebSocket остаются Infrastructure. Rebind меняет connection identity и требует sync, но не revision/sequence. Static bundle может отсутствовать: статус degraded, snapshot/persistence truth сохраняются.

## Compatibility, migration и rollback

DB/protocol schema не меняются. Новая platform dependency optional: rollback отключает composition сервера и возвращает unavailable Spectator, не затрагивая active/history data. Изменение port/origin/background policy потребует superseding ADR.

## Verification

Shelf integration tests проверяют preferred/ephemeral bind, GET/HEAD/405/origin, malformed/oversized handshake, snapshot/event after commit и stop/restart. Application integration доказывает, что start/publish failure не блокирует Host commands.

Канон: [WebSocket v1](../data/websocket-protocol-v1.md), [Operations](../operations/README.md#host-server-lifecycle), [Architecture](../architecture/README.md).
