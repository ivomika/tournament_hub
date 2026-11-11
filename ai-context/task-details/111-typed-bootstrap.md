# 111. Типизированный bootstrap приложения

## Статус и этап

✅ Завершена · Mode CODE. Итерация2: TestGate NOT_REQUIRED — только отображение текущего шага и локализованные подписи. Логика запуска/отмены/retry остаётся без изменений; прежний REQUIRED gate первой итерации сохранён ниже.
Stage DONE. Specification2/plan2: визуальное продолжение задачи111 завершено.
Процесс: [workflow](../workflow.md).
Production разрешён пользователем после test-first gate; запись approval ниже.

## Цель и основания

Управляемый запуск без map с именами и действиями и без файла со всей инициализацией. Каждый шаг — отдельный BootstrapStep<Input, Output>. Оболочка может работать, пока приложение ещё не готово: ошибка обязательной зависимости блокирует рабочие экраны и явно показывается пользователю; после исправления доступно продолжение.

Основания: обсуждение пользователя; [границы слоёв](../../docs/architecture/layer-boundaries.md), [отменяемые операции](../../docs/architecture/cancellable-async.md), [логирование](../../docs/architecture/logging.md). Исследован текущий код: AppBootstrap.run сразу вызывает runApp; AppNavigationSession создаётся внутри TournamentApp. BootstrapScreen уже имеет loading/error/retrying, но отображает только общую ошибку. Реального HTTP/backend-контракта сейчас нет.

## Scope и non-goals

- App bootstrap contracts, typed plan и runner, отдельные реальные шаги logging/navigation; binding запуска через AppBootstrap. До runApp — минимальная platform preparation и logging; после оболочки — подготовка navigation/application session.
- ApplicationBootstrapPlan.create возвращает BootstrapPlan<AppNavigationSession> из конкретных InitializeLoggingStep/InitializeNavigationStep; готовая navigation session передаётся TournamentApp и принадлежит BootstrapSession, а не создаётся повторно widget. Ранний диагностический BootstrapLogger может быть создан composition root до runner; logging-step готовит application loggers без циклической зависимости собственного запуска от результата шага.
- App BootstrapGate наблюдает runner; presentation BootstrapScreen получает только состояние/callback. Добавить локализованные конкретные причины ошибки, безопасный Retry, изоляцию готового приложения до Ready. UI-параметры идут через существующую тему/DS; scenarios/goldens обновляются только по фактической UI-правке.
- В будущем backend представлен отдельным обязательным typed step. Сейчас тесты используют управляемый внешний источник и показывают реальные механизмы отказа/повтора; production HTTP endpoint, auth, protocol, version policy не выдумываются.
- Scope/bootstrap cancellation, cache валидных результатов в памяти, безопасное продолжение, очистка попыток/ресурсов, typed bootstrap logging.
- Не входят persistent checkpoints после process restart, DAG/параллельный scheduler, автоматические бесконечные retries, реальное remote logging и новая business-domain логика.

## Применимые правила

Прочитаны context README/router, core R-001/002/004/007/008.a/b/009 и workflow; все Flutter R-003.a–h, R-005, R-006.a–d применяются к планируемому Flutter scope, conditional rules отсутствуют. R-001: шаги/runner/wiring разделены; R-002: canonical решение в docs при implementation; R-004: typed inputs/outputs/phases/failures, без string dispatch/dynamic registry; R-007: tests и обязательный gate. R-009: общий scope, late results, cleanup и ownership. R-003.a/b/f: orchestration в app, screen не запускает бизнес/инициализацию, presentation не импортирует app. R-003.e/g: package imports, функции в классах. R-005/006/003.d: локализованная ошибка, DS/theme, named callbacks и актуальные goldens/Widgetbook при изменении UI.

## Контракты specification1

