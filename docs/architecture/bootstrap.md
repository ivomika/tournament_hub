# Типизированный bootstrap приложения

## Решение

Задача111, решение2026-11-11: запуск состоит из отдельных BootstrapStep<Input, Output>, объединённых в типизированный последовательный план. UI-оболочка может уже работать, пока обязательные шаги ещё не завершились. Готовое приложение показывается только после BootstrapReady.

Действующий production plan состоит из InitializeLoggingStep до runApp и двух шагов после создания оболочки: InitializeProfileStep читает локальный профиль и передаёт ProfileBootstrapContext; InitializeNavigationStep создаёт навигацию с HomeRoute или RegistrationRoute по заполненности. Чтение профиля имеет собственную подпись/ошибку/retry. Контракт задачи112: [локальный профиль](local-profile-registration.md). Реального backend handshake пока нет: endpoint/auth/protocol не определены. Обязательный backend и его отказ/повтор проверены управляемыми внешними источниками в тестах настоящего runner и gate. Это подтверждает механизм, а не доступность сервера.

```text
main → AppBootstrap.run
         → WidgetsFlutterBinding.ensureInitialized
         → ранний BootstrapLogger
         → runner.runBeforeApp
         → runApp(BootstrapApplication)
                   → BootstrapGate → runner.runAfterApp
                       ├─ Running/Failed → BootstrapScreen
                       └─ Ready(session) → TournamentApp(navigation: session.value)
```

Future AppBootstrap.run завершается после передачи запуска Flutter-оболочке, а не является подтверждением Ready. Результат post-фазы доступен через runner state и Future команды runAfterApp.

## Ответственности и расположение

| Компонент | Область | Назначение |
| --- | --- | --- |
| AppBootstrap | app/bootstrap.dart | Минимальная platform preparation, pre-фаза и запуск root widget |
| ApplicationBootstrapPlan | app/bootstrap/application_bootstrap_plan.dart | Только явная композиция реальных шагов |
| BootstrapStep<Input, Output> | app/bootstrap/bootstrap_step.dart | Контракт отдельной инициализации с placement и отменяемым start |
| InitializeLoggingStep / InitializeNavigationStep | app/bootstrap/steps | Реализации механик, каждая в отдельном файле |
| BootstrapPlan<Output> | app/bootstrap/bootstrap_plan.dart | Generic цепочка и кеш typed outputs в собственных узлах |
| BootstrapPlanStep / BootstrapAcquisition | app/bootstrap/bootstrap_plan_step.dart | Общий интерфейс scheduler без извлечения значения по ключу |
| BootstrapRunner<Output> | app/bootstrap/bootstrap_runner.dart | Фазы, команды, защита от конкуренции, retry и владение попыткой |
| BootstrapAttempt | app/bootstrap/bootstrap_attempt.dart | Общая граница start/abort/late lease |
| BootstrapResource<Value> | app/bootstrap/bootstrap_resource.dart | Идемпотентный lease успешного ресурса и его валидность |
| BootstrapSession<Value> | app/bootstrap/bootstrap_session.dart | Владелец готовых ресурсов приложения |
| BootstrapResources | app/bootstrap/bootstrap_resources.dart | Обратная очистка и сбор всех cleanup errors |
| BootstrapApplication / BootstrapGate | app/bootstrap | App wiring, наблюдение и lifecycle root UI |
| BootstrapPresentationMapper | app/bootstrap | Преобразование app state в presentation DTO без обратного импорта |
| BootstrapScreen | presentation/screens/bootstrap | Детерминированное отображение state/callback, без запуска runner/services |

Новые механики не добавляются в AppBootstrap.run. План содержит вызовы then конкретных шагов, а их тела остаются в steps. При росте плана статические методы могут принимать и возвращать BootstrapPlan<T> для композиции typed фрагментов; общий изменяемый context/service locator не нужен.

## Типизированная композиция

```dart
BootstrapPlan.seed(const BootstrapStart())
    .then(InitializeLoggingStep(loggers: loggers))
    .then(const InitializeNavigationStep());
```

Выход предыдущего шага определяет вход следующего. Конструкция BootstrapPlan<String>.seed('seed').then(IntegerInputStep()) с BootstrapStep<int, int> не проходит статическую проверку. Нет map с действиями, string dispatch, dynamic registry или cast результата по имени шага.

План хранит generic узлы с конкретным BootstrapResource<Output>. Scheduler видит только метаданные, start и операции фиксации/очистки lease. Он не получает Object-словарь результатов. В progress/logging шаг идентифицируется своим Type. Plan одноразовый: узлы получают маркер владельца; второй runner с теми же узлами отклоняется до выполнения. Маркер не удерживает сам runner через работающую application session.

