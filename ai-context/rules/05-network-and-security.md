# Network and security enforcement

## Trigger

Изменение external payload, LAN/HTTP/WebSocket, QR/code/session, protocol, projections, permissions, reconnect, logs или diagnostics.

## Обязательно

- Описать threat, permission и data-exposure impact.
- Валидировать external input до Domain и сохранять Host authority.
- Проверить versioning, idempotency, reconnect и redaction по применимому contract.

## Запрещено

- Давать client authoritative mutation или публиковать лишние profile/local fields.
- Логировать/фиксировать secrets и raw sensitive payload.
- Реализовывать незакрытый security/protocol open decision.

## Канон

- [Data and protocol](../../docs/data/README.md)
- [Operations and security](../../docs/operations/README.md)

## Evidence

Contract/security tests для validation, duplicate/gap/reconnect, authorization и projection redaction.
