# ADR-0011: App lifecycle и state-driven routing

- Статус: Accepted
- Дата: 2026-08-30
- Владельцы: Tournament HUB core team
- Связанная задача/open decision: [TH-20260830-086](../../ai-context/tasks/TH-20260830-086.md); OD-013 исключён из решения

## Контекст

Flutter Host должен одинаково запускаться, восстанавливать локальные данные и выбирать допустимый экран после первого старта, restart и recoverable failure. Если отдельные screens или router callbacks сами решают, когда профиль готов, существует ли active tournament и можно ли перейти в следующий lifecycle state, приложение получает несколько конкурирующих источников истины.

При этом router не может быть полностью заменён одним global state: внутри готового приложения пользователь свободно открывает Main, Profile, History и Settings, а Main остаётся доступен при active tournament. Требуется разделить authoritative состояние приложения, пользовательский navigation intent и чистую проекцию route.

## Решение

### Владение состоянием

`AppBootstrap` в app-слое восстанавливает application projections через ports и публикует immutable `AppState`. Он не импортирует presentation и не вызывает router.

Базовые состояния:

| AppState | Условие входа | Допустимый выход |
|---|---|---|
| `bootstrapping(stage)` | Процесс запущен, обязательные зависимости ещё проверяются | `profileRequired`, `operational`, `recoverableFailure`, `fatalFailure` |
| `profileRequired` | Local storage доступен, валидный local profile отсутствует | `operational` после committed create profile; `recoverableFailure` |
| `operational(session)` | Profile и session projection согласованы с committed local state | новое `operational(session)`, `recoverableFailure`, `fatalFailure` |
| `recoverableFailure(problem, retryTarget)` | Restore/operation можно безопасно повторить без потери committed truth | `bootstrapping`, предыдущее валидное `operational`, `fatalFailure` |
| `fatalFailure(problem)` | Безопасное продолжение процесса невозможно | только новый process bootstrap после явного restart/recovery вне текущей state machine |

`session` содержит application-owned projections: local profile и optional active context. Active context имеет typed ID, actor/role и tournament lifecycle projection, но не переносит Domain aggregate или concrete storage DTO в app.

App lifecycle не заменяет:

- tournament lifecycle `Draft/Open/Distribution/Running/Finished/Cancelled`;
- network/connection state `connecting/stale/reconnecting/...`;
- локальное presentation state формы, scroll, focus или dialog.

### Bootstrap pipeline

```text
main.dart
  -> AppComposition.build()
  -> AppBootstrap.start()
       -> validate required dependencies
       -> load local profile projection
       -> load active context projection when profile exists
       -> validate cross-projection consistency
       -> publish one valid AppState
  -> TournamentHubApp(state source, route policy)
```

Промежуточные результаты restore не публикуются как `operational`. Success state появляется только после успешного чтения committed local truth. Retry запускает новый bootstrap attempt с новым generation; late result предыдущего attempt не может перезаписать новое состояние. Dispose прекращает публикацию.

### Composition boundary

`main.dart` является минимальным entry point. `app/composition` — единственное место, где concrete infrastructure/platform adapters связываются с application ports, bootstrap, router adapter и presentation root. Остальной `app` зависит только от application/presentation contracts согласно ADR-0010.

Composition создаёт и владеет lifecycle/disposal dependency graph, но не содержит tournament decisions. Bootstrap не является service locator и получает dependencies через constructor.

### State-driven routing

Router получает два независимых входа:

1. authoritative read-only `AppState`;
2. `NavigationIntent` — желаемый logical route и typed parameters от UI/deep link.

Чистый `AppRoutePolicy.project(appState, navigationIntent)` возвращает `RouteProjection`. AppState определяет допустимые routes и обязательный redirect; navigation intent выбирает экран только внутри разрешённого пространства.

```text
AppState + NavigationIntent
          |
          v
    AppRoutePolicy
          |
          v
    RouteProjection -> Router adapter -> Presentation
```