- BootstrapPlacement: beforeApplication / afterApplication. Во второй фазе все шаги обязательны: Ready только после успеха всего плана.
- BootstrapStep<Input, Output>: placement и start(Input) → OperationRequest<BootstrapResource<Output>>. Реализация и зависимости — отдельный class/file. Тип шага идентифицируется Type в diagnostics/state; порядок не задаётся строковыми ключами.
- BootstrapPlan.seed(initial).then(step) сохраняет generic связь выхода предыдущего шага со входом следующего. Результаты принадлежат typed узлам плана; общего mutable context/map/service locator нет. Runner отвергает beforeApplication шаг после afterApplication до любых side effects (BootstrapPlanException).
- BootstrapResource<Output>: value, идемпотентный close и проверка isValid. Для чистого значения cleanup необязателен. Это lease владения, отдельный от operation start/cancel: успешная инициализация не прекращает жизнь созданного сервиса.
- BootstrapRunner<Output>: state, runBeforeApp(), runAfterApp(), retry(), close(). BootstrapState<Output> sealed: idle/running/awaitingApplication/failed/restartRequired/ready/cancelled. Running содержит stepType и placement; Failed содержит stepType, typed failure и canRetry. Running attempts не выполняются одновременно; одинаковая активная команда/Retry разделяет одно ожидание.
- BootstrapStepException хранит BootstrapFailureReason (dependencyUnavailable / timedOut / incompatibleVersion / unexpected) и retryAllowed. Неожиданный throw преобразуется в unexpected с исходными error/stackTrace, а не исчезает из error diagnostics. UI показывает перевод причины, не raw exception.
- runAfterApp до успешной pre-фазы отклоняется BootstrapPhaseException, не запускает шаги. Повторный runAfterApp после Ready не создаёт вторую application session.
- Post-app retry сохраняет валидные успешные результаты; сначала завершает cleanup неуспешной попытки через идемпотентный abort/onCancel, затем повторяет упавший шаг и продолжает suffix. Non-retryable failure не запускается повторно. Нажатия Retry во время текущей попытки не открывают параллельную инициализацию.
- При retry заново проверяется валидность сохранённых ресурсов: invalid post-app ресурс и зависимый suffix очищаются в обратном порядке и повторяются; valid prefix сохраняется. Проверка isValid — контракт владельца ресурса, не универсальная доказанная проверка доступности сервера.
- Фазовая граница: invalid pre-app ресурс после запуска оболочки даёт BootstrapRestartRequired и не повторяет pre-step незаметно в post-фазе. Нужна новая bootstrap attempt с новым runner/планом. Pre-app failure также не обещает безопасный in-place retry; минимальная fallback оболочка показывает явную ошибку/необходимость нового запуска, если Flutter binding доступен. Повторяемость и продолжение обязательны именно для post-app шагов, как запросил пользователь.
- Во время failure валидные успешные resources сохраняются для продолжения. При close до Ready освобождаются в обратном порядке; сбой одного cleanup не пропускает остальные и доступен через OperationCleanupException.errors. Pending run получает Cancelled до конца cleanup. Late success отменённого источника не доставляется, но полученный поздно resource lease закрывается, late error наблюдается.
- После Ready ресурсы переданы BootstrapSession<Output>. Runner.close не освобождает работающую сессию; session.close закрывает принадлежащие ей ресурсы ровно один раз в обратном порядке. Нельзя одновременно считать runner и приложение владельцами одного release.
- BootstrapGate<Output> живёт в app и получает runner + readyBuilder(BuildContext, BootstrapSession<Output>). Родитель обеспечивает Theme/localizations. Gate запускает post-фазу только после подготовки pre; generic BootstrapScreen ничего не знает о runner/app. На failure dependencyUnavailable UI явно сообщает недоступность сервиса; retry callback недоступен во время выполнения и при non-retryable failure.
- BootstrapLogger = Logger<BootstrapLogEvent>, scope bootstrap. События stepStarted/stepSucceeded/stepFailed/retrying/cancelled/ready с подробностями шага/фазы/ошибки. Сбой logging не меняет запуск; поздний результат отменённого шага не даёт stepSucceeded/ready.

## Acceptance Criteria

- [x] AC1: typed plan/steps сохраняют входы/выходы; phases исполняются в явном порядке без action map.
- [x] AC2: обязательный post-step failure блокирует Ready и зависимые шаги; typed cause и failed step доступны UI/диагностике.
- [x] AC3: Retry продолжает с failure, сохраняет valid prefix, завершает abort прежней попытки и исключает конкурентный повтор; non-retryable ошибка не перезапускается.
- [x] AC4: invalid post-checkpoint повторяется с suffix; invalid pre-checkpoint требует новую attempt без нарушения фазовой границы.
- [x] AC5: отмена завершает ожидания, подавляет late callbacks, освобождает поздний lease; cleanup reverse/idempotent и сообщает ошибки, не пропуская ресурсы.
- [x] AC6: Ready передаёт единственного владельца ресурсов application session; повторная команда не создаёт вторую сессию.
- [x] AC7: реальный BootstrapGate показывает loading/конкретную ошибку/повтор, скрывает приложение до готовности, non-retryable не имеет активного Retry. Presentation не импортирует app.
- [x] AC8: реальные logging/navigation steps включены в новый AppBootstrap flow, bootstrap logs типизированы; текущий Widgetbook entry не получает product bootstrap/network.
- [x] AC9: релевантные tests/negative type probe/analyzer/architecture, новые локализации и затронутые golden/scenarios проходят; docs отражают ограничения.

