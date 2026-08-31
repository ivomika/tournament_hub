# Отчёт MVP Host + Guests + Spectator

- Дата проверки: 2026-08-31.
- Задача: `TH-20260830-101`.
- Scope: offline Host с local Guests, Spectator read-only LAN; Participant исключён.

## Подтверждённый вертикальный цикл

Application integration проходит `Draft → Open → Distribution → Running → Finished → History` для Double Elimination, Single Elimination и Round Robin. В каждом сценарии используются четыре локальных участника, уникальные fighter assignments, реальный versioned engine и in-memory SQLite/Drift stores. Результаты вводятся до готового champion/ranking, terminal snapshot читается через History, а после выхода создаётся новый Draft без возврата старой Spectator projection.

Отдельно подтверждены:

- committed Host projection через реальный Shelf HTTP adapter;
- отсутствие `profileId` и `localProfileId` в публичном snapshot;
- Spectator start/publish failure не откатывает Host command;
- mobile suspend останавливает server, resume запускает его и публикует full projection;
- account reset очищает owned SQLite/settings state, in-memory session и Spectator projection, затем останавливает server;
- protocol fixture из `docs/data/fixtures` читается Dart и React consumers.

Correction, withdrawal, restart recovery, terminal dedupe/transaction и statistics проверяются нижележащими Domain/Application/Persistence suites согласно [стратегии тестирования](README.md).

## Автоматические проверки

Успешно:

- tokens generator check;
- 37 fighter assets check;
- Flutter layer import и design-system architecture checks;
- Dart/Prettier format checks;
- `flutter analyze` без замечаний;
- 223 Flutter non-golden tests;
- 13 Vitest tests, TypeScript check и `oxlint`;
- целевые Host/LAN/security integration tests: 7 из 7.

Полный `dart run tool/project.dart check` не зелёный: 99 существующих Flutter golden scenarios расходятся с baseline на текущем Windows renderer. Production UI в этой задаче не менялся, автоматическое обновление эталонов без visual review запрещено. Сгенерированные failure diagnostics удалены из рабочей копии.

## Непроведённые проверки и риск

- Spectator browser review выполнен в Microsoft Edge для live/tournament/champion/stale/waiting и compact fallback; evidence находится в [отдельном отчёте](spectator-web-visual-evidence.md).
- Flutter/Web production builds и signing не запускались по прямому ограничению пользователя и release policy.
- Physical LAN, background, firewall и entitlement smoke на Android/iOS/Windows/macOS не выполнялся до утверждения platform matrix.

Риск ограничен platform/rendering и release-проверками; Domain, persistence, Host authority и protocol integration подтверждены автоматизированно.

## Известные ограничения MVP

- Participant state, connection, cache и notifications отсутствуют намеренно.
- Release блокируют OD-009 (platform matrix), OD-010 (fighter artwork/naming license) и OD-011 (font/fallback license).
- Spectator работает только в одной LAN с Host; Internet/cloud transport отсутствует.
- Spectator read-only и не содержит mutation surface.

Канон ограничений: [Product](../product/README.md), [Open decisions](../product/open-decisions.md), [Operations](../operations/README.md).
