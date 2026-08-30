# Tournament Hub Spectator Web

Read-only React/Vite presentation для Spectator: dashboard previous/current/next, tournament structure, standings, champion и состояния соединения. Экранный слой потребляет только публичную projection и не содержит tournament mutations или Domain engine.

Fighter artwork подключается из общего Flutter asset source через Vite `publicDir`, поэтому отдельные копии изображений в Web запрещены. WebSocket runtime подключается отдельной задачей поверх typed projection.

Запускать и собирать приложение следует из корня репозитория через команды из [корневого README](../../README.md).
