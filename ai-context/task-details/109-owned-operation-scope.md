# 109. Scope операций владельца

## Статус и этап

✅ Выполнено · Mode CODE · TestGate REQUIRED: новая асинхронная оркестрация.
Stage DONE. Текущие specification 2, plan 2, test set 2: миграция существующего bool dispose. Specification1/test set1 завершены; их evidence и approval ниже сохранены как история.
Канонический процесс: [workflow](../workflow.md).

## Цель и контекст

Владелец закрывает любое число операций одним close; рабочие методы не поддерживают isDisposed и не проверяют его после await. Основание: [отменяемые операции](../../docs/architecture/cancellable-async.md), R-009 и обсуждение пользователя. Независимый runtime-результат после документальной задачи108 получает номер109.

## Scope и non-goals

Уточнение2026-11-11 (specification2): пользователь расширил scope до миграции уже существующих bool dispose. Ниже исходные границы первого среза; актуальные дополнения и новые критерии — в разделе «Продолжение: миграция coordinator».

- Общий чистый Dart-механизм в presentation/operations для controller и app, typed outcomes, индивидуальная отмена, групповой shutdown; уточнение R-009 и canonical docs.
- Только dart:async; новые зависимости не нужны. Это техническая UI/application lifetime-механика, не domain business model. Domain/infrastructure не импортируют presentation; расширение на эти слои не входит.
- Не входят массовая миграция async, изменения coordinator/executor, screen bindings, DI, автоматическое связывание Flutter dispose, UI и goldens. Механизм станет доступен, но не объявляется подключённым к продуктовым экранам.
- Закрытие вызывает владелец в существующем lifecycle; Future cleanup должен наблюдаться owner-обвязкой. Сам scope не узнаёт об удалении Flutter widget автоматически.

## Применимые правила

Прочитаны ai-context README/router, core R-001/002/004/007/008.a/008.b/009, все flutter R-003.a–h, R-005, R-006.a–d, maintenance, registry, workflow. Conditional rules отсутствуют. R-001: одна ответственность lifetime; R-002: контракт в docs; R-004: типизированные исходы/причины; R-007: RED и human gate; R-008: явные имена/ветвления; R-009: cleanup, ownership, поздние результаты. R-003.a/c/e/g: чистый SDK, package imports, функции в классах. UI/use cases/routing не меняются; R-003.b/d/f/h, R-005, R-006 проверены, нового визуального scope нет.

## Уточнения и решения

- Один scope на владельца; десять pending операций закрываются одним вызовом.
- run получает ленивый request factory, синхронные onResult/onError и возвращает ManagedOperation с result/cancel. OperationRequest содержит source Future и onCancel, передающий отмену настоящему источнику.
- Результат: OperationCompleted(value), OperationFailed(error, stackTrace), OperationCancelled(reason: requested/ownerEnded/scopeClosed). Отмена завершает result до завершения cleanup. Cleanup errors возвращаются отдельно из cancel/close.
- Повторные cancel/close возвращают прежнее ожидание. Отмена завершённой операции безопасна и не запускает cleanup успешного источника. После close factory не вызывается, возвращается scopeClosed без вызова UI callbacks.
- close немедленно закрывает доставку всех pending, запускает cleanup всех, ждёт всех и агрегирует ошибки в OperationCleanupException.errors. Один сбой не пропускает остальные ресурсы.
- Callback доставки синхронный: начатый callback не прерывается; исключение callback становится OperationFailed, не вызывает тот же error callback рекурсивно. Source failure вызывает onError один раз. Бизнес-rollback не обещается.
- Поздние source errors наблюдаются scope, даже после cancellation; никакого необработанного фонового Future error. Supplier throw становится failure. Reentrant close внутри factory отменяет и уже созданный источник.
- Внутри нет дублирующего isDisposed: авторитетное завершение/close Future и исход операции. Это состояние lifecycle, а не обещание отсутствия состояния вообще.

## Acceptance Criteria

