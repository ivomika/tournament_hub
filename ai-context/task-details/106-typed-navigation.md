# 106. Типизированная навигация

✅ Выполнено · Mode CODE · TestGate REQUIRED · Stage DONE общих adapters · Specification/plan/test set8.

Итоговый scope test set8: механизм intention → guard → effect, typed registry всех25 экранов, контракты результатов и общие push/dialog/modal sheet/controller sheet/date picker adapters. Подтверждены gates5/6/7/8. Конкретные screen bindings, новые intentions и wiring их результатов отложены до реализации экранов прямым запросом пользователя. Бизнес-флоу и общий lifecycle не входят.

## Цель и scope

Approval2026-11-10: пользователь «так тесты подтверждаю, делаем». Относится к test set5, compile RED навигационных API и behavioral RED architecture fixtures. Разрешена реализация согласованного первого сквозного этапа. Origin закреплён за записью, сохраняется при pop обратно и меняется при новом push/replace; rebuild не создаёт новый origin.

Реализовать go_router routing с типизированными route-классами и параметрами, presentation intents, guard decision и effect execution. Реестр остальных экранов подключён через typed builders без новых flow. [Решение и фактические границы](../../docs/architecture/typed-navigation.md).

## Применимые правила

Core R-001/002/004/007/008.a/b: одна ответственность компонентов, документы на русском, sealed-контракты, читаемые имена и проверяемое поведение. Flutter R-003.a–g: presentation не импортирует app, use cases через controllers, routing в app, package URI и точечные codegen-исключения. R-005/R-006: UI feedback через intl, независимые screens/Widgetbook и прежние native goldens. Conditional rules отсутствуют. Workflow прочитан: PLANNING_ONLY сохраняет🟣; реализация логики затем REQUIRED и test-first gate.

## Исследование при постановке

- Факты: TournamentApp использует MaterialApp.home=PlaceholderScreen. go_router отсутствует в pubspec. Screens получают callbacks/data; production routing и session controllers ещё не реализованы.
- Проверена официальная документация typed routes, go_router_builder и onEnter; ссылки в docs. Выбран стандартный typed codegen, без enum→path registry. Версии не закрепляются до проверки solver/SDK.
- Предложены presentation-owned intentions/sink, app-owned pure guard/snapshot/decision и effect executor. Domain не содержит UI routing. Внешние входы и Back не обходят проверку; race/confirmation/exactly-once описаны.
- Не выдумываем state турнирного workflow. Предварительная stack policy и scope первых переходов вынесены на обсуждение. Codegen необходимо согласовать с R-003.e/g без blanket exclusions.

## Критерии первоначального проектирования

- AC1: описаны владельцы типов, зависимости и путь callback→intent→guard→effect→typed route.
- AC2: типизированные решения/отказы/эффекты/результаты, URI-граница и защита всех входов определены.
- AC3: сохранена независимость screens; описаны codegen constraints и архитектурные tests.
- AC4: обозначены этапы реализации, тесты и неутверждённые business/stack policies.
- AC5: runtime/pubspec/generated/UI не изменены; проект представлен до реализации.

Проверки планирования: сопоставление с текущими app/screens/rules; официальные primary sources; ссылки/docs format; git diff --check и rules registry. Сборка и runtime tests неизменённого кода не требуются. Коммиты — только по явному запросу.

## Changelog

### 2026-11-10

> Теперь подключи goRouter и будем работать с ним. Мне нужны типизированные routs, а не переход по константам и строкам. Каждый route каждый экран это типизированое значение которое вызывается из кода. Второе - экраны не должны вызывать какие то конкретные роуты. presentation показывает свои намерения перехода, после guard проверяет условия перехода, возможен ли переход с этого экрана в этом состоянии, выдает типизированный ответ и дальше работу принемает effect который выполняет действие Push, go и так далее. вы отвязываем роутинг от явного presentation. Сначала проектируем, потом меняем код

- Подготовлен проект решения docs/architecture/typed-navigation.md, исследованы текущие точки входа и официальные API. Выполнено только проектирование. Следующий шаг — обсуждение решения и конкретной policy первых переходов, затем test-first реализация. Runtime-код и зависимости не менялись.

### 2026-11-10 · принятие проекта и тесты первого этапа

> Меня все устраивает, давай выполним задачу и по флоу начнем с тестов

