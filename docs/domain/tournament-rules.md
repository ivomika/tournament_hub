# Tournament domain rules

## Core invariants

- Participants: минимум 2; максимум ограничен roster при обязательном unique assignment.
- В active tournament одновременно один `Current` match.
- Finished match имеет ровно winner и loser; draw отсутствует.
- Bye не является match win/loss и не попадает в statistics.
- Technical result хранится отдельным типом без выдуманного normal score.
- Finished/Cancelled immutable.
- Полный ranking строится только engine соответствующей version.

## Aggregate model

Tournament snapshot должен концептуально содержать:

- `tournamentId`, `revision`, `createdAt`, `updatedAt`;
- title, `gameId`, `formatId`, `rulesetVersion`, typed settings;
- lifecycle state;
- participant snapshots and source type;
- fighter assignments;
- format engine state/matches/results;
- audit metadata, не заменяющую event log;
- final outcome только для Finished;
- cancellation facts/reason только для Cancelled.

## Match lifecycle

```text
Upcoming -> Current -> Finished
```

Engine детерминированно выбирает Current. UI/Host не меняет очередь вручную. Result command должен ссылаться на current match, actor, expected revision и допустимый result payload.

## Result model

- `NormalResult`: winner/loser и фактический счёт серии; каждая битва имеет собственный score.
- `TechnicalResult`: winner/loser + stable reason code, без normal score.
- `Bye`: structural advancement, не result.
- Forfeit текущего match создаёт technical loss и сам по себе не снимает participant.
- Withdrawal — отдельная irreversible tournament command.

## Double Elimination

- 0 losses: Winners; 1: Losers; 2: eliminated.
- Initial seeding и Bye positions случайны через injected RNG/seed.
- Rematch разрешён.
- Если Losers champion выигрывает Grand Final, Bracket Reset обязателен.
- Reset использует final FT setting.
- Следующий match становится Current только после полного определения его slots.
- Correction допустима только до любого Finished dependent match.
- Participants, выбывшие на одной стадии DE, делят один диапазон мест; exact/ranged placement одинаково сериализуется и воспроизводится.
- Main bracket по умолчанию FT1; Grand Final может иметь отдельный FT; reset использует final FT.

Property invariants: каждый non-bye result добавляет ровно winner/loser; participant не играет сам с собой; eliminated не возвращается; champion имеет менее двух поражений до terminal condition; каждый created match имеет стабильный ID.

## Single Elimination

- Первое поражение устраняет participant.
- Bye не считается победой.
- Матча за третье место нет; semifinal losers делят 3–4.
- Main bracket по умолчанию FT1; Final может иметь отдельный FT setting.
- N participants завершают ровно N−1 normal/technical played matches без учёта Bye.

## Round Robin

- В основном этапе каждая unordered pair встречается ровно один раз.
- Каждый match FT2, setting неизменяем.
- Points: 2:0 → 3/0; 2:1 → 2/1; technical → 3/0.
- Standings — projection из authoritative results, а не независимо редактируемые данные.
- При равенстве points создаётся отдельная mini-RR group только из равных participants.
- Mini RR FT2 ранжирует по wins; оставшаяся tied subgroup получает новый tie-break iteration.
- Лимита iterations и fallback нет: tournament остаётся Running, пока все tied subgroups не получат однозначный порядок.
- Основные points не меняются; tie-break records хранятся отдельно и входят в history.
- Tournament не Finished, пока place groups не соответствуют разрешённой уникальности/ranges.

Schedule invariants: N(N−1)/2 main matches; каждая пара один раз; для нечётного N допустим idle slot/round, но не фиктивная победа; отдельные battle scores независимы.

## Assignment

- Только Distribution.
- Полная bijection participant → unique fighter из доступного roster.
- `Reroll All` создаёт полностью новое допустимое распределение; индивидуальный reroll отсутствует.
- Back to Open очищает assignments.
- Running фиксирует assignments навсегда в snapshot/history.
- Randomness инъецируется и тестируется seed-based/property tests; криптографическая непредсказуемость не является tournament requirement.

## Withdrawal

- Только Host, только Running, необратимо.
- Уже Finished matches не переписываются.
- DE/SE engine создаёт technical progression для следующего применимого opponent без выдуманных played scores.
- RR каждый оставшийся main/tie match withdrawal participant завершает technical 0/3 для opponent.
- Повторная команда с тем же `commandId` не добавляет результаты повторно.

## Correction

Общее правило: correction запрещена, если любой downstream match уже Finished. Форматный engine владеет dependency graph и invalidation plan. До закрытия OD-004 correction не реализуется догадкой. History после Finished не корректируется.

## Completion

- Engine возвращает completion только при закрытии обязательных matches и валидном outcome.
- Host выполняет отдельную Finish command; readiness не завершает tournament автоматически.
- Finished outcome содержит champion и все допустимые places/ranges.
- Cancelled outcome содержит только факты; champion/ranking отсутствуют, если не были определены.

## Engine conformance suite

Каждая version engine проходит transition guards, determinism/replay, no-self-match, stable IDs, one-current, correction boundary, withdrawal, restart round-trip и invariant/property tests. Fixtures сохраняются по ruleset version.
