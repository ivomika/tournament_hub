# Operations, security and release

## Host server lifecycle

Предлагаемая state model: `stopped -> starting -> serving -> degraded/rebinding -> stopping -> stopped`, плюс `failed`. Tournament progression не должен зависеть от наличия LAN address. Port conflict/interface change/background policy требуют закрытия OD-013.

Host UI показывает bind address/port, connection readiness, connected client count как diagnostics (не business presence), last error и recovery. Stack trace не показывается пользователю.

Presentation boundary получает готовую `HostOpenConnectionViewData`: локальный endpoint, typed `ConnectionQrState`, число spectator clients и безопасные status/detail labels. `Host/Open` не выбирает интерфейс, port или rebind policy и не собирает URI; он показывает компактную диагностику и передаёт ту же projection в on-demand `ConnectionQrCard`. Состояние `copied` локально для UI и не является состоянием Host server.

## LAN threat model

LAN не считается полностью доверенной. Возможные угрозы: угадывание join code, unauthorized command, replay/duplicate request, spectator scraping, malformed JSON/resource exhaustion, cross-origin browser access и публикация private profile fields.

Минимальные controls до production:

- high-entropy expiring session/join secret в QR/code contract;
- role/session binding и command authorization на Host;
- payload size/rate/connection limits;
- strict JSON/schema validation;
- origin/host policy для web/socket;
- stable error без internal details;
- no secrets в logs/UI screenshot;
- spectator projection data minimization;
- server закрывается/rotates credentials после terminal/reset.

Точная схема блокируется OD-002/OD-003/OD-012.

## Observability

Structured local logs: timestamp UTC, severity, subsystem, safe code, tournament/session correlation с redacted ID, revision/sequence. Nicknames, QR secrets, raw payload, local DB path/content и stack trace в user UI запрещены. Debug logs имеют bounded retention и explicit export consent.

Метрики локальны: mutation duration/failure, migration result, active connections, reconnect/full snapshot counts, publish failures. Они не отправляются в cloud в MVP.

## Recovery

- Storage open/migration failure: не удалять DB; показать retry/diagnostic/export recovery если реализовано.
- Publish failure after commit: сохранить truth, отметить network degraded, client sync через snapshot.
- Corrupt snapshot: quarantine/read-only diagnostic; destructive reset только confirmation.
- Missing web bundle: Host tournament продолжает работать, spectator показывает unavailable.
- Address change: progression продолжается; connection UI обновляется после принятого rebind policy.

## Data deletion

Clear history и account deletion — разные операции с разными confirmations. Account deletion закрывает server/session, очищает profile, active/cache/event/idempotency/history/settings и возвращает Registration. Operation тестируется на crash boundaries. OS-level backup behavior должен быть согласован с privacy policy до release.

## Release matrix

До OD-009 таблица платформ остаётся незакрытой:

| Platform | Status | Required proof |
|---|---|---|
| Android | TBD | install, LAN permissions, background behavior, notifications |
| iOS | TBD | local network permission, camera/QR, notifications |
| Windows | TBD | firewall prompt, bundled web, DB migration |
| macOS | TBD | local network entitlement, signing/notarization |
| Spectator browsers | TBD | current Chrome/Edge/Safari/Firefox matrix |

## Release checklist

- Open decisions для release закрыты.
- Licenses/provenance fighter assets/fonts/dependencies проверены.
- Schema/protocol/ruleset versions frozen и documented.
- Upgrade fixtures всех published versions проходят.
- Offline E2E и LAN reconnect проходят на supported platforms.
- Accessibility/contrast/keyboard/reduced-motion gates пройдены.
- No secrets/debug endpoints/source maps с sensitive code.
- Build artifacts reproducible, signed и checksum recorded.
- Known limitations и rollback plan опубликованы.

## Rollback

Rollback приложения не должен открывать более новую DB без explicit compatibility. Release plan указывает min readable schema, forward migration irreversibility и safe user action. Нельзя рекомендовать удаление DB как стандартное исправление.
