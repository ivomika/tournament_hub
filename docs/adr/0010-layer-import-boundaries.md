# ADR-0010: Строгие границы импортов между слоями

- Статус: Accepted
- Дата: 2026-08-30
- Владельцы: Tournament HUB core team
- Связанная задача/open decision: [TH-20260830-084](../../ai-context/tasks/TH-20260830-084.md); open decision не требуется

## Контекст

Архитектура Host уже разделяет Domain, application services, presentation и infrastructure, однако направление зависимостей было описано только схематично. Из-за этого review и analyzer не могли однозначно отличить допустимый import от нарушения: UI мог получить concrete adapter, application — presentation controller, а `shared` — превратиться в обходной канал.

Нужен единый машинно-проверяемый контракт до появления новых модулей. Он должен одинаково трактовать package и relative imports, будущие необязательные каталоги, generated Dart и Widgetbook. Spectator Web остаётся отдельным TypeScript-приложением и не должен становиться частью Dart graph.

## Решение

### Владельцы слоёв

Production Dart код расположен в `apps/tournament_app/lib`. Владельцем файла считается первый сегмент пути после `lib/`: `app`, `presentation`, `application`, `domain`, `infrastructure`, `platform` или `shared`.

- `domain` владеет бизнес-инвариантами, entities, value objects и чистыми contracts.
- `application` владеет use cases, orchestration, ports и application DTO/projections.
- `presentation` владеет UI, presentation state/controllers и Widgetbook stories.
- `infrastructure` и будущий root `platform` владеют concrete adapters.
- `app` владеет bootstrap, lifecycle, routing и composition.
- `shared` содержит только независимые от feature/layer чистые примитивы.

`main.dart` считается entry point `app/composition`. `main_widgetbook.dart` считается presentation entry point. Неизвестный production root является ошибкой классификации после его появления: его нельзя молча считать `shared`.

### Allow matrix

Ячейка перечисляет project layers, которые source layer вправе импортировать. Импорты Dart SDK и внешних packages регулируются дополнительными ограничениями ниже.

| Source | Разрешённые project targets |
|---|---|
| `domain` | `domain`, `shared` |
| `application` | `application`, `domain`, `shared` |
| `presentation` | `presentation`, `application`, `shared` |
| `infrastructure` | `infrastructure`, `application`, `domain`, `shared` |
| `platform` | `platform`, `application`, `domain`, `shared` |
| `app` вне `app/composition` | `app`, `application`, `presentation`, `shared` |
| `app/composition` и `main.dart` | `app`, `presentation`, `application`, `domain`, `infrastructure`, `platform`, `shared` |
| `shared` | `shared` |
| `main_widgetbook.dart` | `presentation`, `application`, `shared` |

Любое направление, отсутствующее в строке, запрещено. В частности:

- `presentation` не импортирует Domain напрямую, `app`, `infrastructure` или `platform`; UI получает application contracts/projections.
- `application` не импортирует presentation, app или concrete adapters.
- `domain` не импортирует application и внешние слои.
- `infrastructure`/`platform` не импортируют presentation или app.
- только `app/composition` связывает concrete adapters с ports и presentation controllers.

Public port принадлежит слою, который формулирует потребность: use-case ports — `application`, чистые business contracts — `domain`. Adapter реализует port во внешнем слое; перенос concrete type в public port запрещён.

### Framework и external package constraints

`domain` не импортирует Flutter, Riverpod, Drift, JSON/serialization libraries, sockets и platform APIs. `application` не импортирует Flutter UI, Riverpod widgets, Drift, sockets и platform APIs. Разрешение внешнего package не отменяет layer matrix: package не используется как туннель к коду проекта.

`shared` допускает Dart SDK и явно выбранные framework-free packages, но не Flutter/Riverpod/Drift/platform APIs. Если примитив требует framework, он принадлежит конкретному внешнему слою.

### Generated, tests и catalog

- `.g.dart`, `.freezed.dart` и другой generated Dart внутри production layer наследует владельца исходного каталога и проверяется по той же matrix. Суффикс generated-файла не является исключением.
- Generated platform registrants вне `lib` не входят в production layer graph.
- Код в `test`, `integration_test` и tooling fixtures не является production layer и не проверяется production matrix. Он проверяет сам gate отдельными positive/negative fixtures.
- `presentation/widgetbook` является частью presentation, а не composition root. Stories используют public presentation API и application projections; прямой доступ к app/domain/infrastructure запрещён.
- `apps/spectator_web` — отдельная application boundary. Dart production code не импортирует её исходники; TypeScript import rules будут отдельным решением/tooling.

### Enforcement

Относительные и `package:tournament_app/...` imports сначала нормализуются в путь внутри `lib`, затем проверяются по matrix. Нарушение завершает architecture check с non-zero code и сообщает source path, import и запрещённое направление. Отсутствующий optional root не является ошибкой; появившийся файл сразу попадает под соответствующее правило.

## Альтернативы

- Оставить правило только в review/analyzer lint — отклонено: стандартный analyzer не выражает весь project-specific graph, а review не даёт детерминированного gate.
- Разрешить presentation напрямую импортировать Domain — отклонено: это закрепит Domain models как UI API и обойдёт application projections/orchestration.
- Разрешить всем слоям импортировать `shared` без ограничений — отклонено: каталог быстро станет service locator и циклическим обходом.
- Исключить generated files — отклонено: generator мог бы незаметно внести запрещённую concrete dependency.
- Ввести Dart package на каждый слой — отложено: это сильнее изолирует graph, но сейчас создаёт несоразмерную workspace и build complexity.

## Последствия

Положительно: направление зависимостей становится однозначным, нарушения обнаруживаются до runtime, adapters остаются заменяемыми, а UI не знает concrete infrastructure.

Отрицательно: presentation потребуется отдельная application projection вместо удобного прямого Domain import; новые roots и исключения требуют сначала обновить ADR. Source scan не заменяет analyzer и не доказывает отсутствие runtime service locator.

Operational/security/data effects: runtime, storage и protocol не меняются. Проверка выполняется локально и в `make check`; secrets и пользовательские данные не обрабатываются.

## Migration и rollback

1. Добавить checker и fixtures в задаче 085.
2. Подключить его к `make architecture` и `make check`.
3. Проверить текущий production tree без broad allowlist и suppression.
4. Новые слои сначала документировать в superseding ADR, затем менять checker.

Rollback при ложном блокировании: временно запускать остальные quality checks напрямую, исправить классификацию отдельным изменением и вернуть gate. Ослаблять matrix локальным ignore нельзя. Если само направление зависимости оказалось неверным, ADR-0010 supersedes новый ADR; Accepted документ задним числом не переписывается.

## Проверка

- Positive fixtures покрывают каждую разрешённую строку и exception composition root.
- Negative fixtures покрывают все запрещённые межслойные crossing и framework imports Domain/application/shared.
- Checker одинаково обрабатывает package и relative imports, сортирует diagnostics и возвращает non-zero при нарушении.
- `make architecture` и `make check` запускают gate на существующем production tree.
- Документация команд и traceability ссылаются на ADR-0010.
