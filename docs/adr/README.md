# Architecture Decision Records

ADR фиксирует устойчивое решение, меняющее system boundaries, technology baseline, authority, persistence, versioning, transport, platform support или design token source.

Общий критерий серьёзности, traceability и артефакты для неархитектурных решений заданы в [decision policy](../governance/decision-policy.md).

Имена: `NNNN-short-kebab-title.md`. Статусы: Proposed, Accepted, Superseded, Rejected. Accepted ADR нельзя переписывать задним числом; новое решение supersedes старое.

Перед ADR проверь open decisions. Карточка задачи ссылается на ADR; ADR ссылается на contracts/tests/migration.

Используйте [template](template.md).

## Реестр

- [ADR-0001: JSON manifest как источник значений design tokens](0001-design-token-manifest.md) — Accepted.
- [ADR-0002: Widgetbook как Flutter presentation catalog](0002-widgetbook-presentation-catalog.md) — Accepted.
- [ADR-0003: Theme-driven границы Flutter design system](0003-flutter-design-system-boundaries.md) — Accepted.
- [ADR-0004: pretty_qr_code как Flutter QR renderer](0004-pretty-qr-code-adapter.md) — Superseded by ADR-0005.
- [ADR-0005: Переиспользуемые QR primitives в Flutter design system](0005-reusable-qr-primitives.md) — Accepted.
- [ADR-0006: Screen-level ActionDock для критичных mobile-действий](0006-screen-level-action-dock.md) — Superseded by ADR-0007.
- [ADR-0007: Единый action contract для Host lifecycle](0007-unified-host-action-contract.md) — Accepted.
- [ADR-0008: Семантические page-layout presets](0008-semantic-page-layout-presets.md) — Accepted.
- [ADR-0009: Flow-layout и контекстные переходы длинных экранов](0009-flow-layout-and-context-jumps.md) — Accepted.
- [ADR-0010: Строгие границы импортов между слоями](0010-layer-import-boundaries.md) — Accepted.
- [ADR-0011: App lifecycle и state-driven routing](0011-app-lifecycle-and-state-driven-routing.md) — Accepted.
- [ADR-0012: Lifecycle локального Spectator server](0012-spectator-server-lifecycle.md) — Accepted.
- [ADR-0013: Skia как renderer по умолчанию на macOS](0013-macos-skia-default-renderer.md) — Accepted.
- [ADR-0014: Постоянно доступный Spectator server в foreground runtime](0014-always-available-spectator-runtime.md) — Accepted; уточняет ADR-0012.
