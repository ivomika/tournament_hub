# WebSocket Protocol v1

Канонический контракт realtime-канала между локальным Flutter Host и read-only React Spectator. Participant описан для будущей версии и не входит в MVP.

## Канал и жизненный цикл

Host поднимает единственную точку `ws` на `/ws`. Соединение проходит состояния `CONNECTING → HANDSHAKING → SYNCHRONIZING → LIVE → CLOSING → CLOSED`; переход из `HANDSHAKING` сразу в `LIVE` запрещён.

В MVP разрешён `clientType: spectator`. Host UI WebSocket-клиентом не является. Spectator-соединение не является доменной сущностью; disconnect удаляет только session, reconnect создаёт новый `connectionId`.

Количество Spectator connections не ограничивается protocol-level лимитом: каждая вкладка — отдельное соединение. Ограничения ОС/ресурсов и политика деградации описываются operations-документом, но не меняют протокол.

## Message envelope

Каждое сообщение — JSON-объект с обязательными полями:

```json
{"category":"event","type":"match.current.changed","protocolVersion":1,"payload":{}}
```

`category` принимает `handshake`, `request`, `event`, `error`, `control`; `payload` всегда объект (никогда `null`). `protocolVersion` для v1 равен `1`. Несовместимая версия получает `protocol.unsupported`, после чего Host закрывает соединение.

Spectator первым отправляет:

```json
{"category":"handshake","type":"handshake.client","protocolVersion":1,
 "payload":{"clientType":"spectator","tournamentId":"uuid","lastSequence":0}}
```

Успешный ответ — `handshake.accepted` с `connectionId`, `clientType`, `tournamentId` и `currentSequence`.

## Synchronization и ordering

После handshake Host отправляет `sync.started`, затем либо contiguous events (`mode: events`), либо `sync.snapshot` (`mode: snapshot`), и завершает `sync.completed`. Snapshot содержит `tournamentId`, `sequence`, `snapshotVersion` и role-specific `snapshot`.

`sequence` — единый для турнира поток: начинается с 1, монотонно возрастает, не переиспользуется и общий для всех клиентов. Клиент применяет событие только при `sequence == lastSequence + 1`; дубликаты и старые события игнорируются. Gap переводит клиент в `SYNCHRONIZING`, приостанавливает live events и требует replay либо full snapshot.

Event envelope содержит `eventVersion`, `eventId`, `tournamentId`, `sequence`, UTC `timestamp` и `payload`. События рассылаются строго по sequence. После terminal `tournament.finished` или `tournament.cancelled` live stream турнира завершается.

## Spectator projection

Authoritative Domain Model напрямую не сериализуется. Projection layer формирует публичный DTO, содержащий:

- состояние и метаданные турнира без локальных адресов;
- Guests, fighter artwork/name и распределение персонажей;
- текущие, следующие и завершённые матчи;
- структуру DE/SE/RR, раунды, очки, standings, результаты и champion;
- признаки `stale`, `syncing`, `incompatible` для UI.

Запрещены profile IDs, local history Host, app settings, network addresses, diagnostics и любые mutation-команды. Spectator не отправляет business `request`; он только читает snapshot/events.

## Persistence boundary

Authoritative mutation сначала применяет Domain operation, сохраняет snapshot и event log одной транзакцией, делает commit и только затем broadcast. Ошибка/rollback не публикует событие. После commit failure доставки reconnect восстанавливается snapshot/replay.

## Heartbeat и закрытие

Используются транспортные WebSocket ping/pong frames: interval 15 секунд, максимальная тишина 45 секунд. JSON heartbeat не применяется. Таймаут изменяет только connection state, не tournament state.

Разрешённые application close reasons: `NORMAL`, `HOST_SHUTDOWN`, `PROTOCOL_UNSUPPORTED`, `INVALID_HANDSHAKE`, `TOURNAMENT_NOT_FOUND`, `TOURNAMENT_TERMINATED`.

## Ошибки и безопасность

Ошибки имеют `category: error`, стабильный `type`, `protocolVersion`, `code`, `message` и связанный `requestId` (если это request). UI использует `code`, а не диагностический текст. Host валидирует client type, tournament ID, protocol version и payload; Organizer-команды через WebSocket отсутствуют.

## MVP decisions

- Participant handshake/join/reconnect и private projection отложены за пределы MVP.
- Protocol-level лимита Spectator connections нет.
- При утрате event range всегда используется full snapshot.
- Audience policy (`spectators`) принадлежит application/projection layer, не Domain Model.

Источник: `websocket_protocol_v1_ru.md` (предоставленный технический документ), нормализованный под MVP scope. Связанные нормы: [Data and protocol](README.md), [Operations](../operations/README.md), [Screen map](../product/screen-map.md#spectator-web-flow).