## Фазы и команды

BootstrapPlacement имеет beforeApplication и afterApplication. Все before-шаги идут раньше after-шагов; неверный порядок даёт BootstrapPlanException до side effects. Сам Flutter binding инициализируется раньше runner: без него нельзя обещать показ ошибки средствами Flutter.

- runBeforeApp выполняет только pre-фазу и возвращает BootstrapAwaitingApplication либо типизированный отказ.
- runAfterApp допустим после подготовки; до неё даёт BootstrapPhaseException, а не запускает post-шаги.
- retry продолжает отказ post-фазы; при активной попытке возвращает её же Future. Non-retryable отказ остаётся тем же отказом.
- Повторный runAfterApp после Ready возвращает прежнюю session, не создаёт второй router.
- close отменяет текущую работу; синхронный dispose делегирует тому же close и наблюдает ошибку cleanup через Zone handler.

Runner реализует Listenable композицией с приватным ValueNotifier. Снаружи state доступен только для чтения. Отдельных bool isDisposed/isClosed нет: авторитет закрытия — один Future, авторитет выполнения — BootstrapState и текущая команда. Это не означает отсутствия lifecycle-состояния внутри механизма.

## Состояния и явные ошибки

BootstrapState<Output> имеет Idle, Running, AwaitingApplication, Failed, RestartRequired, Ready и Cancelled. Running содержит текущий Type шага, placement и initial/retry. Failed содержит исходный error/stackTrace и BootstrapFailureReason:

- dependencyUnavailable — обязательный сервис недоступен;
- timedOut — источник сообщил истечение времени ожидания;
- incompatibleVersion — несовместимый контракт/версия;
- unexpected — непредвиденное исключение.

BootstrapStepException позволяет шагу явно задать причину и retryAllowed. Обычный throw сохраняется как unexpected с исходным объектом и стеком. Runner не вводит глобальный фиктивный network timeout: срок и остановка реального handshake принадлежат реализующему его шагу/адаптеру.

Presentation получает BootstrapScreenState с BootstrapPhase и BootstrapProblem. Текст причины выбирается через intl, raw exception в UI не показывается. Ошибка сервиса предлагает Retry; incompatible/restart состояния имеют конкретное объяснение без бесполезной активной кнопки повтора. При retry кнопка недоступна и показан индикатор. Screen не импортирует app, не получает DI или runner.

Под индикатором отображается только текущий post-app шаг. Optional BootstrapCurrentStep в presentation DTO задаётся app-маппером для BootstrapRunning.afterApplication: InitializeProfileStep отображается как «Загружаем профиль…», InitializeNavigationStep — «Подготавливаем экраны…». Для неизвестного нового типа есть безопасная общая подпись «Подготавливаем компонент…», а не имя Dart-класса. При добавлении production-шага нужно явно добавить его UI enum/intl mapping; техническое Type.toString остаётся только в диагностике. Loading-текст и semantics индикатора используют одну локализованную подпись. Полный список шагов не выводится.

BeforeApplication не получает UI-подпись: в production root runApp ещё не вызывался. В начальном ожидании без текущего шага остаётся общий loading-текст. Failed/RestartRequired/Cancelled не удерживают прежнюю running-подпись, а Ready заменяет весь bootstrap экран приложением. Runner, контракты шагов и механизм retry ради этого отображения не менялись.

## Продолжение и контрольные точки

Успешные результаты хранятся в typed узлах текущего процесса. При post-отказе они остаются живыми для продолжения; автоматически закрывать весь prefix нельзя, иначе продолжение станет повторной полной инициализацией.

Перед retry проверяется isValid успешных leases. Валидный prefix сохраняется. Первый invalid post-lease и его зависимый suffix освобождаются в обратном порядке, затем выполняются заново. Failed attempt сначала проходит abort, только после его завершения допускается следующая попытка. Повторные команды разделяют одно ожидание, в том числе пока abort ещё не завершился.

isValid — синхронный snapshot ресурса, не универсальная проверка связи с сервером. Асинхронная readiness-проверка должна быть отдельным шагом. Непрерывная доступность backend после Ready — ответственность приложения/сервиса, не скрытый бесконечный bootstrap loop.

Invalid pre-lease после запуска оболочки означает RestartRequired: pre-step не переносится незаметно через runApp. Нужна новая попытка с новым планом/runner. Pre-отказ также не обещает безопасный in-place retry: минимальная fallback оболочка показывает необходимость нового запуска, если Flutter binding доступен. Автоматический process restart и checkpoints между перезапусками не реализованы.

## Попытки, отмена и ресурсы