## Test Scenarios

Unit runner: phases, malformed order, обязательный failure, retry/cached prefix, double retry, non-retryable, unexpected exception, invalid checkpoints, close/late result/late error, reverse cleanup с ошибкой, resource transfer, progress/logging. Проверяется настоящий BootstrapRunner; fake только внешние resources/initialization sources, не алгоритм продолжения.

Widget integration: настоящий BootstrapGate и BootstrapScreen в MaterialApp с общей темой/intl. Управляемое ожидание backend: loading → явная ошибка → Retry → Ready; duplicate taps, disabled retry, non-retryable и pre-app fallback. Нет live network/случайных задержек; только Completer и ограниченный pump (не pumpAndSettle бесконечного индикатора).

## Implementation Plan

1. Baseline116 navigation/logging/operations + existing bootstrap screen tests. Создать executable runner и gate tests без production stubs. Подтвердить compile RED и остановиться на human gate.
2. После approval: контракты в app/bootstrap, typed plan nodes, runner/scope/resource/session/failure models; class-owned step implementations и реальный AppBootstrap wiring. Не встраивать алгоритм в UI и не превращать план в файл implementations.
3. App-gate + presentation mapper/state/localizations. Существующий BootstrapScreen остаётся независимым; готовый TournamentApp получает session зависимости и не дублирует ownership. Обновить Widgetbook/scenarios/goldens по фактическим визуальным изменениям.
4. Typed BootstrapLogger и actual lifecycle logs. Generic source timeout передаётся шагом типизированно; новые timers не имитируют backend доступность.
5. Runtime tests, типовой negative probe соединения несовместимых step outputs/inputs, analyzer/architecture/fixtures/rules/links/format; canonical docs/architecture/bootstrap.md и ссылки. Никаких build/run/commit/push без отдельного запроса.

## Test Evidence

2026-11-11, cwd apps/tournament_app:

- `flutter test --no-pub test/infrastructure/logging test/app/logging test/app/navigation test/presentation/operations test/presentation/screens/bootstrap --reporter expanded` —BASELINE_GREEN:119 PASS, exit0. Включает116 logging/navigation/operations и3 прежних BootstrapScreen scenarios (mobile/desktop goldens сравнивались без update).
- `flutter test --no-pub test/app/bootstrap/bootstrap_test.dart --reporter expanded` —ожидаемый compile RED, exit1:1 library failed loading. Отсутствуют app/bootstrap ApplicationBootstrapPlan, runner/plan/step/resource/session/state/failure/gate API, BootstrapLogEvent и новые локализованные сообщения screenBootDependencyUnavailable/screenBootIncompatibleVersion. Нет unrelated syntax failure, runtime stubs не создавались.25 executable scenarios (21 unit/integration +4 widget) пока не выполнялись; это не25 behavioral failures.
- Подробный stdout сохранён локально в ignored .dart_tool/task111-red.log и task111-baseline.log. Первичный RED24 сценариев и повторный финальный RED25 после добавления production plan integration подтвердили ту же ожидаемую причину.
- `dart format test/app/bootstrap/bootstrap_test.dart` —exit0. Root node tools/check_rules.cjs —20 leaf/3 группы PASS, git diff --check —exit0. Full analyzer/architecture нового API до implementation не объявляется GREEN.

## Approval

2026-11-11, пользователь: «делаем». Подтверждены specification1/plan1/test set1 после25 подготовленных сценариев с compile RED отсутствующего capability и baseline119 PASS. Записано до первого production-изменения.

## Открытые вопросы и ограничения

- Реального backend endpoint/auth/version protocol нет: не блокирует tests механизма, но блокирует утверждение о настоящем backend handshake в production. Он реализуется отдельным шагом при появлении контракта.
- Pre-app invalidation требует новой attempt; сохранение checkpoints между process restarts не реализуется.
- Для UI/goldens использовать текущую нативную ОС. Запуск приложения/сборки ранее запрещены и сейчас не требуются.