- [x] AC1: success/failure доставляются один раз; supplier/callback throws получают завершённый исход.
- [x] AC2: один close отменяет десять операций; result завершается сразу, close ждёт cleanup всех; ошибка агрегируется.
- [x] AC3: повторная/индивидуальная отмена безопасна; поздние value/error подавляются; завершённые операции сняты с учёта.
- [x] AC4: после close factory не запускается; reentrant shutdown корректен.
- [x] AC5: R-009/docs описывают обязательный scope для owner-bound работы, границы и фактическое внедрение; tests/analyze/architecture GREEN.

## Test Scenarios

AC1: успешная доставка, source failure, sync supplier throw, throwing success/error callback.
AC2: десять источников с отдельно управляемыми cleanup, один cleanup failure при исправной отмене остальных, результат отмены до конца cleanup.
AC3: cancel одного, повторные cancel/close, позднее значение и ошибка, completed source не отменяется при shutdown.
AC4: новая работа после close, close из source factory, close из result callback.
Без таймеров и реальной сети: управляемые Completer являются внешними источниками; проверяется настоящий OperationScope, не его fake.

## Implementation Plan

1. Baseline navigation73; executable tests отсутствующего API, подтверждённый compile RED; human gate.
2. После approval: operation_outcome.dart, operation_request.dart, managed_operation.dart, operation_scope.dart в presentation/operations; не добавлять production stubs до approval.
3. R-009 и docs уточняются в этой задаче; docs различают контракт и ещё не реализованный механизм.
4. Целевые tests + navigation regression, flutter analyze, полный architecture scan и checker fixtures/self-test; node tools/check_rules.cjs, git diff --check. Без build/run/commit/push.

## Test Evidence

2026-11-11, cwd apps/tournament_app:

- `flutter test --no-pub test/app/navigation --reporter compact` — BASELINE_GREEN: 73 PASS, exit0.
- `flutter test --no-pub test/presentation/operations/operation_scope_test.dart --reporter expanded` — RED, exit1: одна library failed loading. Отсутствуют planned operation_outcome.dart, operation_request.dart, operation_scope.dart и их типы. 16 executable scenarios пока не выполнились; это compile RED capability, не16 поведенческих отказов. Остальная диагностика — зависимое отсутствие типов/вывода generic. Production stubs не создавались.
- Первая sandbox-попытка launcher не запустила тесты, прямой snapshot сообщил недоступный SDK lockfile; это не RED. Повторный запуск с разрешённым доступом к SDK действительно дошёл до компиляции tests. Прямой dart format отформатировал файл, но завершился exit1 из-за telemetry вне workspace; формат проверяется повторно отдельно.
- Повторный `dart format --output=none --set-exit-if-changed test/presentation/operations/operation_scope_test.dart` с доступом к SDK —exit0,0 changes. Root `node tools/check_rules.cjs` —20 leaf/3 группы PASS; `git diff --check` —exit0; локальные Markdown-ссылки карточки/R-009/async docs —PASS. Full analyzer/architecture ожидают реализации отсутствующих API и не объявляются GREEN. Build/run/commit/push не выполнялись.

## Approval

2026-11-11, пользователь: «приступаем к выполнению». Подтверждены specification1/plan1/test set1 задачи109 после показанного compile RED16 сценариев отсутствующего API и baseline73 PASS. Approval записан до первого runtime-изменения.

## Ошибки, ограничения и блокеры

Неотменяемый внешний Future может продолжать работу; scope подавляет доставку и завершает своё ожидание, не обещает остановку side effects. Cleanup обязан завершаться. Generic scope не сериализует navigation и не заменяет guard. Открытых предметных вопросов нет.

## Changelog

### 2026-11-11 · Подготовка

> тогда давай приступим к реализации и написанию правила

- Зарегистрирована109, определены scope/контракты/критерии и план. Рабочее дерево до начала чистое. Runtime ещё не менялся; подготовка тестов до gate.
- Добавлен test/presentation/operations/operation_scope_test.dart:16 сценариев, включая10 операций, ожидание cleanup, failure aggregation, поздние value/error и reentrant close. Baseline73 PASS, ожидаемый compile RED отсутствующего API подтверждён. Stage RED_CONFIRMED → AWAITING_APPROVAL.
- Независимая документационная часть: уточнён R-009, ID/router/registry не менялись; canonical docs описывают контракт scope и честно указывают отсутствие runtime/bindings. Правило не запрещает Flutter mounted для BuildContext и не требует импорта presentation из domain/infrastructure. До runtime требуется новый human approval по workflow.

