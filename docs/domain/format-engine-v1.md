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

V1 correction детерминированно replay-ит engine от сохранённых participants, seed и settings, заменяя result target match. Correction разрешена только если ни один созданный после target match не Finished. После correction current и вся несыгранная downstream structure снова выводятся engine. Result в terminal tournament immutable.

### Решение OD-004

- ID/дата/владелец: `OD-004`, 2026-08-30, task `TH-20260830-096`, Domain/Data.
- Контекст: correction должна менять progression без переписывания committed event log и без неоднозначной частичной invalidation.
- Решение: replay исходного seed и упорядоченных results с заменой target result; любой Finished downstream match блокирует команду. Успех атомарно добавляет новую snapshot revision и append-only `result_corrected` event.
- Отклонено: update/delete старых events; ручное редактирование downstream matches; correction после terminal transition.
- Последствия/consumers: format engines отвечают за replay и dependency boundary, application формирует команду, active store отвечает за atomic commit, UI публикует только committed projection.
- Compatibility/migration/rollback: schema v1 не меняется; старые snapshots без correction events читаются как раньше. До production rollback возможен удалением application command/UI при сохранении replay API; committed history не мигрирует и не переписывается.
- Verification: deterministic correction/downstream tests, atomic active-store tests и offline Host integration test из `TH-20260830-096`.

## Placement conformance

Каждый `TournamentEngineOutcome` проходит domain-проверку перед завершением Host: ranking содержит каждого participant ровно один раз, ranges образуют непрерывную partition от места `1`, а два одинаковых exact places запрещены. Один и тот же диапазон (`3–4`) разрешён нескольким участникам, если он представляет одну elimination/tie группу. Проверка не назначает места и не выполняет tie-break — это обязанность соответствующего format engine и `RoundRobinTieResolver`.

## Compatibility, rollback и verification

Новый contract не меняет DB schema и не мигрирует существующие snapshots: adapters будут добавлены отдельно. Rollback — удаление ещё не подключённого registry entry. Verification: settings/result unit tests, deterministic replay, schedule counts, one-current/no-self invariants, DE reset, SE ranges, RR points и repeated-tie fixtures.