## Changelog

### 2026-11-11 · Запросы и постановка

> делаем коммит и знаешь о чем хочется подумать дальше.
> Приступаем к запуску приложения. Нужен типизированный Botstrap где каждый шаг bootstrap это типизированный элемент, а не простая мапа с действиями. Я хочу иметь максимальный контроль над bootstrap и не преваритть это в один файл с 1000 инициализаций

> нужно еще понимать что у нас могут быть шаги перед инициализацией приложения и после ее. Те что после должны быть защещены и иметь возможность повторяться и продолжаться. Например для ситуации когда мы ждем бекенд, и он нам явно нужен для запуска, без него запуститься нельзя и нужно выдать явную ошибку пользователю

> заведи задачу и тесты

- Зарегистрирована111, scope CODE/test-first. До начала git status чистый, последний коммит a98e8ec. Изучены AppBootstrap, TournamentApp, AppNavigationSession, existing BootstrapScreen и общий OperationScope. Существующей машины bootstrap нет.
- Технические решения в утверждённых границах: линейный generic plan, кеш в typed nodes, leases успешных ресурсов, retry только защищённых post-app steps; непереносимость pre-app шага через runApp явно отражена как restartRequired. План показан пользователю до tests. Новые production API пока отсутствуют.
- Добавлен test/app/bootstrap/bootstrap_test.dart:25 executable cases, fake только внешние initializer/resources.21 unit/integration охватывают механизм и реальный ApplicationBootstrapPlan.create;4 widget cases — настоящий будущий BootstrapGate + существующий BootstrapScreen. Typed timeout проверяется как причина отказа, а не как уже реализованная HTTP timeout-механика.
- Baseline119 PASS; final compile RED подтверждён отсутствующим planned API/локализацией. Stage RED_CONFIRMED → AWAITING_APPROVAL. Не создавались production папки/заглушки, новые backend/config/network зависимости, UI/golden baselines. Нет build/run/commit/push.
- Финально: dart format --output=none --set-exit-if-changed теста —exit0,0 changes; локальные Markdown-ссылки карточки и git diff --check —PASS. После коммита110 изменены только список задач, новая карточка111 и тестовый файл.

## Итог

Реализованы typed bootstrap plan, две фазы, безопасный retry/resume, ресурсы и готовая session, app-gate, актуальный main/bootstrap path и два реальных production шага logging/navigation. Настоящего backend transport нет; он не выдаётся за реализованный. Пройдены30 bootstrap tests, общий suite330 PASS/1 штатный SKIP и отдельный post-refactor набор38 bootstrap/golden PASS; analyzer/architecture и финальные структурные проверки чистые. Stage DONE. Build/run/commit/push не выполнялись.

## Changelog · Approval

> делаем

- Пользователь подтвердил test set1. Stage IMPLEMENTING до runtime. Typed узлы хранят свои результаты, scheduler видит общий интерфейс выполнения без map/dynamic lookup. Владение lease и cancel pending source разделяются; после Ready ресурсы принадлежат BootstrapSession. Не добавлять настоящий HTTP endpoint и не менять утверждённые тесты ради GREEN.

## Changelog · Реализация и GREEN