### 2026-11-11 · Подтверждение реализации

> приступаем к выполнению

- Зафиксирован approval test set1. Stage IMPLEMENTING до создания runtime API. Сохраняются границы: общий scope, без миграции coordinator/экранов и без новых dependencies. Коммиты и запуск приложения не разрешены.

### 2026-11-11 · Реализация, GREEN и проверка

- Добавлены4 runtime-файла в presentation/operations: OperationScope, OperationRequest, ManagedOperation, sealed OperationOutcome с типизированными причинами. Scope владеет registry и единственным Future close; фазы waiting/delivering/settled описывают саму операцию. Отдельного isDisposed/isClosed нет. Новых packages нет.
- Все16 утверждённых сценариев прошли первым целевым запуском. Затем проведён сохраняющий поведение refactor ссылок: request не хранится в завершённом Completer, callbacks и owner-release снимаются после доставки/очистки. Ошибка очистки остаётся доступна следующему close, а после общего close owner-ссылка освобождается даже при сбое.
- Добавлены2 проверки прежних AC2–4: индивидуальный cleanup failure не теряется до owner close; factory, закрывшая scope и затем бросившая исключение, сохраняет ownerEnded и не доставляет ошибку завершённому владельцу. Это уточнения границ текущего контракта, не новая семантика approval. Утверждённые16 тестов не ослаблялись.
- Первичный analyze сообщил6 info prefer_initializing_formals. Исправлено на initializing formals без ignore; повторный analyze чистый.
- Canonical docs обновлены по фактическому runtime, добавлены пример использования, владение и ограничения. Async callback нельзя передавать как синхронную доставку: Dart void сигнатура это не запрещает автоматически, ограничение явно документировано. Реальные controllers/DI и navigation coordinator не подключены.
- `dart format lib/presentation/operations test/presentation/operations/operation_scope_test.dart` —exit0.
- Cwd apps/tournament_app: `flutter test --no-pub test/presentation/operations/operation_scope_test.dart test/app/navigation --reporter expanded` —91 PASS (18 scope +73 navigation), exit0. `flutter analyze --no-pub` —No issues found, exit0. Полный visual/golden suite не повторялся: UI/темы/bindings не менялись; регрессия выбрана по app/presentation async scope.
- Cwd tools/domain-check: полный `dart run bin/check_flutter_architecture.dart` —574 файлов,0 нарушений; navigation_boundaries32 PASS, code_readability41 PASS, top_level_functions49 PASS, theme_boundaries35 PASS, architecture --self-test51 PASS. Все exit0; автоматическое доказательство R-009 не заявляется.
- DTD listDtdUris не нашёл running debug/DTD processes. Hot reload недоступен; новый run не выполнялся. Build/commit/push не выполнялись.
- Финальные структурные проверки: node tools/check_rules.cjs —20 leaf/3 группы PASS; git diff --check —exit0; локальные Markdown-ссылки карточки/R-009/async docs —PASS. dart format --output=none --set-exit-if-changed для4 runtime файлов и теста —exit0,0 changes. Stage VERIFYING → DONE после успешных проверок.

## Ключевые решения

Переиспользуется R-009 без нового ID. Технические правила являются уточнением уже согласованной политики; общие бизнес-правила не добавляются.

## Final Verification первого среза

- [x] AC1–5 подтверждены;18 scope tests и73 navigation tests GREEN.
- [x] Analyzer и все выбранные архитектурные проверки прошли; runtime/UI вне scope не менялись.
- [x] Правила, ссылки, формат, docs и append-only история согласованы.
- [x] Ограничения отмены внешнего Future, синхронной доставки и отсутствия product bindings отражены; открытых блокеров нет.

## Итог первого среза

