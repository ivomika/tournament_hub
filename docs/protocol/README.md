# Локальный протокол

Сетевой протокол использует явные версионированные конверты для трёх видов сообщений:

- Command — намерение клиента, которое ещё требует авторизации и domain validation.
- Event — уже подтверждённое авторитетное изменение.
- Snapshot — полное текущее состояние для первичной синхронизации или восстановления.

При подключении стороны согласовывают совместимость версий протокола. Сообщения турнира содержат монотонную revision. Повторный event не меняет результат второй раз, а пропущенная revision запускает полную синхронизацию. Контракт Spectator предоставляет только read-oriented display projection.

Планируемые категории: connection, session, group, profile, tournament, match, standings, display, results, heartbeat и errors.

## Spectator WebSocket v1

Flutter Host поднимает HTTP- и WebSocket-серверы внутри локальной сети. Браузер загружает Spectator Web по показанному Host URL и подключается к `/ws` на том же origin. Доступ публичный внутри LAN и только для чтения.

Host отправляет spectator только полный `snapshot`. Инкрементальные events могут появиться позднее как оптимизация, но не нужны для сходимости: при каждом подключении и запросе `sync` клиент получает последнее полное состояние.

```json
{
  "protocolVersion": 1,
  "messageType": "snapshot",
  "tournamentId": "stable-id",
  "revision": 7,
  "payload": {
    "state": "active",
    "format": "roundRobin",
    "name": "Локальный турнир",
    "participants": [],
    "roundRobin": {}
  }
}
```

Обязательные поля envelope:

- `protocolVersion` — версия верхнеуровневого контракта, сейчас `1`;
- `messageType` — `snapshot`;
- `tournamentId` — stable ID текущего турнира;
- `revision` — монотонный номер опубликованного подтверждённого состояния;
- `payload.state` — `active` или `finished`;
- `payload.format` — `roundRobin` или `doubleElimination`.

Каждый participant содержит `id`, `nickname` и snapshot назначенного fighter: `id`, `displayName`, `avatarUrl`. Round Robin projection передаёт готовые раунды, матчи, результаты и standings. Double Elimination projection передаёт stable topology sources, рассчитанные slots/status/winner и отдельные placement replay. Finished snapshot дополнительно содержит `championId` и полный `placements`.

Клиент заменяет read model snapshot целиком. Snapshot с меньшей или равной revision для того же tournament ID считается повтором и игнорируется. Смена tournament ID всегда заменяет состояние. Пропуск revision допустим для полного snapshot. Несовместимая `protocolVersion`, неизвестный format или невалидная обязательная структура переводят клиент в явное состояние protocol error.

Команда клиента `{"messageType":"sync"}` не изменяет турнир и только запрашивает повтор последнего snapshot. Heartbeat использует стандартные ping/pong WebSocket runtime.

Контрактные примеры находятся в [`fixtures`](fixtures/) и используются Dart/TypeScript tests.