- Созданы17 app/bootstrap файлов contracts/plan/attempt/runner/ownership/mapper/gate/application/steps; реализации logging/navigation в отдельных steps. В AppBootstrap оставлен короткий composition flow, main теперь возвращает Future<void>. До runApp — binding/logging, после runApp — navigation; готовая session передаётся TournamentApp извне.
- Generic plan связывает Input/Output в private typed nodes без dynamic/value lookup. Scheduler видит общий интерфейс lease acquisition. Одноразовое владение plan проверяется marker-объектом, не удерживающим runner после transfer. Авторитет lifecycle — closing Future, state и OperationScope; новых bool disposed/closed нет.
- Успешные ресурсы сохраняются для retry, invalid post-prefix очищается с suffix, invalid pre-ресурс даёт restartRequired. BootstrapAttempt ждёт abort, обрабатывает поздние ошибки и закрывает orphan lease. При Ready session становится единственным владельцем; cancellation Future и resource lifetime не смешаны.
- Ранний логгер подключён до runner; добавлены BootstrapLogEvent/BootstrapLogger/LogScope.bootstrap и независимый bootstrapSink в AppLoggers. Сохранилась совместимость существующей navigation/network сборки. Step logs содержат тип, placement, duration и error/stack.
- Первое runtime-компилирование выявило ошибку generic static _release: исправлено на собственный generic parameter без изменения публичного контракта. Unit часть прошла сразу после исправления. Widget test зависал в addTearDown на Future, созданном в fake-async зоне: диагностические debugPrint добавлялись временно и полностью удалены. Механическая правка tests — cleanup теперь ожидается в теле widget test, где жив fake clock; assertions не ослаблены, добавлено подтверждение resource release.
- Утверждённые25 scenarios после этого прошли. В рамках прежних AC5/6/8 добавлены5 regressions: dispose→close, reentrant close из progress, один owner плана, ожидание abort cleanup после Cancelled, настоящий BootstrapApplication host и освобождение его session. Итог30 bootstrap PASS, exit0.
- После analyzer must_call_super замечания runner переведён с наследования ChangeNotifier на композицию приватного ValueNotifier и Listenable. Это сохраняет public state/listener API; dispose делегирует close, повторные pending callbacks не меняют закрытое состояние. Suppressions не добавлялись. Повторно все30 bootstrap и8 golden scenarios —38 PASS.
- Presentation BootstrapProblem +5 intl messages; flutter gen-l10n выполнен (не build), generated getters не правились вручную. Screen продолжает использовать текущую тему/DS; нет raw styles, UI не получает app imports. Non-retryable не показывает лишнюю кнопку Retry; retry-in-progress disabled.
- Добавлены5 отдельных Widgetbook use-case папок; общие fixtures используются golden tests. Update capture8 сценариев mobile/desktop на Windows —8 PASS; прежние6 PNG неизменны, добавлены10 Windows baseline. Затем сравнение без --update-goldens прошло. Просмотрены и показаны mobile dependency-unavailable и desktop restart-required; переполнений нет. macOS/Linux для новых PNG не проверены и не подменялись.
- Negative type probe .dart_tool/task111_type_probe.dart отверг BootstrapPlan<String>.seed('seed').then(IntegerStep()) с COMPILE_TIME_ERROR/ARGUMENT_TYPE_NOT_ASSIGNABLE, exit1; это целевая несовместимость Input, не отсутствующий API. Временный файл удалён.
- Полный `flutter test --no-pub --reporter expanded` —330 PASS/1 штатный SKIP external visual comparison CLI, exit0. После внутреннего lifecycle-refactor дополнительно `flutter test --no-pub test/app/bootstrap test/presentation/screens/bootstrap --reporter expanded` —38 PASS без golden update. Исходные logging/navigation/operations и Widgetbook workbench/viewports входят в общий успешный прогон.
- Финальный flutter analyze --no-pub —No issues found. Cwd tools/domain-check: полный scan617 файлов —0 нарушений, navigation32 PASS/readability41 PASS/top-level49 PASS/theme35 PASS/self-test51 PASS, все exit0. Новых AST exceptions нет.
- Canonical docs/architecture/bootstrap.md описывает фактический flow и все ограничения; обновлены README/layer-boundaries/logging links. DTD listDtdUris не нашёл debug/DTD процессов; hot reload недоступен, приложение не запускалось. Build/commit/push не выполнялись.
- Финальные node tools/check_rules.cjs —20 leaf/3 группы PASS; git diff --check —exit0; локальные Markdown-ссылки task/docs/README —PASS. dart format --output=none --set-exit-if-changed47 runtime/test файлов —exit0,0 changes. Целевой scan bool disposed/closed/closing в новом bootstrap —совпадений нет. Stage VERIFYING → DONE, задача111 закрыта.

## Final Verification

- [x] AC1–9 подтверждены; approval записан до runtime, тесты не ослаблены.
- [x] Baseline119, bootstrap30, полный suite330/1 штатный skip и post-refactor38 GREEN; negative type probe ожидаемо отклонён.
- [x] Analyzer и архитектурные fixtures/scan прошли; новых dependencies и checker exemptions нет.
- [x] Windows mobile/desktop goldens сформированы, просмотрены, показаны и сравнены без update; другие ОС не объявляются проверенными.
- [x] Canonical docs и история актуальны; неизвестный backend-контракт не подменён фиктивным live вызовом; блокеров в текущем scope нет.

## Итерация2 · Подпись текущего шага

### Prompt пользователя

> да давай будем отображать текущий шаг. Полный список не нужен. А шаги до runApp естественно не нужно показывать ведь ui еще нет

### Scope и plan2

