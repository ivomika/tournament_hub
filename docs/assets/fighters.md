# Fighter assets contract

## Source

Reference manifest и originals находятся в [`docs/source/fighters`](../source/fighters/). Они read-only для обычных задач. Runtime assets копируются/генерируются отдельным детерминированным pipeline.

## Текущее состояние

- 37 roster entries и 37 PNG.
- Stable IDs уникальны и совпадают с basename.
- Все изображения 512×512.
- Manifest `schemaVersion = 1`, format PNG, ожидаемый transparent background.
- Missing/unlisted assets не обнаружены аудитом 26.08.2026.

## Import requirements

Importer обязан валидировать JSON schema, unique IDs, safe relative paths, file existence, PNG signature, exact dimensions и отсутствие лишних runtime files. Output path map должен быть явным: source manifest использует `assets/fighters/...`, хотя originals лежат в `docs/source/fighters`.

Flutter runtime copy создаётся командой `make sync-fighter-assets` в `apps/tournament_app/assets/fighters`. `make setup` синхронизирует copy, а `make check` сравнивает manifest и каждый PNG с read-only source. Runtime-файлы не редактируются вручную и не становятся новым источником истины.

Runtime importer принимает только schema v1 с точными metadata MK11 Ultimate и полным набором 37 stable IDs. Official fighter display names задаются versioned GameDefinition и не выводятся из filename. Domain allocator получает GameDefinition и integer seed, поэтому assignment воспроизводится после restart. `Reroll All` строит новую полную bijection, в которой fighter меняется у каждого participant; individual reroll отсутствует.

## Visual requirements

- Один стабильный crop per component variant.
- Transparent background проверяется, не предполагается по manifest.
- Fighter name берётся из локализованного roster, не выводится из filename.
- Missing asset показывает безопасный placeholder + fighter name.
- Artwork не используется без text alternative.
- После assignment artwork всегда сопровождается fighter name и nickname.

## Snapshot policy

History хранит stable fighter ID и display snapshot, достаточный для воспроизведения после обновления roster. Нельзя связывать старую историю только с изменяемой текущей записью.

## Legal gate

До release требуется provenance/license record для каждого набора artwork, права на распространение и branding review Mortal Kombat 11. Техническая корректность manifest не означает разрешение на публикацию.
