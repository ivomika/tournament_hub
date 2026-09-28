---
name: domain-viewer
description: Maintain or explain TournamentHUB Domain viewer, its AST inventory, curated architecture descriptions, scenario traces, diagnostics, and browser UI. Use for changes to tools/domain-check, Domain viewer data, or docs/architecture/domain-viewer-context.json.
---

# Domain viewer

Read `ai-context/README.md`, the rule router, all mandatory rules, `ai-context/task-list.md` and the active task card before editing. The canonical technical contract is `docs/development/domain-viewer-inventory.md`; intended meaning is in `docs/architecture/domain-layer.md` and `docs/architecture/domain-viewer-context.json`.

Facts come only from the local Dart analyzer. Never hand-edit `tools/domain-check/domain-architecture.json` or `operation-trace.json`, invent a runtime implementation from a port, or turn a static call into a guaranteed execution path. The curated context is separate: edit purpose/scenario text only with code or documentation provenance; preserve its references and status. If a Domain API or scenario implementation changes, review the description and explicitly run `node tools/domain-check/domain-structure.mjs --stamp-context` after review. This command updates fingerprints; never use it blindly to hide drift.

Run `make domain-check-analyzer-bootstrap` once. Then `make domain-check-all-generate` and `make domain-check-test`. Both work locally after dependencies are cached. `make domain-check` serves the viewer. Browser QA is optional and needs external Playwright plus Edge; use `tools/domain-check/viewer.test.mjs` with its documented environment variables. Do not run Flutter builds for viewer-only changes unless the user asks.

If validation reports a missing symbol, repair the curated reference or remove an obsolete scenario with a documented reason. If it reports a stale fingerprint, compare old/new code and update the meaning before stamping. Unknown declarations and missing implementation lookup are limitations to display honestly, not cues to manufacture behavior.