- Переоткрыта111 без нового номера: та же цель bootstrap, уточнение отображения. Runner/plan/step contracts, данные ресурсов, выполнение и guards не меняются. Визуальный mapper уже получает Type/placement — добавляется только optional presentation-label, без новых business/technical operation semantics. По workflow чистое отображение NOT_REQUIRED; исходный approval логики не переписывается.
- Presentation enum BootstrapCurrentStep (navigation/component) и optional currentStep в BootstrapScreenState. App mapper даёт navigation для реального InitializeNavigationStep, безопасный component для неизвестного app-шага. Classname и Type.toString не используются как пользовательский текст; новые production шаги получают явный localized mapping при добавлении.
- Под существующим индикатором generic preparing-текст заменяется localized подписью текущего post-app шага; semantics индикатора использует ту же подпись. При beforeApplication currentStep отсутствует. На ошибке остаётся конкретная причина отказа, без списка прошедших/будущих шагов и без устаревшей loading-подписи.
- Использовать существующие BootstrapScreenTheme и layout; новых raw UI значений нет. Добавить shared Widgetbook/golden cases для navigation loading/retrying и неизвестного компонента.
- Проверки: актуальные bootstrap runtime/widget tests, сравнение старых/new Windows goldens после capture, intl generation, analyzer, архитектура/формат/ссылки. Не повторять весь suite без причины; UI-only scope не затрагивает остальные flows. Build/run/commit/push не выполняются.

### Критерии итерации2

- [x] AC10: post-app current step отображается локализованно, без технического имени класса и полного списка.
- [x] AC11: pre-app подписи не выводятся; ошибка и Ready не сохраняют прежнюю running-подпись.
- [x] AC12: Widgetbook, native goldens, docs и выбранные проверки согласованы; runner логика не менялась.

### Changelog итерации2 · Реализация и проверки

- Добавлен optional BootstrapCurrentStep в presentation DTO (navigation/component) и intl-подписи. Mapper выбирает label только для Running.afterApplication; реальный InitializeNavigationStep получает navigation, неизвестный тип — общий component без угадывания classname. Остальные состояния сбрасывают label. BootstrapRunner/Plan/Step/Gate lifecycle и их технические контракты в этой итерации не менялись.
- BootstrapScreen заменяет существующий generic preparing-текст подписью текущего шага; семантика индикатора использует тот же текст. Новых visual parameters/raw styles/дополнительного списка инициализаций нет.
- Добавлены3 isolated Widgetbook cases и shared golden builders: preparing-navigation/retrying-navigation/preparing-component. Capture Windows mobile390/desktop1440 —11 scenarios PASS;6 новых PNG, прежние baselines неизменны. Просмотрен и показан mobile preparing-navigation.
- Existing Gate retry test дополнен проверкой текущего component label и его исчезновения при ошибке. Новый visual widget test проводит реальные app state snapshots через mapper и screen: production navigation label виден, Class Type text/pre-app label отсутствуют. Первый compile теста нашёл неверное статическое обращение Type.toString; исправлено на локальный Type value без изменения ожидания. Bootstrap suite31 PASS.
- Сравнение без update + bootstrap lifecycle:42 PASS (31 bootstrap +11 native golden), exit0. Architecture scan620 файлов —0 нарушений. Первичный analyzer сообщил1 curly_braces info в visual mapper; исправлено без ignore, итоговая проверка следует ниже.
- Итог: flutter analyze — No issues found; формат19 файлов без изменений; registry check —20 leaf/3 группы согласованы; git diff --check без ошибок. Все зарегистрированные use cases открыты в реальном Widgetbook workbench —1 PASS. AC10–12 выполнены, итерация закрыта. Build/run/commit/push не выполнялись.

### Changelog · Коммит задачи

> делаем коммит задачи и посмотри коммиты до, они почему то стали на русском, хотя должны быть на англиском по примеру проекта

- Проверена история: последние пять commit subjects были на русском, предыдущие используют английский Conventional Commits. Для этой задачи и последующих сообщений применяется английский стиль; требование русской документации не распространяется на commit messages. Предыдущая история не переписывается.
- Подготовлен единый коммит задачи111: typed startup, recovery/lifecycle, bootstrap logging, экран текущего post-app шага, тесты, Windows goldens и документация. Повторные runtime-проверки не нужны: код с последней успешной проверки не менялся; hot reload выполнен успешно. Перед коммитом проверяется staged diff; push не выполняется.
