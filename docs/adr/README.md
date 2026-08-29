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
