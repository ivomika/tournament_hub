# ADR-0014: Постоянно доступный Spectator server в foreground runtime

- Статус: Accepted
- Дата: 2026-08-31
- Владелец: Product/Architecture
- Задача: `TH-20260831-113`
- Supersedes: часть ADR-0012 о запуске server только из active tournament sync

## Контекст

Spectator URI должен открываться до создания и между турнирами. Связывание transport lifecycle с наличием active tournament приводит к connection refused, делает QR нестабильным и не позволяет показать ожидающее состояние. При этом tournament lifecycle не должен зависеть от LAN availability, а mobile background остаётся ограничен OS policy.

## Решение

Flutter Host запускает read-only Spectator LAN server при старте app runtime и держит его доступным весь foreground runtime независимо от профиля и active tournament. Transport lifecycle и public tournament projection разделены.

При отсутствии турнира, на Draft/Open, после cancellation и после выхода из Finished projection очищена: static Web доступен, `GET /api/spectator/v1/snapshot` возвращает канонический `SNAPSHOT_UNAVAILABLE`, а существующий React client показывает waiting и повторяет sync. На Distribution/Running/Finished Host публикует allowlisted v1 projection. Переходы между этими состояниями не останавливают HTTP server и не меняют endpoint.

На Android/iOS background/pause по-прежнему может остановить server согласно ADR-0012; resume запускает его даже без active tournament. Desktop inactive продолжает serving. Stop остаётся только platform suspension и disposal, а retry выполняет restart transport независимо от projection.

## Отклонённые варианты

- Запускать server при Distribution: сохраняет connection refused до нужной стадии.
- Публиковать искусственный tournament snapshot для waiting: меняет v1 schema и смешивает app/tournament lifecycle.
- Держать mobile server в background: не гарантируется OS и расширяет scope разрешений.

## Последствия

LAN endpoint стабилен между локальными стадиями и турнирами в одном foreground runtime. Waiting использует 503 как отсутствие public snapshot, а не transport failure. Spectator остаётся read-only и не получает profile/local diagnostics. Server availability не становится domain invariant.

## Compatibility, migration и rollback

Wire/DB schema не меняются; существующий React retry contract совместим. Rollback возвращает lazy start, не затрагивая данные. Background и bind policies ADR-0012 сохраняются.

## Verification

Runtime integration проверяет static 200 и snapshot 503 без турнира, тот же endpoint на Draft/Open, snapshot 200 на Distribution и возврат к 503 после выхода из terminal state. WebSocket contract и redaction suites остаются обязательными.

Канон: [Operations](../operations/README.md#host-server-lifecycle), [Screen map](../product/screen-map.md#spectator-web-flow), [ADR-0012](0012-spectator-server-lifecycle.md).