Общий scope реализован и проверен, R-009 и docs согласованы. Один close завершает owner-bound ожидания и ждёт очистки всех источников; индивидуальные cancel остаются доступны. Runtime готов к подключению в будущих controller/app bindings. Навигационный coordinator, product flow и автоматический Flutter lifecycle не мигрированы, как определено non-goals.

## Продолжение: миграция coordinator

### Scope, критерии и план2

- Read-only scan apps/tools Dart нашёл единственное сохраняемое bool dispose в NavigationCoordinator. InteractionPresentation.isClosing — вычисляемый getter существующего cleanup Future, не дублирующий bool; не меняется. Framework mounted также не меняется.
- Новый scope: убрать _disposed в coordinator, использовать общий OperationScope для ownership pending/active navigation requests и запрета поздней доставки. Сохранить intent → guard → effect, FIFO, dedup/conflict, origin/revision и синхронный вход dispose из AppNavigationSession. Не менять product routes/screens или generic adapter bindings.
- [x] AC6: dispose немедленно завершает проектные ожидания активного запроса и очереди NavigationCancelled, очищает pending; поздние value/error не меняют исход и не создают unhandled error.
- [x] AC7: запрос после dispose не читает контекст уничтоженного router; закрытая очередь не запускает новые effects и не читает context после освобождения. Новый scope на каждый запрос не создаётся вместо scope владельца.
- [x] AC8: повторный dispose безопасен; существующие73 navigation tests и18 scope tests остаются GREEN; bool lifecycle flags не остаются в изменённом runtime.
- Важная граница: Future execute существующего executor физически неотменяем; закрывается проектное ожидание и доступ к очереди. Уже совершённый push/go/pop не объявляется откатанным. Не расширять интерфейс executor новым механизмом отмены в этой итерации; задокументировать фактическую границу. После await executor нет дальнейших SDK-вызовов, только завершение результата.
- План: сначала baseline91 и регрессионные executable tests действующего API; подтвердить behavioral RED; gate версии2. После approval — миграция coordinator на общий scope, адаптация ownership очереди и pending, canonical docs, analyzer/архитектура/целевые regressions. Исходный scope-код уже GREEN; не переписывать его без обнаруженной необходимости.
- Правила прежнего набора перечитаны по router, conditional отсутствуют. Ключевые R-009/003.h/007: отмена ожиданий, сохранение nav policy, test-first. UI/goldens не затрагиваются. Новые зависимости не нужны.

### Approval2

2026-11-11, пользователь: «погнали». Подтверждены specification2/plan2/test set2 после4 behavioral RED и12 прежних PASS на настоящем coordinator. Записано до runtime-изменений миграции.

### Changelog продолжения · 2026-11-11

> после завершения исправь код где уже используется bool dispose

- Задача109 переоткрыта как refinement той же цели; новый номер не создаётся. Предыдущие завершённые критерии/evidence сохраняются. Найден _disposed в coordinator; runtime пока не изменён. Готовятся тесты версии2 для наблюдаемого дефекта pending/late completion, без механической замены bool на enum.

### Test Evidence2 · 2026-11-11

- Baseline реализации до миграции подтверждён предыдущим запуском91 PASS (18 scope +73 navigation); production после него не менялся.
- Добавлены4 сценария действующего coordinator API: pending active/queued немедленно завершаются отменой; после dispose не читается router context; late executor error не доставляется; duplicate запросы при повторном dispose получают отмену без второго effect. Проверяется настоящий coordinator, внешнее ожидание executor управляется Completer. Все паузы освобождаются в finally, чтобы не скрывать результат зависшим тестом.
- Первый запуск тестового harness ошибочно использовал отсутствующий OpenHistoryIntent. Это не capability RED; исправлено на существующий BackRequestedIntent без runtime stubs.
- `flutter test --no-pub test/app/navigation/navigation_coordinator_test.dart --reporter expanded`, cwd apps/tournament_app —exit1,12 прежних PASS,4 ожидаемых behavioral FAIL. Active/duplicate callbacks ещё не завершены при dispose, после dispose readContext вызывается один раз, late executor error попадает в error path вместо NavigationCancelled. Нет syntax/import failure и новых production API в тестах.
- Stage RED_CONFIRMED → AWAITING_APPROVAL. Runtime coordinator/session/executor и scope пока не менялись. Approval предыдущего среза не переносится на новую семантику shutdown автоматически.