- Проект принят. Mode CODE/REQUIRED, specification/plan/test set2. Первый проверяемый срез: Bootstrap/Home/Profile, intention→guard→effect, push/pop/direct-entry fallback и базовые architecture boundaries. Остальные route-классы, confirmation, typed results/URI codec и внешние router hooks остаются последующими этапами этой же задачи; их полная готовность не объявляется по тестам первого среза.
- Новые app/navigation tests:7 guard cases (typed profile push, повторное открытие, bootstrap not-ready, pushed/direct-entry Back, завершение bootstrap, отсутствие мутаций),6 coordinator cases (Allowed once, Denied без effect, coalescing, execution failure, dispose, stale revision),2 настоящих widget integration cases через callbacks реальных Home/Profile и AppNavigationSession. Только внешний executor recording fake, настоящий guard/coordinator/app при реализации не подменяются.
- Названия будущего API закреплены тестами: AppRoute/HomeRoute/ProfileRoute/BootstrapRoute, NavigationContext/EntryId, NavigationAllowed/Denied и rejection enum; Push/Go/Pop effects; controller-facing NavigationIntent/Feedback; NavigationCoordinator и app session. Политика первого среза — bootstrap readiness, home→profile push, profile Back pop, direct-entry profile Back→home. Никаких новых правил турнира.
- Перед runtime изменениями план: реализовать минимальные pure contracts/guard/coordinator, затем typed go_router routes/adapter/session и Home/Profile bindings; кодген и его архитектурные исключения исследовать на точном выводе версии. Подключить guard ко всем входам первого среза; расширять остальные экраны только с отдельными tests. Route-specific results нельзя объявить типобезопасными только из-за push<T>: compile-negative fixtures готовятся с конкретным API результата, не маскируются fake compile-failure отсутствующей библиотеки.
- Проверка архитектуры первого среза:7 executable fixtures tools/domain-check/test/navigation_boundaries_test.dart; предполагаемый leaf R-003.h ещё не зарегистрирован. Четыре запрета — import/export go_router из presentation, ложный effect filename и Navigator вызов из widget;3 positive — app routing import, независимый feedback, строковое упоминание Navigator. Реальный architecture.inspect, без нового production API.

## Evidence test set2

