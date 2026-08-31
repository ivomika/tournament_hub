# Testing strategy

Текущий результат вертикальной MVP-проверки: [Host + Guests + Spectator acceptance report](mvp-acceptance-report.md). Visual review Spectator Web зафиксирован в [отдельном evidence report](spectator-web-visual-evidence.md).

## Принцип

Тест располагается на самом нижнем слое, владеющем решением. UI-тест не заменяет domain invariant test; E2E не заменяет migration contract test.

## Test pyramid

| Layer | Что проверяем | Инструмент/тип |
|---|---|---|
| Domain | lifecycle, engines, ranking, assignment | Pure Dart unit/property/invariant |
| Application | permissions, idempotency, transaction ordering | Unit с fakes/fault injection |
| Data | mapper, schema, migration, round-trip | Drift/SQLite contract fixtures |
| Protocol | schemas, duplicate/gap/reconnect/version | Contract/scenario tests |
| Presentation | states, navigation, accessibility/adaptive | Flutter widget/golden, React component |
| Integration | Host persistence + transport + projections | Local process/in-memory integration |
| E2E | Ключевые offline vertical flows | Platform/web automated/manual gate |

## Mandatory domain suites

- Все lifecycle transitions и rejected transitions.
- One-current invariant.
- DE: losses, Bye, reset, correction boundary, withdrawal, N ranges.
- SE: N−1 played matches, Bye, 3–4 range.
- RR: N(N−1)/2 pairs, battle scoring, technical result, nested tie-break.
- Assignment: completeness, uniqueness, roster limit, deterministic seeded trials.
- Outcome replay: одинаковые inputs/ruleset version → одинаковый result.

Property tests используют many seeds/sizes и сохраняют failing seed. Performance budget отдельно проверяет верхнюю поддерживаемую размерность.

## Persistence suites

- Fresh create and reopen.
- Каждый published schema fixture → current.
- Interrupted mutation before commit leaves old coherent state.
- Failure after commit recovers new state via reload.
- Terminal transaction creates one history and no active/log rows.
- Duplicate terminal command does not duplicate history.
- History snapshot unchanged after profile/roster/ruleset updates.
- Clear/reset post-conditions.

## Protocol suites

- Initial full snapshot.
- Contiguous replay.
- Duplicate request/event.
- Reordered event and gap fallback.
- Stale revision conflict.
- Unsupported protocol/event/schema versions.
- Wrong role/session/tournament.
- Reconnect after log compaction via full snapshot.
- Redaction: forbidden fields never appear in Participant/Spectator payload.
- Disconnect never creates result/withdrawal.

## UI matrix

Каждый ключевой экран: compact/medium/expanded, loading/content/empty/error, stale если network, long Russian strings, 200% text, keyboard focus, screen-reader semantics, reduced motion, missing artwork. Finished/history проверяются как read-only.

Golden tests фиксируют component contract, но не должны массово обновляться без review причины. Dynamic timestamps/IDs изолируются.

Для анализа вертикальной композиции используется отдельный full-page golden harness: он сначала измеряет scrollable content, затем делает один PNG фактической высоты страницы. Fixed `ActionDock` и navigation остаются отдельным нижним слоем и не повторяются внутри прокручиваемого контента. Эти диагностические goldens дополняют, а не заменяют обычные viewport goldens.

QR presentation отдельно проверяет role isolation: Participant invitation постоянно присутствует в `Open`, Spectator access открывается только явным действием, а Join остаётся scanner/code-first. Visual matrix включает mobile/tablet/desktop и large-TV composition; raster decode не заменяет physical camera/TV gate.

## E2E release scenarios

1. First run → profile → Host Draft→Finished → history, offline Internet.
2. Restart Host на Draft/Open/Distribution/Running.
3. Participant join, disconnect, reconnect, finish.
4. Spectator bundle + live updates + stale + reconnect.
5. DE Bracket Reset, SE Bye/shared third, RR nested tie-break.
6. Technical result, withdrawal, valid/invalid correction.
7. Cancelled from each non-terminal state.
8. Account reset and history clear confirmations.

## Quality gates

- Formatter check, Dart analyze, TypeScript typecheck/lint.
- Unit/widget/component tests.
- Fighter manifest/assets validator.
- Markdown link validator.
- Dependency/architecture checks.
- Schema/protocol fixture compatibility.
- Secret and generated-artifact scan.
- Production build only for release/platform task.

Layer import gate запускается командой `make architecture`. Его self-test fixtures лежат в `tool/architecture_fixtures/flutter_layer_imports.json`: positive cases подтверждают разрешённые направления и composition exception, negative cases покрывают каждый запрещённый crossing из [ADR-0010](../adr/0010-layer-import-boundaries.md). Любое production-нарушение печатает source path, import URI и rule ID и возвращает non-zero exit code.

## App lifecycle и routing contract

Contract из [ADR-0011](../adr/0011-app-lifecycle-and-state-driven-routing.md) защищается на трёх уровнях:

- exhaustive unit matrix проверяет все пары app lifecycle transitions;
- bootstrap/router tests проверяют restore ordering, retry, race generation, disposal, guards, Back и отсутствие route → AppState mutation;
- architecture fixtures запрещают bootstrap → router/presentation, lifecycle → router/presentation, navigation/host → lifecycle writer/application commands и direct layer imports из `main.dart`.

Route projection тестируется отдельно от widgets: одинаковые `AppState + NavigationIntent` обязаны давать одинаковый `AppRouteProjection`. Widget tests подтверждают shell navigation, recoverable retry и отсутствие retry/internal exception на fatal route. Изменение state list, logical route или app sub-boundary требует синхронного обновления ADR-0011, exhaustive matrix и negative fixtures.

## Failure policy

Нельзя удалять/ослаблять assertion, повышать timeout или добавлять ignore, чтобы «починить» gate без причины. Flaky test получает task, reproduction data и owner. Непроведённая проверка указывается вместе с риском, а не считается успешной.

## Evidence in task card

Записываются точная команда, exit result/count, manual platform/device, skipped checks и причина. «Тесты прошли» без команды/объёма недостаточно для release task.
