# Сеть и безопасность

- Любой external payload проходит size/schema/version/role/lifecycle validation до Domain.
- Participant отправляет intent, никогда authoritative fact; Spectator read-only.
- Commands имеют commandId и expectedRevision; duplicates не применяются повторно.
- Reconnect начинается с Host snapshot либо contiguous replay; gap → full snapshot.
- Role projections содержат минимум данных; local history/settings/profile IDs не уходят Spectator.
- QR/code/session secrets не попадают в logs, tasks, screenshots и git.
- Disconnect не создаёт loss, withdrawal или Host Cancelled.
- Не реализуй незакрытый protocol/security choice из open decisions.