- Cwd apps/tournament_app: flutter test --no-pub test/presentation/screens/home test/presentation/screens/profile —5 PASS, включая существующие Windows goldens, exit0.
- dart format test/app/navigation —3 файла отформатированы. flutter test --no-pub test/app/navigation —exit1,3 test libraries failed loading. Причина соответствует отсутствующим API: lib/app/navigation/*, app/routing/app_routes.dart и presentation/navigation/* ещё нет; конструктор TournamentApp не имеет navigation.15 сценариев ещё не выполнялись, это разрешённый compile RED отсутствующего capability, а не15 поведенческих failures.
- Cwd tools/domain-check: dart format test/navigation_boundaries_test.dart; dart run test/navigation_boundaries_test.dart —exit1,4/7 failed: запрещённые случаи пока возвращают actual [];3 positive проходят. Это behavioral RED нового правила. Нельзя считать отсутствие пакета причиной этих failures: fixtures парсятся существующим analyzer.
- Не изменены runtime, pubspec, generated или router configuration. До реализации после этого gate требуется явное подтверждение по workflow. Документация проектирования и тесты доступны для review; новый коммит и build не выполнялись.

### Уточнение typed execution result · test set3

> что то мне не нравится что в executor мы опираемся на final bool fail; А не на типизированную ошибку

- bool fail находился в recording fake, однако уточнение распространяем и на контракт: execute возвращает Future<NavigationExecutionResult>. Fake получает готовый typed outcome; default NavigationExecutionSucceeded, отказ NavigationExecutionFailed(NavigationExecutionFailure.routerUnavailable). Нет ветвления fail и искусственного StateError. Тест проверяет точное преобразование в presentation NavigationFailureReason.routerUnavailable, а не только класс общего отказа.
- Runtime API ещё не добавлен. Повторный flutter test --no-pub test/app/navigation/navigation_coordinator_test.dart: compile RED отсутствующих navigation API, включая navigation_execution_result.dart. Версия spec/plan/test set3, прежний запрос реализации ещё не является approval этого нового test gate. Коммиты не выполнялись.

### Два одновременных intent · test set4

> добавь проверку на одновременный запуск двух intent, они не должны отработать одновреммено

- Добавлен deterministic async test разных intentions: OpenProfileIntent стартует и удерживается Completer; после сигнала started отправляется BackRequestedIntent. После event-loop turn проверяется, что второй effect не стартовал. После освобождения проверяются два Accepted, порядок Push→Pop, maximumActiveExecutions=1, activeExecutions=0 и возврат на Home. Recording executor обновляет тестовый context лишь при успешном commit.
- Зафиксирована FIFO-сериализация: guard второго намерения оценивается на fresh context после первого commit. В отличие от уже существующего duplicate/coalescing теста, второй intent должен реально выполниться, последовательно, и не отклониться по устаревшему Home. Не удерживать блокировку до закрытия pushed экрана.
- flutter test --no-pub test/app/navigation/navigation_coordinator_test.dart: exit1, ожидаемый compile RED отсутствующих runtime API. Сценарий ещё не исполнялся; нет утверждения о поведенческом GREEN. Теперь16 app сценариев (7 guard +7 coordinator +2 flow),7 architecture fixtures. Runtime и зависимости не изменены, коммитов нет. Spec/plan/test set4, Stage AWAITING_APPROVAL сохраняется.

### Payload conflicts и scoped origin · test set5

> а что например с вызовом двух одинаковых intetnt с разными данными? Что с ними делать открывать два экрана? А возврат тогда куда будет? Возврат же один

> добавь тесты и на это

- Добавлены5 coordinator cases: отдельные экземпляры равного TournamentId объединяются; разные IDs из одного in-flight origin дают NavigationConflict(competingTransition) и только один Push первого ID; поздний callback старого entry получает Stale; два Back из одного entry выполняют один Pop, адресованный этому entry; старый Back не может закрыть новый экземпляр того же ProfileRoute, а новый scoped sink может.
- Исправлен прежний сериализационный тест: bindToCurrentEntry создаёт presentation-facing sink со скрытым origin; Home→Profile и Home-origin Back НЕ дают автоматического Pop Profile. Первый Accepted, второй Stale, максимум1 одновременно выполняющийся executor. Тестовый source увеличивает entry/revision при commit и хранит фактический destination; не использует всегда одинаковый entry ID.
- OpenTournamentIntent/TournamentRoute и pure TournamentId value object включены как минимальный параметризованный routing-контракт для проверки payload equality. Бизнес-правила турнира/хранение этим не реализуются и не подменяются fixtures. Исходная FIFO-политика уточнена в docs: origin не переопределяется при dequeue; один entry — один result channel. Реальные typed screen results ещё требуют отдельного контракта и тестов, сейчас не заявлены покрытыми.
- Повторный flutter test --no-pub test/app/navigation/navigation_coordinator_test.dart: exit1, ожидаемый compile RED отсутствующих navigation API/value object. Теперь21 app сценарий (7 guard +12 coordinator +2 flow),7 architecture fixtures. Это тестовая постановка, не runtime implementation; Stage AWAITING_APPROVAL сохраняется, коммиты не создавались.

### Реализация первого этапа · approval test set5

> так тесты подтверждаю, делаем

- Approval записан до runtime-изменений. Подключены фиксированные go_router18.1.4 / go_router_builder4.5.3 / build_runner2.17.1. Typed constructors/codec, scoped presentation sink/controller, guard, FIFO coordinator с payload equality/conflict и stale origin, effect executor с typed outcome. В app wiring используется MaterialApp.router. Home/Profile остаются независимыми screens и работают в прежнем Widgetbook.
- Origin привязан к route entry, Home сохраняет origin при pop, удалённые keys/controllers очищаются перед новым push того же route. Дополнительный integration test поймал бы повторное использование origin; новый Profile получает новый entry, старый Back больше не влияет на него. Добавлены platform Back, readiness при cold Profile entry и Unicode/slash/percent TournamentId URI round-trip. Ожидаемая ошибка входа отображается Bootstrap error, не внутренним текстом GoRouter.
- Генератор не выпускает файл с package URI part и не определяет inherited onExit без явного override. Использованы точечные package-ownership normalization и getter allowlist с narrow tests, generated код не редактировался. CustomParameterCodec для произвольного TournamentId не поддержан данной версией; используемый TypedQueryParameter encoder/decoder корректно кодирует и path parameter, что подтверждено round-trip test.
- Runtime guard не запускает domain ports/use cases. Бизнес-profile/tournament storage не добавлено: Home/Profile получают пустое начальное состояние, остальные действия пока недоступны. TournamentRoute типизирован, но экран пока PlaceholderScreen — это не реализация загрузки турнира. Profile popup/result contracts и остальные страницы остаются следующим этапом задачи, статус всего106 сохраняется 🚧.
- R-003.h зарегистрирован,19 leaf/3 группы. Navigator pops локальных Select modal и Widgetbook dialog отделены от app navigation по точным path/class/method/call, Push/другие классы не подпадают. Изменения существующих архитектурных правил R-003.e/g имеют positive/negative tests. Ограничения AST-проверки aliases/extensions описаны в правиле и docs.

## GREEN evidence первого этапа

- Cwd apps/tournament_app: flutter analyze --no-pub — No issues found, exit0. dart run build_runner build — exit0; SHA256 app_routes.g.dart до/после повторной генерации совпал. flutter test --no-pub —204 PASS,1 штатный SKIP external visual comparison CLI, exit0. Включает25 navigation tests, прежние interaction/state/widgetbook/viewport и native Windows goldens без update. Другие ОС не проверялись.
- Cwd tools/domain-check: navigation_boundaries_test14 PASS (7 исходных +7 codegen/modal fixtures), top_level_functions49 PASS, code_readability41 PASS, theme_boundaries35 PASS, self-test51 PASS; полный scan554 файлов —0 нарушений, exit0.
- Root: node tools/check_rules.cjs —19 leaf/3 группы PASS; git diff --check PASS. SDK generation — не сборка приложения; Flutter build/run и push не выполнялись. DTD подключён, running apps нет: hot reload недоступен. Коммиты не создавались согласно прямому запрету пользователя.
- План далее: расширять typed routes/bindings и state для остальных страниц, добавить конкретный typed-result API с compile-negative tests и confirmation scenarios. Не выдавать первый этап GREEN за завершение всей задачи106.

### 2026-11-10 · реестр остальных экранов, specification/plan/test set6

> давай сделаем остальные типизированные экраны, а дальнейший флоу навигации и наверенья не будем делать, сейчас только заложим сам механизм навигации и роуты

> продолжи

- Текущий scope сужен до механизма и типизированных маршрутов всех25 существующих экранов. Placeholder не является самостоятельным продуктовым маршрутом. Новые intentions, бизнес-переходы, confirmation/result workflow и загрузка данных не входят в этот этап; прежний план их реализации отложен по прямому запросу.
- План: дополнить typed registry; сохранить TournamentId в маршрутах контекста турнира; различать конкретный дочерний маршрут при decode; не импортировать routes в presentation и не подключать действия экранов, для которых ещё нет flow. Построение реальных экранов использует их существующие presentation-контракты, без Widgetbook fixtures и выдуманного турнирного состояния.
- AC6: все25 маршрутов зарегистрированы в настоящем GoRouter и однозначно декодируются обратно в конкретный route type. AC7: scoped адреса сохраняют TournamentId, включая Unicode, slash и percent; один tournament prefix не превращает любой дочерний экран в TournamentRoute. AC8: неизвестный адрес не становится известным маршрутом. AC9: существующие navigation regression tests остаются GREEN; новые intentions не добавлены.
- Test scenarios: route catalog/URI round-trip через настоящий RouteConfiguration.findMatch и buildState; unknown URI; прежние guard/coordinator/flow tests. TestGate REQUIRED: меняется routing-контракт, прежний approval test set5 распространялся только на первый срез. До нового gate runtime расширения не меняется. Сборки/коммиты не выполняются.
- Evidence test set6: cwd apps/tournament_app, flutter test --no-pub test/app/navigation/route_catalog_test.dart —exit1, ожидаемый compile RED отсутствующих21 route-класса (UtilityRoute…ResultsRoute). Три сценария ещё не выполнялись; это не behavioral failure. Прежние navigation_guard_test.dart/navigation_coordinator_test.dart/navigation_flow_test.dart —25 PASS, exit0. git diff --check —PASS. В sandbox SDK не выдавал вывод даже для dart --version; результат получен повторным запуском вне sandbox. Production расширения не менялся. Остановка перед реализацией по workflow; требуется approval test set6.

### 2026-11-10 · approval test set6

> делаем

- Пользователь подтвердил gate test set6 после ожидаемого compile RED отсутствующих21 route-класса и baseline25 PASS. Разрешена реализация реестра всех25 экранов, без новых intentions/flow. Spec/plan/test set6.
- App-owned ScreenRouteBuilders передаёт отдельный строго типизированный builder реального screen. Builder получает конкретный route и scoped presentation navigation controller. Это точка будущего DI/state wiring, а не загрузчик и не routing в presentation. Отсутствующий binding показывает существующий Bootstrap error; тестовые турнирные данные не создаются. Controllers форм принадлежат будущей внешней обвязке, не сериализуются в URI и не живут в route-классе.
- Все новые адреса — siblings внутри Home route tree: URL-prefix сам по себе не задаёт новый business stack. Modal screens пока имеют адрес, но bottom-sheet/result workflow не реализуется. Для дальнейшей адресации конкретного матча/гостя потребуются отдельные предметные IDs и flow; сейчас scoped routes идентифицируют турнир и вид экрана, не конкретную схватку.

### 2026-11-10 · завершение текущего scope

- Реализованы21 дополнительных typed route и25 отдельных screen builders. Scoped constructors принимают TournamentId; URI codec не переносится в presentation. Decode различает конечные адреса. Все новые route-классы имеют onExit и подключены к общему readiness guard; новые intentions и бизнес-переходы не добавлены.
- Дополнительные integration tests проверяют реальный AboutScreen/RosterScreen через binding, передачу decoded TournamentId/scoped navigation, отсутствие действия onDeal без flow, Bootstrap error при отсутствии binding и блокировку builder до initialization. Это уточнение технического покрытия прежних AC6–9, не новая бизнес-политика.
- Владение состоянием/forms controllers оставлено внешней обвязке; builders — typed callbacks, не storage и не фабрика фиктивного турнира. Отсутствующий binding не выдаётся за рабочий бизнес-экран. Default Home/Profile/Bootstrap сохранены, Tournament Placeholder заменён на явный существующий error screen.
- Документация обновлена: полный каталог URI, API binding, callback lifecycle и отложенные результаты/modal workflow. Production screens/темы/Widgetbook fixtures не изменены.

## Итоговая приёмка и GREEN evidence

- [x] AC1–AC4: ownership, typed decision/effects/feedback, URI-граница, origin и scope-checks документированы и реализованы в согласованных границах. Typed screen results и confirmation не выдаются за готовые.
- [x] AC5 первоначального planning-only шага выполнен до согласования; runtime начат только после test gates. Это исторический критерий проектирования, не запрет последующей одобренной реализации.
- [x] AC6: все25 routes однозначно match/decode через реальную GoRouter configuration.
- [x] AC7: scoped round-trip сохраняет Unicode/slash/percent и другие URI-символы для15 screen routes; дочерний экран не превращается в TournamentRoute.
- [x] AC8: неизвестные root/scoped адреса не зарегистрированы.
- [x] AC9: прежние guard/coordinator/flow scenarios GREEN, новых intentions нет.
- Cwd apps/tournament_app: flutter test --no-pub test/app/navigation —32 PASS, exit0. flutter analyze --no-pub —No issues found, exit0. flutter test --no-pub --reporter compact —211 PASS,1 штатный SKIP external visual comparison CLI, exit0. Native Windows goldens сравнены без update; другие ОС не проверялись.
- dart run build_runner build —exit0; повторный codegen даёт same output, SHA256 app_routes.g.dart A2C8DCBA9BC7112717E1FB18BBF41D1C5B7D4C6F70CCCE04AD3E8E2BCB2DB520 совпал до/после. Generated код не редактировался вручную; новые исключения checker не потребовались.
- Cwd tools/domain-check: dart run bin/check_flutter_architecture.dart —557 файлов,0 нарушений, exit0. navigation_boundaries_test14 PASS; top_level_functions49 PASS; code_readability41 PASS; architecture --self-test51 PASS; theme_boundaries35 PASS.
- Root: node tools/check_rules.cjs —19 leaf/3 группы PASS; git diff --check PASS. DTD listConnectedApps —running apps нет, hot reload недоступен. Build/run, commit/push не выполнялись.
- Задача завершена в уточнённом пользователем scope. Загрузка и реальное состояние остальных экранов, маршрутизация конкретного матча/гостя, новые intentions и бизнес-флоу остаются будущей работой, а не скрыто завершёнными возможностями.

## Продолжение · test set7 · typed results и modal

### 2026-11-10 · Changelog, append-only

> так давай заведем правило, что асинхронные функции должны быть отминяемыми. И сразу же архитектурно заведем обработку 1 и 2 кейса. Твои предложения мне нравится, После будем отдельно развивать 3 вопрос и подробнее про него поговорим

- Переоткрыта106, старое завершение test set6 остаётся историей. Независимое core-правило создаётся в108. Прочитаны все действующие core/Flutter rules, в том числе R-009; conditional rules отсутствуют. Уточнён R-003.h без blanket SDK exemptions. Архитектура в docs/architecture/navigation-interactions.md.
- Приняты: разные transition/result futures, typed completed/cancelled/failed, result binding к child entry, separate caller/child lifetime, очередь свободна при ожидании результата; app modal шаги через guard/effect, локальные picker в DS; targeted close собственным route/controller handle. У showBottomSheet controller-based контракт отдельно от modal Future<Result?>. Ни новый бизнес-флоу, ни замена _disposed не входят.
- Первый срез plan7: InteractionOutcome<Result extends Object>, InteractionOperation<Result> с transition/result/cancel, внутренний app InteractionResultChannel<Result> с целевым NavigationEntryId. Publisher вызывается только app после принятого close effect; не отдаётся widget/state. Результат канала не является разрешением на закрытие экрана.
- Следующий обязательный срез этой106: связывание конкретных request/result пар, guard/coordinator/executor и реальные Flutter push/modal adapters; compile-negative fixtures несовместимого результата; integration tests queue release, возврат caller, Back/barrier/drag, parent removal и targeted overlay close. Эти возможности пока не реализованы и не покрыты тестами первого среза. Общая библиотека lifecycle/рефакторинг _disposed остаётся за scope.

### Specification и критерии первого среза

- [x] AC10: completed/cancelled/failed различаются типами, native null становится dismissed, non-null сохраняет тип значения.
- [x] AC11: channel принимает результат только своего child entry и завершает result ровно один раз; дубль/поздний результат/отмена не переписывают исход.
- [x] AC12: operation предоставляет независимые transition/result ожидания и идемпотентную отмену; это контракт, не доказательство готовности всего queue/modal wiring.
- [x] AC13: после реализации contracts прежние32 navigation tests и обязательные architecture checks остаются GREEN. Фактические границы runtime отражены в docs.

Ошибки/границы: неизвестный publisher entry, повторное завершение, отмена до/после результата, поздний ответ, технический отказ. Все11 executable scenarios распределены между interaction_result_channel_test.dart (9) и interaction_operation_test.dart (2). Harness не подменяет проверяемый channel/operation; callback отмены моделирует внешнее закрытие и завершает тот же реальный channel.

### Evidence и gate

- Cwd apps/tournament_app: flutter test --no-pub test/app/navigation/interaction_result_channel_test.dart test/app/navigation/interaction_operation_test.dart --reporter expanded —exit1,2 test libraries failed loading. Ожидаемый compile RED: отсутствуют interaction_result_channel.dart, interaction_outcome.dart и interaction_operation.dart. Производные ошибки типов следуют из отсутствующего API;11 сценариев ещё не исполнялись, это не11 behavioral failures.
- Baseline: flutter test --no-pub test/app/navigation/navigation_guard_test.dart test/app/navigation/navigation_coordinator_test.dart test/app/navigation/navigation_flow_test.dart test/app/navigation/route_catalog_test.dart test/app/navigation/screen_route_builders_test.dart --reporter compact —32 PASS, exit0.
- dart format двух новых tests выполнен. node tools/check_rules.cjs —20 leaf/3 группы PASS; git diff --check —PASS. Полный analyzer/suite до появления API не заявляется GREEN. Production, dependencies, generated, screens/темы/Widgetbook не менялись в этой итерации. Сборки/коммиты не выполнялись.
- Stage AWAITING_APPROVAL: прежние approvals5/6 не распространяются на новые contracts7. После одобрения реализуется первый срез;106 не закрывается до согласованного wiring следующих срезов. Полный lifecycle deferred пользователем.

### 2026-11-10 · Approval первого среза interactions

> подтверждаю

- Пользователь подтвердил реализацию contracts test set7 после11 executable scenarios с ожидаемым compile RED отсутствующих трёх runtime-файлов и baseline32 PASS. Approval относится к InteractionOutcome, InteractionOperation и внутреннему InteractionResultChannel. До первого production-изменения Stage переведён в IMPLEMENTING; дальнейшее wiring push/modal и общий lifecycle этим approval не объявлены реализованными.

### 2026-11-10 · GREEN первого среза interactions

- Реализованы3 файла без новых пакетов, изменений routes/generated или screens: sealed InteractionOutcome<Result extends Object>, InteractionOperation<Result> и app-only InteractionResultChannel<Result>. Constructor/API соответствуют утверждённым tests. Пустые строки разделяют constructors/fields/methods по соглашению107.
- Channel проверяет child entry, синхронно завершает Completer один раз и возвращает typed completion status. Cancel/fail — методы владельца app; publisher не добавлен в presentation API. Bool lifecycle не вводился, существующий _disposed не менялся.
- Operation кеширует cancellation Future до вызова onCancel; cleanup Future передаёт ошибку вызывающему. Это handle, а не автоматический shutdown router: владелец обязан завершить переданные transition/result futures и закрыть UI. Такая ответственность и отсутствие текущего wiring прямо описаны в docs/architecture/navigation-interactions.md.
- Cwd apps/tournament_app: flutter test --no-pub test/app/navigation --reporter compact —43 PASS, exit0 (11 новых +32 прежних). flutter analyze --no-pub после исправления prefer_initializing_formals —No issues found, exit0. Dart constructor использует required this._onCancel; внешнее имя onCancel проверено компиляцией tests. dart format3 новых runtime-файлов —0 изменений.
- Cwd tools/domain-check: полный scan562 файлов —0 нарушений; navigation_boundaries14 PASS, top_level_functions49 PASS, code_readability41 PASS, theme_boundaries35 PASS, architecture --self-test51 PASS. Все exit0. Полный Flutter UI/golden suite не повторялся: UI и существующие adapters не менялись, затронутые contracts покрыты navigation suite.
- Root: rules checker20 leaf/3 группы PASS, git diff --check PASS. DTD listConnectedApps —нет running apps, hot reload недоступен; новый запуск запрещён прежним ограничением. Build/run/commit/push не выполнялись.
- Первый срез GREEN;106 остаётся 🚧. Следующий срез — связывание request/result типов, guard/queue и настоящих push/modal adapters с integration/compile-negative tests до его runtime implementation. Третий вопрос об общем lifecycle по-прежнему отложен.

## Продолжение · test set8 · только общие adapters

### 2026-11-10 · Changelog

> давай сделаем только общие адаптеры, а конкретные binding потом во время реализации экранов

- Scope уточнён до общих технических adapters: typed AppRoute push через go_router; dialog, modal bottom sheet, controller-based bottom sheet и date picker через Flutter. Все screen-specific bindings, business requests/results, wiring новых intentions в guard/coordinator и compile-negative request/result pairs отложены до реализации экранов. Старая запись plan7 остаётся историей, не обязательством текущего scope.
- План8: app-only InteractionPresentation<Result> с presentation-facing operation и типизированным complete для будущего effect; GoRouterPushInteractionAdapter с observer точного native route; FlutterModalInteractionAdapter для четырёх modal/selection механик; DatePickerInteractionOptions для фиксированных дат. Result channel/operation первого среза переиспользуются. Экранов и их названий внутри adapters нет.
- Конструкторы получают navigator/scaffold keys явно; root/local определяется переданным key, не поиском произвольного верхнего Navigator. Для push observer регистрируется при сборке GoRouter; app DI/production wiring экранов не меняется. Completion publisher остаётся только app API, не контрактом widgets.
- Adapters владеют native Route/controller и закрывают именно его. complete закрывает собственный UI и публикует значение; native Back/dismiss даёт dismissed; operation.cancel даёт requested. close adapter отменяет незавершённые операции с ownerEnded, освобождает обработчики и не закрывает чужой UI. Это локальный ресурсный контракт нового adapter, не выбранная общая библиотека lifecycle и не рефакторинг существующего _disposed.
- До runtime — widget tests реального GoRouter/Navigator/Scaffold и точечные checker fixtures. Fake экраны используются только как минимальный тестовый контент, без product bindings/Widgetbook fixtures. Это не проверка новых business rules. TestGate REQUIRED: меняется асинхронная навигационная оркестрация.

### Критерии и ошибки общего среза

- [x] AC14: push возвращает типизированный результат, освобождает открытие отдельно от результата, native Back завершает отменой.
- [x] AC15: dialog/modal sheet/controller-based sheet открывают реальный UI и возвращают значение либо dismissed; date picker реально выбирает DateTime.
- [x] AC16: cancel закрывает только свой route/controller, включая взаимодействие под другим окном, и завершает оба ожидания при отмене во время открытия. Повторные/поздние complete/cancel безопасны.
- [x] AC17: отсутствие navigator/scaffold даёт typed opening/result failure без зависшего Future; закрытие adapter завершает pending с ownerEnded.
- [x] AC18: новые точечные app adapter SDK-вызовы разрешены checker, остальные места/ложные пути не получают исключений. Прежние43 navigation tests остаются GREEN после реализации.
- [x] AC19: нет screen bindings, продуктовых переходов и изменения общего lifecycle; docs отражают границы завершения106 в уточнённом scope.

Guard и сериализация остаются ответственностью будущего вызывающего effect pipeline: низкоуровневый adapter не является публичным обходом guard из presentation. Уже выполненный native push не выдаётся за откат: отмена до acknowledgement обязана завершить transition Accepted либо Cancelled согласно фактическому commit и удалить только собственный UI.

### Test set8: сценарии, implementation plan и evidence

- interaction_adapters_test.dart содержит25 widget scenarios:6 push (value, native Back, covered cancellation, cancellation during opening, owner close, unavailable navigator) и19 modal/picker (value/Back/owner close для3 видов; covered cancel dialog/sheet; barrier/drag; controller sheet replacement; date selection/Back; unavailable host; nested local/root Navigator; owner close сразу dialog/sheet/date). Все используют настоящий GoRouter/Navigator/Scaffold; тестовый контент остаётся внутри одного test-файла, production screen bindings отсутствуют.
- Planned API: InteractionPresentation<Result>.operation и complete(Result); GoRouterPushInteractionAdapter(router, observer).open<Result>(AppRoute, entryId); FlutterModalInteractionAdapter(navigatorKey, scaffoldKey) с dialog/modalBottomSheet/bottomSheet/datePicker. Обе реализации имеют close для owned resources. entryId передаётся app, native Route/controller хранится точно; keys/observer инжектируются. DatePickerInteractionOptions содержит initial/current/first/last dates. Concrete Result определяется будущим binding, generic adapter сам не доказывает связь конкретного screen/request с Result.
- Tests first не вводят production stubs. После approval: implement presentation wrapper/owned completion; observer и go_router push; native modal/controller/date adapters; narrow checker update; focused widget/compile checks и обязательная регрессия. SDK-вызовы app остаются только в известных owner methods: GoRouterPushInteractionAdapter._open/_close и FlutterModalInteractionAdapter._openRoute/_closeRoute/bottomSheet. Если понадобится другое имя/точка SDK, оно документируется с fixtures, не blanket allow файла.
- В pinned go_router18.1.4 исследован public RouteMatchList.remove: он удаляет target и все последующие matches. Его нельзя применять как «удалить только нижний interaction»: test covered cancellation требует сохранить новый push и согласованность router stack после его завершения. Исследован Flutter ScaffoldState.showBottomSheet: он закрывает предыдущую панель; late callback старого controller не должен трогать новый. Источники — установленный код зависимостей/Flutter SDK, не предположения по макету.
- Cwd apps/tournament_app: flutter test --no-pub test/app/navigation/interaction_adapters_test.dart --reporter expanded —exit1, одна test library failed loading. Причина ожидаемого compile RED: нет date_picker_interaction_options.dart, flutter_modal_interaction_adapter.dart, go_router_push_interaction_adapter.dart, interaction_presentation.dart, interaction_route_observer.dart.25 сценариев ещё не выполнялись, это не25 behavioral failures.
- Baseline7 существующих test libraries (interaction_operation/result_channel, navigation_guard/coordinator/flow, route_catalog, screen_route_builders), flutter test --no-pub с явными7 путями и --reporter compact —43 PASS, exit0. Новое adapter test намеренно не входит в baseline; полный suite/analyzer с отсутствующими API не объявляется GREEN.
- Cwd tools/domain-check: navigation_boundaries_test.dart расширен18 narrow fixtures (всего32). dart run test/navigation_boundaries_test.dart —exit1,10 ожидаемых behavioral failures:3 новых adapter push/pop разрешения ещё отсутствуют и7 неразрешённых SDK случаев пока пропускаются (removeRoute/restore/modal calls). Прежние fixtures сохраняют смысл; Canvas.restore не считается navigation, точные Select/Widgetbook open остаются разрешены, неправильные class/method не получают exemptions.
- dart format новых/изменённых tests выполнен; node tools/check_rules.cjs —20 leaf/3 группы PASS; git diff --check —PASS. Runtime/dependencies/generated/rules implementation не менялись. Сборки/коммиты не выполнялись. По workflow Stage AWAITING_APPROVAL test set8 до production implementation.

### 2026-11-10 · Approval общих adapters

> поехали

- Пользователь одобрил test set8 после25 widget scenarios с ожидаемым compile RED5 отсутствующих runtime API и10 behavioral RED32 architecture fixtures. Scope: только общие adapters/точечная проверка, без screen bindings, продуктовых intentions и общего lifecycle. Approval записан до runtime; Stage IMPLEMENTING.

### 2026-11-10 · Реализация и GREEN общих adapters

- Реализованы5 API: app InteractionPresentation<Result>, GoRouterPushInteractionAdapter, InteractionRouteObserver, FlutterModalInteractionAdapter и DatePickerInteractionOptions. Повторно использованы operation/result channel; channel получил getter состояния Completer, отдельные bool lifecycle flags не добавлялись. Adapter shutdown хранит единственный Future cleanup; общий _disposed coordinator не менялся.
- Push захватывает конкретный SDK Completer из RouteInformationState, match и native route; одинаковые URL не смешивают владельцев. Covered close пересобирает только нужную ветку через публичные RouteMatchList/ShellRouteMatch constructors и restore. Попытка использовать internal copyWith была выявлена analyzer и исправлена без ignore. Пустая Shell-ветка не создаётся, неизвестные Page.key observer игнорирует.
- Native dialog/sheet используют собственный route; controller sheet — собственный controller. Для второго sheet явно ожидается закрытие предыдущего. В используемом SDK _closeCurrentBottomSheet для LocalHistoryEntry не завершает старый closed автоматически при простой замене; adapter предотвращает этот незавершённый future. SDK-вызов перенесён из публичного bottomSheet в owned async _openSheet; одно positive fixture и narrow predicate переименованы с тем же ожидаемым смыслом. Это техническое уточнение plan8, не blanket exemption.
- Drag fixture исправлен механически: глобальная test binding дала высоту sheet1800px, фиксированные600px не достигали порога. Теперь жест равен реальной высоте sheet; добавлено assertion исчезновения UI до ожидания result. Ожидаемый dismissed outcome не ослаблялся. Временная диагностика удалена.
- Добавлены2 regression cases для close после unmount Navigator/Scaffold и3 unit scenarios новой валидации/нормализации date options. Это границы того же AC17/DatePickerOptions, не новый бизнес-флоу. Итого27 adapter widget tests +3 options tests. Cleanup не вызывает disposed SDK host и завершает ожидания; глобальный lifecycle framework не вводился.
- R-003.h и docs обновлены с точными path/class/method/API. Direct show* и app restore/removeRoute вне разрешённых owners отклоняются. Существующие local Select/Widgetbook open/pop сохранены адресно. AST по-прежнему синтаксический, не доказательство всех alias/extension обходов; review остаётся обязательным.

### Итоговая verification test set8

- Cwd apps/tournament_app: flutter test --no-pub test/app/navigation --reporter compact —73 PASS (43 baseline +27 adapters +3 options), exit0. Полный flutter test --no-pub --reporter compact —252 PASS,1 штатный SKIP external visual comparison CLI, exit0. Включает все существующие Windows goldens без update; другие ОС не проверялись. Новые production screens/стили не создавались.
- flutter analyze --no-pub —No issues found, exit0. Runtime/tests отформатированы dart format. Первичные info curly_braces/prefer_initializing_formals и warnings internal SDK API устранены; suppression не добавлялся.
- Cwd tools/domain-check: полный architecture scan569 файлов —0 нарушений, exit0; navigation_boundaries32 PASS; top_level_functions49 PASS; code_readability41 PASS; theme_boundaries35 PASS; architecture --self-test51 PASS. Все exit0.
- Root: node tools/check_rules.cjs —20 leaf/3 группы PASS; git diff --check —PASS; локальные ссылки architecture docs/rule —PASS. DTD listConnectedApps —running apps нет, hot reload недоступен. Build/run/commit/push не выполнялись по прежним ограничениям пользователя.
- Задача106 завершена в явно уточнённом scope. Adapters доступны для будущих app effects, но не wired в обычный запуск и не связаны с конкретными экранами/requests. Существующий GoRouterEffectExecutor push<void> сохранён. Конкретные typed result bindings и их compile-negative/business-flow tests остаются для реализации экранов; прежний план обязательного wiring в106 заменён прямым уточнением пользователя. Общий lifecycle остаётся отдельным обсуждением.

### 2026-11-11 · Коммит задачи

> сдлеай коммит каждой задачи по одному коммиту, И ответь что из моих 3 вопросов мы закрыли

- Разрешён отдельный локальный коммит106. Runtime, routes/generated, tests, navigation checker и связанные docs/rules собраны вместе; самостоятельные whitespace-правки107 и core-правило108 отделены через index. Рабочая реализация не меняется. Push не выполняется.
