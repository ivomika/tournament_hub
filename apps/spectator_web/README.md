# Tournament Hub Spectator Web

Read-only React/Vite presentation для Spectator: dashboard previous/current/next, tournament structure, standings, champion и состояния соединения. Экранный слой потребляет только публичную projection и не содержит tournament mutations или Domain engine.

Fighter artwork подключается из общего Flutter asset source через Vite `publicDir`, поэтому отдельные копии изображений в Web запрещены. Runtime сначала читает `GET /api/spectator/v1/snapshot`, затем подключается к same-origin `/ws`, отправляет spectator handshake с последним sequence и применяет только `spectator.projection.replaced`. Duplicate/old event игнорируется, gap сохраняет last-known projection как stale и запускает full snapshot recovery.

Application-слой содержит strict DTO validator, sequence reducer и transport client. Presentation получает готовую projection и показывает Waiting, Distribution, Running, stale/reconnecting/incompatible и Finished/Champion без tournament mutation controls. Проверки: `npm test`, `npm run check`, `npm run format:check`.

Запускать и собирать приложение следует из корня репозитория через команды из [корневого README](../../README.md).
