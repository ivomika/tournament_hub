# Данные и persistence

- Active snapshot — source of truth; event log только bounded reconnect buffer.
- Domain model отделён mapper от persisted/network DTO.
- Mutation: validate → Domain → одна DB transaction snapshot+events+idempotency → commit → broadcast/UI success.
- Terminal: history insert + active/log delete в одной transaction; publish только после commit.
- Revision/sequence монотонны; ordering не зависит от wall clock.
- Schema/ruleset/protocol versions не переиспользуются; migrations последовательны и tested.
- History self-contained immutable; projections/statistics воспроизводимы.
- `shared_preferences` запрещён для profile, tournament, history, cache и event log.