Обязательные projections:

| AppState/условие | Route result |
|---|---|
| `bootstrapping` | Bootstrap |
| `profileRequired` | Registration независимо от intent |
| `operational`, обычный startup | Main |
| `operational`, допустимый intent | Запрошенный logical route |
| active context + соответствующий Host/Participant intent | State-specific tournament composition |
| недопустимый role/ID/state/deep link | Main либо typed recoverable error, без mutation |
| `recoverableFailure` | Recoverable Error с разрешённым retry intent |
| `fatalFailure` | Fatal Error без внутренних exception details |

Router может хранить текущий navigation intent/history для Back, но не профиль, active snapshot или lifecycle truth. Main/Back меняют intent, не AppState. Application command сначала изменяет authoritative state; новый AppState затем пересчитывает route. Route selection, redirect, Back и deep link никогда не вызывают lifecycle command автоматически.

### Публичные границы

- `AppStateSource` — read-only current state + ordered subscription.
- `AppBootstrap` — idempotent `start/retry/dispose`, единственный writer app lifecycle state.
- `AppRoutePolicy` — deterministic pure projection без IO и commands.
- `NavigationIntentSink` — принимает только navigation intent; lifecycle mutation отсутствует в API.
- Presentation получает state/route projections и explicit application-command callbacks через composition, но не импортирует app.

## Альтернативы

- Router владеет profile/active state и запускает transitions из guards — отклонено: route становится вторым source of truth, restart/deep link способны мутировать lifecycle.
- Каждый screen самостоятельно восстанавливает нужные данные — отклонено: ordering и error semantics различаются, возможны гонки и частично готовый UI.
- Любое изменение AppState всегда принудительно открывает active tournament — отклонено: противоречит доступности Main и обычной навигации; state должен ограничивать и перенаправлять только недопустимые intents.
- Смешать app, tournament и connection lifecycle в один enum — отклонено: независимые автоматы образуют неконтролируемое произведение состояний и дублируют Domain/network contracts.
- Передать router непосредственно в bootstrap — отклонено: создаёт жёсткую связь lifecycle с presentation technology и усложняет contract tests.

## Последствия

Положительно: bootstrap/restart детерминированы; lifecycle имеет одного writer; router можно заменить; guards проверяются pure tests; Main и contextual navigation сохраняются без потери authoritative state.

Отрицательно: появляется отдельная route projection и navigation intent; application data нужно маппить в компактный session projection; все новые app states требуют обновить policy и exhaustive tests.

Operational/security/data effects: schema и protocol не меняются. AppState хранит только минимальные typed projections, не raw DB records и не secrets. OD-013 по port conflict, interface change и server background lifecycle остаётся открытым и не кодируется этим решением.

## Migration и rollback

1. Ввести app state/bootstrap/composition рядом с текущим entry point, используя существующий presentation root как consumer.
2. Перенести startup/profile/active checks в bootstrap ports без изменения Domain/storage semantics.
3. Ввести route policy и заменить прямой screen selection state projection.
4. Добавить contract/negative tests и architecture fitness gate.
5. Удалять transitional callbacks только после эквивалентного test coverage.

Rollback выполняется по слоям: router adapter можно вернуть к предыдущему presentation root, сохранив bootstrap; bootstrap можно отключить только возвратом entry point на последний рабочий commit. Persisted данные не мигрируются, поэтому data rollback не нужен. Matrix/authority нельзя ослаблять локальным исключением: изменение модели требует superseding ADR.

## Проверка

- Exhaustive tests всех `AppState` transitions и bootstrap ordering/retry/dispose.
- Route policy matrix для каждого state, logical route, guard и deep link.
- Negative tests подтверждают, что bootstrap не импортирует router/presentation, а route policy не вызывает application/lifecycle command.
- Restart integration: committed profile/active projection приводит к тому же AppState и допустимому route space.
- `make architecture`, `make test` и `make check` блокируют structural/behavioral regression.
