# 110. Типизированное логирование по scope

## Статус и этап

✅ Выполнено · Mode CODE · TestGate REQUIRED: новый контракт и техническая логика.
Stage DONE. Specification1, plan1, test set1 с уточнением оформления вывода.
Процесс: [workflow](../workflow.md).

## Цель и контекст

Код передаёт типизированные события через общий Logger, не выбирает способ вывода. Конечный адаптер сейчас вызывает print. Navigation и network получают отдельные логгеры и независимо выбранные sinks: локальные navigation-логи не требуют отправки network-логов в тот же output.

Исходные данные: [границы слоёв](../../docs/architecture/layer-boundaries.md), текущий AppNavigationSession/NavigationCoordinator. Логирования и infrastructure-реализации в lib пока нет. Domain содержит только TournamentId; HTTP-клиент ещё отсутствует.

## Scope и non-goals

- Domain: чистые диагностические контракты Logger<Event extends LogEvent>, LogEvent/LogScope, LogRecord, LogLevel, LogSubmissionResult, NavigationLogger и NetworkLogger с разными enum событий.
- Infrastructure: LogSink как техническая граница вывода, SinkLogger как общая реализация domain Logger, PrintLogSink как конечный адаптер и formatter. Никаких библиотечных типов в domain.
- App: AppLoggers связывает отдельные navigationSink/networkSink; консольная factory для текущего запуска. Текущая навигация получает NavigationLogger через constructor injection; AppNavigationSession использует консоль по умолчанию.
- Не входят HTTP-клиент, настоящий remote sink, очереди/ретраи доставки, persistence, UI, массовая инструментация экранов. Generic network logger готов, но не выдаётся за уже существующий network pipeline.
- Не менять матрицу слоёв. В этой задаче логгер потребляет app-навигация; direct logging из widgets/state не добавляется и R-003.b не обходится. Логирование — техническая диагностика, не новый business use case.

## Применимые правила

Прочитаны context README/router, core R-001/002/004/007/008.a/b/009, все Flutter R-003.a–h, R-005, R-006.a–d и workflow. Conditional rules отсутствуют. R-001/003.c: общий контракт отдельно от output adapter; R-002: решение документируется; R-004: scope/event/level/result типизированы, нет string routing; R-007: tests first и gate; R-008: явные имена/условия. R-003.a/e/g: чистый domain, package imports и class-owned функции. R-005 разрешает диагностические сообщения без intl; эти сообщения не показываются в UI. UI и goldens не затрагиваются.

## Решения и границы

- NavigationLogger — типизированный Logger<NavigationLogEvent>, NetworkLogger — Logger<NetworkLogEvent>. Можно использовать typedef-алиасы, не копировать реализацию двух фасадов. Событие само сообщает LogScope: caller не передаёт произвольный scope/string в log.
- Общий LogRecord неизменяемый: event, level, timestamp, optional message/error/stackTrace. Свободная message допустима только как диагностический текст, не как дискриминатор. Объекты ошибок/stackTrace сохраняются до конечного форматирования.
- AppLoggers получает sinks отдельно через constructor, без глобального mutable registry/service locator. Два scope могут разделять один print sink либо использовать разные реализации.
- Logger.log возвращает типизированные LogAccepted/LogRejected(error, stackTrace). Accepted означает принятие адаптером, не гарантию доставки на будущий сервер. Сбой sink/formatter/clock не бросается в бизнес-сценарий; не вызывает retry или рекурсивное логирование той же ошибки.
- Сейчас контракт записи синхронный: print выполняется сразу, новых async операций нет. Будущий remote sink может синхронно принять запись в собственную очередь; её lifetime/отмена/flush и честный delivery contract определяются в его задаче по R-009. Void sink не означает поддержку async write без управления им.
- Clock инжектируется для детерминированных tests, production default DateTime.now; текст формируется только adapter/formatter. LogLevel: debug/info/warning/error. Network events: requestStarted/requestCompleted/requestFailed. Navigation: requested/started/accepted/rejected/stale/conflict/cancelled/failed/coalesced.
- Навигация: requested на submit, started только при действительном запуске executor; финальный feedback логируется по каждому caller. Coalesced callers не создают второй started. После dispose не появляется поздний accepted/failed; отмена отражает прекращение project wait, не rollback. Sink failure не меняет NavigationFeedback.
- Print изолирован в PrintLogSink. Единственный локальный ignore avoid_print допустим именно на строке согласованного конечного вывода; глобальные lint exemptions не добавляются.

## Acceptance Criteria

- [x] AC1: общий Logger и разные typed scope API; событие сохраняет правильный scope, level и error metadata.
- [x] AC2: navigation/network независимо направляются в выбранные sinks; смена одного не меняет другой; ровно одна запись на log.
- [x] AC3: консольный adapter вызывает реальный print, форматирует timestamp/scope/level/event/message/error/stackTrace. Другие слои не используют print.
- [x] AC4: сбой sink не бросает в caller; возвращает LogRejected и не рекурсирует/не мешает другому scope.
- [x] AC5: nav logs отражают настоящий accepted/rejected/error/cancellation flow, сохранены FIFO/dedup/lifecycle; нет late accepted после dispose.
- [x] AC6: app console wiring работает по умолчанию; docs и выбранные tests/analyzer/architecture проходят.

