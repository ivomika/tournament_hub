# Format engine contract v1

- Stable contract: `tournament-format-engine/v1`.
- Owner: Tournament Domain.
- Связанная задача: [TH-20260830-095](../../ai-context/tasks/TH-20260830-095.md).
- Источник: нормализованные [tournament rules](tournament-rules.md), проверенные по Design Doc.

## Граница и versioning

Registry выбирает engine только по паре `formatId + rulesetVersion`. Опубликованная semantics v1 immutable: изменение scoring, progression или ranking требует новой version. State воспроизводится из seed, settings, stable participant IDs и ordered results.

Engine владеет schedule, stable match IDs, единственным `Current`, validation result, progression, standings/ranking и completion readiness. UI, persistence и transport не содержат копий этих правил.

## Settings и result

- DE/SE `mainFirstTo`: positive integer, default `1`.
- DE/SE `finalFirstTo`: positive integer, default равен `mainFirstTo`.
- DE bracket reset использует `finalFirstTo`.
- RR main и tie-break: fixed FT2 без organizer setting.
- Normal score имеет winner score, равный FT, и loser score в `0..FT-1`.
- Technical result хранит winner, loser и stable reason; normal score отсутствует.
- Draw, self-match, result не для `Current` и result после completion отклоняются.

## Progression и ranking

SE случайно seed-ирует initial bracket, продвигает winner и даёт ranges участникам, выбывшим в одном round; semifinal losers делят 3–4. Без third-place match.

DE допускает два losses. Grand Final между winners-side и losers-side finalists завершает tournament при победе winners-side; победа losers-side создаёт mandatory reset. Participants, получившие второе поражение на одной elimination stage, делят place range.

RR main schedule содержит `N(N-1)/2` unordered pairs. Points из normal score: 2:0 = 3/0, 2:1 = 2/1; technical = 3/0. Tied points group получает mini-RR FT2; он ранжирует только по wins. Вся оставшаяся tied subgroup получает новую iteration без лимита и fallback. Main points immutable в tie-break.

## Политика tie resolution

Tie resolution — отдельный Domain policy contract. V1 использует `RepeatedMiniRoundRobinTieResolver`; registry позволяет новой ruleset version подменить policy без изменения Host UI.

## Correction boundary

V1 state хранит dependency facts, но correction command не публикуется до закрытия OD-004. Это исключает молчаливую invalidation event log. Result в `Finished` tournament immutable.

## Compatibility, rollback и verification

Новый contract не меняет DB schema и не мигрирует существующие snapshots: adapters будут добавлены отдельно. Rollback — удаление ещё не подключённого registry entry. Verification: settings/result unit tests, deterministic replay, schedule counts, one-current/no-self invariants, DE reset, SE ranges, RR points и repeated-tie fixtures.