start возвращает OperationRequest<BootstrapResource<Output>>. Это два разных lifecycle: pending инициализация и жизнь успешного сервиса. onCancel должен идемпотентно очищать незавершённую либо неуспешную попытку; синхронный throw до возвращения handle требует очистки уже выделенных ресурсов внутри самого шага.

BootstrapAttempt — общее место abort и гонки поздней доставки. Его результат наблюдается через owner OperationScope. При закрытии run получает Cancelled до завершения cleanup, а close ждёт abort и очистку известных leases. Поздняя ошибка не меняет state, поздний успешный lease закрывается вместо передачи закрытому владельцу. Неотменяемый источник может продолжить работу; это не объявляется rollback. Ошибка cleanup lease, пришедшего уже после завершения close, передаётся Zone error handler: завершённый ранее close Future не меняется задним числом.

До Ready runner владеет успешными ресурсами и закрывает их в обратном порядке. Сбой одного release не пропускает остальные; OperationCleanupException содержит собранные ошибки. Если abort failed attempt тоже упал, сохраняются исходная причина и cleanupErrors; повтор такой попытки запрещается, чтобы не дублировать незавершённые ресурсы.

После Ready владение передаётся BootstrapSession. Runner.close уже не освобождает сервисы работающего приложения. Session.close идемпотентно освобождает их в обратном порядке. BootstrapGate при unmount снимает listener и закрывает runner/session; TournamentApp получает navigation извне и не создаёт/не освобождает её повторно. При standalone использовании TournamentApp прежний optional fallback сохранён; production main использует новый bootstrap path.

Cleanup не должен ожидать завершения своего владельца, создавая цикл close → abort → close. Применяется [R-009](../../ai-context/rules/core/009-cancellable-async.md); добавлять ручные lifecycle-флаги в каждый шаг не требуется.

## Логирование и UI-проверки

BootstrapLogger — Logger<BootstrapLogEvent>, отдельный LogScope.bootstrap. AppLoggers допускает независимый bootstrapSink, по умолчанию PrintLogSink; ранний bootstrap logger собирается composition root до runner, не ждёт logging-step. События: stepStarted, stepSucceeded, stepFailed, retrying, cancelled, ready. Записи содержат Type шага, placement, длительность и доступную ошибку/stack. Поздний cancelled source не даёт stepSucceeded/ready. Сбой стандартного logging adapter не влияет на state.

Widgetbook и goldens используют BootstrapFixture и общие use cases: loading, error, retrying, dependency-unavailable, timed-out, incompatible-version, restart-required, cancelled. Новые ошибки покрыты mobile390 и desktop1440 на Windows. Старые6 PNG не изменились; добавлены10 Windows baseline, macOS/Linux не подменялись и для новых сценариев требуют собственного нативного capture.

Продолжение задачи111 добавило preparing-navigation, retrying-navigation и preparing-component: ещё6 Windows PNG на тех же двух viewport. Они используют тот же BootstrapFixture с optional currentStep. Вывод подписи проверяется реальным rendering через BootstrapPresentationMapper и BootstrapScreen; pre-app и classname не показываются. Логический lifecycle первого среза остаётся покрыт прежними30 tests; с новой visual rendering-проверкой bootstrap suite содержит31 case, golden suite11 cases.

Новых визуальных токенов не вводилось: используются существующие BootstrapScreenTheme и DS. Конкретная ошибка, защищённый Retry и передача управления готовому app проверены widget tests настоящего Gate. Проверка реального app host подтверждает создание TournamentApp после Ready и освобождение navigation после unmount.

## Фактическая проверка и ограничения

- До реализации:119 baseline PASS и compile RED отсутствующего bootstrap API/локализаций.
- Утверждённые25 scenarios пройдены; дополнены5 lifecycle/host regressions в тех же критериях —30 bootstrap PASS.
- Полный Flutter suite:330 PASS,1 штатный SKIP внешнего visual comparison CLI. После внутреннего перехода runner на композицию дополнительно пройдены38 bootstrap/golden cases без update; analyzer чистый.
- Static negative probe подтвердил ARGUMENT_TYPE_NOT_ASSIGNABLE для несовместимых шагов; временный файл удалён.
- Полный архитектурный scan617 файлов и regression fixtures без нарушений. Реальные build/run не выполнялись; запущенного debug-процесса для hot reload нет.

Настоящие backend/auth шаги добавляются при появлении их контрактов. Локальный storage/profile уже подключён задачей112. Текущая готовность означает успех logging/profile-read/navigation production plan, а не выполненную неизвестную backend-проверку; заполнение отсутствующего имени затем выполняется на защищённом экране регистрации.