## Test Scenarios

- Реальные AppLoggers/SinkLogger с независимыми recording sinks: routing и metadata/clock, все levels, общий sink без дублирования, throwing sink и clock, изоляция сбоя.
- Реальный PrintLogSink, print перехватывается ZoneSpecification для проверки фактического консольного вызова, без замены formatter.
- Настоящий NavigationCoordinator + реальный scoped logger, fake только внешний executor/output: allowed, denied, executor failure, dispose до late completion. Сохраняются95 прежних tests nav/scope.
- Статические типы фасадов участвуют в tests; после реализации отдельно подтвердить compiler rejection NetworkLogEvent через NavigationLogger, не вводить runtime string guards.

## Implementation Plan

1. Зафиксировать baseline95; добавить executable tests отсутствующего API, подтвердить compile RED, human gate.
2. После approval: domain/logging контракты/алиасы и events; infrastructure/logging sink, formatter, print adapter и общий SinkLogger; app/logging/AppLoggers и constructor injection текущей navigation.
3. Навигационные lifecycle-логи доставлять через фактический feedback, без повторного bool disposal или записи accepted после закрытия scope. Не менять guard/route semantics.
4. Canonical docs/architecture/logging.md с примером разных sinks и ограничениями. Дополнить layer-boundaries описанием размещения диагностического контракта; новых business rules не добавлять.
5. Новые tests + navigation/scope baseline, flutter analyze, architecture scan/fixtures, rules/links/diff/format. Без build/run/commit/push.

## Test Evidence

2026-11-11, cwd apps/tournament_app:

- `flutter test --no-pub test/app/navigation test/presentation/operations --reporter expanded` —BASELINE_GREEN:95 PASS, exit0. Это повторный фактический запуск текущего commit bf66fb1; runtime не менялся.
- `flutter test --no-pub test/infrastructure/logging/logging_test.dart test/app/logging/navigation_logging_test.dart --reporter expanded` —ожидаемый compile RED, exit1,2 libraries failed loading. Отсутствуют app/logging/AppLoggers, domain/logging контракты/scoped events и infrastructure/logging sink adapters, а также named logger constructor injection NavigationCoordinator. Нет production stubs.17 executable сценариев ещё не исполнялись; это не17 behavioral failures.
- Подготовлены11 logging unit/integration scenarios и6 настоящих coordinator scenarios (включая сбой sink и coalesced execution). dart format двух тестовых файлов —exit0. Полный analyzer/architecture runtime ещё не объявляется GREEN: нового API пока нет.

## Approval

2026-11-11, пользователь: «Приступи к реализации и логи должны сообщать из какого свой scope и подробный лог, а так же они должны быть оформлены, а не просто вывод сухой строки. А еще скажи есть ли у нас правило обязательной типизации?» Подтверждён test set1 после compile RED отсутствующего logging API и baseline95 PASS. Уточнено оформление AC3: читаемый многострочный блок со scope/level/event/time и подробностями; diagnostic metadata навигации. Это оформление прежнего output-контракта, без смены логики маршрутизации/доставки.

## Changelog

### 2026-11-11 · Постановка

> Теперь нужно сделать логирования, сейчас в качестве адаптера будет выступать print в консоль. Схема какая
> есть обобщенный логгер конкретные адаптеры будут реализовать способ вывода логов и неважно будет это отдельный пакет, отправка в интернет или еще что то. Так же должны быть типизированные логгеры под каждый scope: network, navigation и тд. тоесть верхнеуровнего это наши абстракции и только конечные адаптеры реализуют как конркретно логи выводятся. При этом нужно оставить возможность чтобы логи навигации выводились локально, а логи network Отправлялись на сервер например.

- Зарегистрирована независимая задача110. До начала git status чистый, последний коммит bf66fb1. Исследованы слои/app wiring: infrastructure и logging ещё отсутствуют; папки создадутся только при реализации. Библиотека/remote output не выбираются заранее.
- План и ответственность слоёв показаны в чате. Production API пока не создаётся; следующий шаг tests и подтверждение отсутствующего capability.
- Созданы test/infrastructure/logging/logging_test.dart и test/app/logging/navigation_logging_test.dart с17 сценариями, подтверждены baseline95 и compile RED отсутствующего capability. Stage RED_CONFIRMED → AWAITING_APPROVAL. Production пока не менялся; до runtime требуется human approval по workflow. Коммиты/build/run/push не выполнялись.

## Итог

Реализованы общий Logger<Event>, typed navigation/network facades и независимые sinks, текущий PrintLogSink с многострочным оформлением и реальное app navigation wiring. Новый HTTP/remote transport не создавался. Проверены116 tests, analyzer, architecture и финальные структурные проверки. Stage DONE. Коммит/build/run/push не выполнялись.