### Текущий итог

Миграция завершена: coordinator использует один OperationScope для lifecycle submit/queue execution. _disposed удалён; dispose блокирует новые factories и завершает все pending project waits. Scope первого среза не переписывался, interface executor и session.dispose сохранены. Физическая отмена execute не реализована, что явно отражено в docs. Проверены95 целевых tests, analyzer, архитектура и финальные структурные проверки. Stage DONE. Build/run/commit/push не выполнялись.

### Changelog продолжения · Approval2

> погнали

- Подтверждён test set2. Stage IMPLEMENTING; общий scope становится владельцем submit и dequeued execution, чтобы закрытие блокировало factory до чтения router context и завершало оба вида ожиданий. Queue/dedup/guard остаются. Физическая отмена execute не обещается; повторный dispose инициирует тот же cleanup Future. Внешний синхронный dispose сохраняется.

### Changelog продолжения · Реализация и GREEN2

- NavigationCoordinator получил один owner OperationScope. ScopedNavigationRequest связывает success/error/cancellation с прежним Future<NavigationFeedback>. Входная factory отклоняется scope до readContext; queue execution регистрируется в том же scope до guard/execute. _disposed и обе ручные проверки удалены.
- Одинаковые requests разделяют одно выполнение в pending map; FIFO ждёт opening execution, ошибки не отравляют tail. Scope завершает ожидающие результаты при dispose; pending очищается синхронно. Поздний execute Future продолжает наблюдаться; _releaseWait честно не выдаётся за физический cancel SDK. Повторный dispose вызывает прежний Future close; неожиданные cleanup errors явно передаются Zone handler, не теряются в unawaited.
- Первый запуск coordinator+scope —34 PASS (16 coordinator,18 scope), exit0. Полный выбранный запуск `flutter test --no-pub test/app/navigation test/presentation/operations --reporter expanded` —95 PASS (77 navigation +18 scope), exit0. Утверждённые tests не менялись/не ослаблялись.
- `flutter analyze --no-pub` —No issues found, exit0. Cwd tools/domain-check: полный architecture scan574 файлов —0 нарушений, navigation boundaries32 PASS, readability41 PASS, top-level49 PASS, theme35 PASS, self-test51 PASS. Все exit0.
- Целевой rg scan Dart apps/tools: сохранённых bool dispose/closing/isClosed и runtime _disposed нет; совпадения остаются только в названиях тестовых методов. Вычисляемый InteractionPresentation.isClosing сохранён как корректный view существующего cleanup Future.
- Обновлены3 canonical docs: cancellable-async, typed-navigation, navigation-interactions. Убраны устаревшие утверждения об отложенной миграции; scope не объявляется подключённым к ещё не созданным screen-result bindings. Универсальный auto-lifecycle binding не добавлялся.
- DTD listDtdUris не обнаружил running debug/DTD processes; hot reload недоступен. Новое приложение не запускалось, сборки/коммиты/push не выполнялись. UI/goldens не менялись; полный визуальный suite не повторялся по причине невизуального scope.
- Финальные проверки: rules registry20 leaf/3 группы PASS, git diff --check PASS; локальные Markdown-ссылки карточки и4 изменённых rule/docs PASS; dart format --output=none --set-exit-if-changed для7 runtime/test files —exit0,0 изменений. AC6–8 и прежние AC1–5 подтверждены. Stage VERIFYING → DONE, задача109 повторно закрыта.

### 2026-11-11 · Коммит задачи109

> закомить изменения

- Пользователь разрешил локальный коммит всех изменений задачи109: общий scope, миграция coordinator, тесты, R-009 и документация. Подтверждённый набор95 tests и архитектурные проверки не менялись; повторный runtime-прогон для записи коммита не нужен. Push не выполняется.
