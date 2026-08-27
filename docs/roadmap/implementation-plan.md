# План реализации полного цикла

Каждая фаза оформляется отдельными task cards. Переход к следующей фазе требует её exit gate; open decisions закрываются до первого затронутого implementation slice.

## P0 — Repository foundation

Deliverables: Flutter/React monorepo, supported platform skeleton после OD-009, Makefile/scripts, CI, format/lint/test/docs-link/assets gates, dependency pinning. Exit: clean checkout выполняет `make setup && make check`; no business code.

## P1 — Tokens and app shell

Deliverables: shared semantic token sources, Flutter theme/Web variables, breakpoints, localization, go_router shell, core components/states. Exit: token/component tests, compact/desktop/a11y demo; OD-011 закрыт.

## P2 — Profile/settings

Deliverables: typed profile domain, Drift repository, onboarding/edit, non-critical preferences, account reset transaction. Exit: fresh/restart/rename/reset tests; no profile in shared_preferences.

## P3 — Tournament core

Deliverables: lifecycle aggregate, participants/Guests, IDs/revision, format and GameDefinition contracts, error model. Exit: exhaustive transition/property tests; no framework imports.

## P4 — Persistence/versioning

Deliverables: active/history/event/idempotency logical stores, DTO/mappers, transaction service, migrations/fixtures. Exit: crash/fault tests включая нормализованную terminal transaction.

## P5 — MK11 roster/assignment

Deliverables: validated import of 37 assets, GameDefinition, unique random assignment, snapshot fighter identity. Exit: manifest/dimension/property tests and license task recorded.

## P6 — Format settings and engines

Закрыть OD-005–OD-008. Реализовать versioned DE, SE, RR independently plus registry. Exit: conformance suites, performance limits, correction/withdrawal/tie-break fixtures.

## P7 — Autonomous Host flow

Deliverables: services/controllers/screens Draft→Finished/Cancelled, result entry, bracket/rounds/standings, Main continue/history. Exit: restart after each lifecycle state and offline E2E for all formats.

## P8 — History/statistics

Deliverables: immutable detail, projections, clear history, hosted/participated representation. Exit: snapshot isolation and reproducible statistics tests.

## P9 — Protocol contracts

Закрыть OD-002/003/012/014. Deliverables: JSON schemas/fixtures, handshake/request/event/error, command idempotency, projection/redaction and compatibility policy. Exit: duplicate/reorder/gap/version/security tests.

## P10 — Host LAN/Spectator

Deliverables: Shelf server, static React bundle, WebSocket publisher, lifecycle diagnostics; React waiting/running/finished/stale UI. Exit: browser reconnect/full snapshot, zero mutate surface, capacity measurement.

## P11 — Participant

Deliverables: QR/code, join/reconnect cache, role screens, local notifications, leave binding semantics. Exit: disconnect never mutates Host, permission/privacy/E2E tests.

## P12 — Hardening

Deliverables: structured redacted logs, payload/rate limits, migrations all versions, accessibility/golden/performance/security audits, background/interface behavior. Exit: all gates and no critical audit/open decision.

## P13 — Release

Deliverables: licenses, platform builds/signing, release notes/known limitations, rollback/schema compatibility, installer/device smoke. Exit: checklist in operations guide signed per supported platform.

## Dependency chain

```text
P0 -> P1 -> P2/P3 -> P4 -> P5/P6 -> P7 -> P8
                                  \-> P9 -> P10 -> P11
P7 + P8 + P10 + P11 -> P12 -> P13
```

## Vertical completion rule

Фаза не считается выполненной по наличию классов/screens. Нужны: owning docs/contracts, lowest-layer tests, adapter/presentation integration, failure states, migration/compatibility impact и recorded checks в task card.