## Changelog · Approval и уточнение оформления

> Приступи к реализации и логи должны сообщать из какого свой scope и подробный лог, а так же они должны быть оформлены, а не просто вывод сухой строки. А еще скажи есть ли у нас правило обязательной типизации?

- Подтверждение записано до первого production-изменения. Stage IMPLEMENTING. Уточнение: PrintLogSink выдаёт оформленный многострочный блок, каждая строка message/error/stackTrace входит внутрь рамки. Цветовые ANSI-коды не обязательны и не зависят от поддержки терминала. Scope и уровни остаются typed до formatter.
- Пользователю сообщено о действующем R-004. Новое правило типизации не создаётся; diagnostic message не используется для сравнения/маршрутизации. Подробности навигации содержат тип intent и исходную запись, результат и тип эффекта при запуске; business payload не требуется печатать целиком.

## Changelog · Реализация и GREEN

- Добавлены16 runtime-файлов:10 чистых domain logging contracts/events/aliases,4 infrastructure output-файла, AppLoggers и NavigationLogTrace. Библиотеки/SDK зависимости не добавлялись; PrintLogSink содержит единственный print в lib и точечный avoid_print ignore согласно плану.
- NavigationCoordinator получил optional typed NavigationLogger и app trace. Actual feedback логируется в outer scoped request; inner execution не дублирует конечные сообщения. AppNavigationSession по умолчанию собирает консольный logger и позволяет заменить его constructor injection. Ни logger, ни trace не принимают навигационных решений.
- Первый запуск approved17 +2 format refinements —19 PASS, exit0. Дополнительно проверены прежние AC3–5: formatter failure не оставляет partial print и исходное executor exception сохраняет error/stackTrace. Итог21 новых scenarios (14 output,7 nav), исходные17 не ослаблялись. Test fixture хранит Iterable<LogEvent>, не стирает event до Object.
- Изолированный negative probe `.dart_tool/task110_logging_type_probe.dart`: NavigationLogger.log(NetworkLogEvent.requestStarted) отклонён `dart analyze --format machine` с exit1 и точной ошибкой COMPILE_TIME_ERROR/ARGUMENT_TYPE_NOT_ASSIGNABLE NetworkLogEvent → NavigationLogEvent. Отсутствующих imports/API в probe нет; временный файл удалён после проверки.
- `flutter test --no-pub test/infrastructure/logging test/app/logging test/app/navigation test/presentation/operations --reporter expanded` —116 PASS, exit0 (21 logging +95 baseline). Полный вывод хранится локально в ignored .dart_tool/task110-tests.log; пример frame в docs взят из настоящего print default app navigation во время этих tests. UI/темы/goldens не менялись; полный visual suite не повторялся.
- `flutter analyze --no-pub` —No issues found, exit0. Полный architecture scan592 файлов —0 нарушений; navigation boundaries32 PASS, readability41 PASS, top-level49 PASS, theme35 PASS, self-test51 PASS. Все exit0. Нет blanket exceptions и нового checker API.
- Canonical docs/architecture/logging.md фиксирует схему, placement, sample output, independent sinks и границы будущего remote output; ссылки добавлены в docs/README и layer-boundaries. Число scope не выражается строками, .name/toString допустимы лишь при диагностическом форматировании. R-004 не менялся.
- DTD listDtdUris не обнаружил running debug/DTD processes: hot reload недоступен, новый запуск не выполнялся. Ни build, ни commit/push не выполнялись.
- После уточнения только статического типа fixture повторный logging набор21 PASS и analyzer No issues found; итоговый architecture scan592 файлов —0 нарушений. `dart format --output=none --set-exit-if-changed`20 runtime/test файлов —exit0,0 changes. Root node tools/check_rules.cjs —20 leaf/3 группы PASS, git diff --check —exit0, локальные ссылки карточки/README/logging/layer-boundaries —PASS. Stage VERIFYING → DONE,110 закрыта.

## Final Verification

- [x] AC1–6 подтверждены реальными logging adapters/coordinator и116 tests; статическая несовместимость scoped событий проверена отдельно.
- [x] Analyzer, architecture scan/fixtures, формат и правила GREEN; без новых runtime dependencies.
- [x] Output оформлен и содержит scope/level/time/event/details, ошибки и stack при наличии. Консольный пример в docs соответствует реальному print.
- [x] Документация и история актуальны; ограничения server/async/network pipeline честно отражены, открытых блокеров нет.

## Changelog · Коммит задачи110

> делаем коммит и знаешь о чем хочется подумать дальше.
> Приступаем к запуску приложения. Нужен типизированный Botstrap где каждый шаг bootstrap это типизированный элемент, а не простая мапа с действиями. Я хочу иметь максимальный контроль над bootstrap и не преваритть это в один файл с 1000 инициализаций

- Разрешён локальный коммит завершённой110 в стиле проекта: typed logging, print output, nav wiring, tests и docs. Runtime после GREEN не меняется; push не выполняется. Обсуждение bootstrap — следующая отдельная цель, в коммит110 её реализация не включается.
