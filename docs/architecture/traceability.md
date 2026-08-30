# Traceability matrix

| Requirement | Owner | Contract/data | UI consumer | Required tests |
|---|---|---|---|---|
| PR-001 Host authority | application/domain | command/event protocol | Host/Participant/Spectator | permission, spoof/duplicate, projection |
| PR-002 One active | application/storage | active snapshot unique boundary | Main | concurrent create/restart |
| PR-003 Lifecycle | domain aggregate | lifecycle field/revision | Router/state screens | exhaustive transitions |
| PR-004 Terminal immutable | storage/domain | historical snapshot | History/Finished | terminal transaction/mutation rejection |
| PR-005 Clients read-only | projection/protocol | role DTO schemas | Participant/Web | no mutate surface/redaction |
| PR-006 Unique assignment | GameDefinition/policy | assignment map | Distribution onward | property/roster limit |
| PR-007 Continue active | application/storage | active restore | Main/Host | widget + restart |
| PR-008 Offline cycle | whole Host | local DB | Host UI | platform E2E no Internet |
| PR-009 Statistics | history projection | history snapshots | Profile/History | replay/technical exclusion |
| PR-010 UI states/a11y | presentation/design | presentation state | all screens | widget/component/a11y matrix |
| AR-001 Layer direction | architecture | [ADR-0010 allow matrix](../adr/0010-layer-import-boundaries.md) | all Flutter production layers | architecture import gate + positive/negative fixtures |
| AR-002 State-driven routing | app | [ADR-0011 lifecycle/route projection](../adr/0011-app-lifecycle-and-state-driven-routing.md) | Flutter bootstrap/router/presentation | bootstrap transition + route policy + negative coupling tests |

Новая requirement получает stable ID, owner, contract, consumer и test link. Матрица не заменяет подробный документ.
