# Типизированная навигация intention → guard → effect

Статус: решение принято2026-11-10; реализованы механизм навигации и исходные25 экранов задачи106. Задача112 добавляет RegistrationRoute: всего26 маршрутов и первый подключённый flow регистрации. Остальные intentions и бизнес-флоу подключаются отдельно. Документ уточняет применение [границ слоёв](layer-boundaries.md); исполнение закреплено R-003.h.

Продолжение2026-11-10: реализованы [typed results и общие push/modal adapters](navigation-interactions.md). По уточнённому scope106 завершена на общем механизме; bindings и их wiring подключаются при реализации экранов. Турнирный бизнес-флоу и общий lifecycle по-прежнему не входят в этот этап.

Продолжение задачи114: подключён Profile→ProfileEdit→Profile через OpenProfileEditIntent/ProfileNameSavedIntent и реальные controllers/bindings. NavigationContext дополнен typed previousRoute и NavigationProfileEditStatus; guard блокирует уход во время save и различает возврат pop в исходный профиль и go(ProfileRoute) для прямого edit entry. Подробности и ограничения: [редактирование профиля](local-profile-registration.md#редактирование-и-инициалы--задача114). Новых маршрутов нет; реестр остаётся26.

## Реестр экранов и подключение состояния

Каждый адрес имеет отдельный GoRouteData-класс. В коде app используются его constructor и generated location; presentation не получает эти классы. Строки ниже описывают только URI-границу.

| Route | URI |
| --- | --- |
| HomeRoute | / |
| BootstrapRoute | /bootstrap |
| RegistrationRoute | /registration |
| UtilityRoute | /utility |
| ProfileRoute | /profile |
| ProfileEditRoute | /profile/edit |
| SettingsRoute | /settings |
| AboutRoute | /about |
| ContactRoute | /contact |
| HistoryRoute | /history |
| SetupRoute | /setup |
| TournamentRoute | /tournament/:tournamentId |
| RosterRoute | /tournament/:tournamentId/roster |
| ParticipantAccessRoute | /tournament/:tournamentId/participant-access |
| GuestAddRoute | /tournament/:tournamentId/guest-add |
| GuestRemoveRoute | /tournament/:tournamentId/guest-remove |
| DistributionRoute | /tournament/:tournamentId/distribution |
| SpectatorAccessRoute | /tournament/:tournamentId/spectator-access |
| TieRoute | /tournament/:tournamentId/tie |
| WithdrawRoute | /tournament/:tournamentId/withdraw |
| ResultLockedRoute | /tournament/:tournamentId/result-locked |
| BracketRoute | /tournament/:tournamentId/bracket |
| MatchResultRoute | /tournament/:tournamentId/match-result |
| ForfeitRoute | /tournament/:tournamentId/forfeit |
| ChampionRoute | /tournament/:tournamentId/champion |
| ResultsRoute | /tournament/:tournamentId/results |

Scoped constructors требуют TournamentId. Общий codec сохраняет Unicode и URI-спецсимволы. Decode проверяет полный URI path, поэтому дочерний адрес не декодируется как TournamentRoute только из-за наличия tournamentId. Неизвестный адрес отклоняется. Все новые routes — siblings под Home: адресная группировка не задаёт сценарий переходов или обязательное открытие Tournament перед дочерним экраном.

AppNavigationSession получает ScreenRouteBuilders. У каждого screen свой nullable callback с конкретным возвращаемым screen type, конкретным route type, BuildContext и scoped ScreenNavigationController. Например roster возвращает RosterScreen и получает RosterRoute, а не произвольные Widget/Map/Object. Внешняя app-обвязка создаёт состояние и передаёт callbacks через обычный constructor screen. Builder — точка композиции, не место бизнес-правил: use cases по-прежнему вызываются только из presentation state/controller.

Home/Profile/Bootstrap сохраняют прежнее минимальное начальное отображение, если builder не передан. Для остальных экранов без binding показывается существующий Bootstrap error без retry; Placeholder больше не используется как экран турнира. Это явное отсутствие подключения состояния, а не выполненная загрузка и не фиктивный турнир. Назначенный маршрут и origin сохраняются даже при этом отображении. Экраны и Widgetbook не изменены.

Builders вызываются при rebuild: операции загрузки и создание долгоживущих controllers внутри callback не допускаются. Controller/state lifecycle принадлежит внешней app/presentation-обвязке, а не route или URI; завершённая запись не должна удерживаться этой обвязкой. Тексты, темы и preview остаются в presentation. Нет сериализации controllers, callbacks или screen instances через extra.

Адреса GuestRemove/Withdraw/MatchResult/Forfeit пока выбирают вид экрана в контексте турнира. Они ещё не идентифицируют отдельного гостя/матч: соответствующие предметные IDs, выбранный объект и правила перехода добавляются вместе с реальным flow. Наличие адреса modal screen не означает реализацию bottom sheet, результата закрытия или confirmation policy. Никакие новые intentions этим этапом не подключены.

Проверки: route_catalog_test.dart проверяет все26 адресов через настоящий GoRouter configuration, concrete type round-trip и encoded identifiers. screen_route_builders_test.dart проверяет реальный About/Roster screen через injection, отсутствующий binding и блокировку до initialization. Прежние guard/coordinator/flow tests проверяют существующий путь Home→Profile→Back и защиту origin. Регистрация проверена реальным bootstrap/router и controller: [локальный профиль](local-profile-registration.md).

## Реализованный первый этап

- MaterialApp.router, go_router18.1.4, go_router_builder4.5.3, build_runner2.17.1. Версии закреплены для воспроизводимого codegen. Обычный запуск открывает Home; Widgetbook остаётся самостоятельным.
- Typed route-классы и один generated route tree перечислены выше. TournamentId — чистый Dart value object, обязательный параметр маршрута с codec. URI строки используются только в routing/адаптере. Загрузка турнира ещё не подключена. BootstrapRoute отображает loading; ошибка недопустимого начального входа использует существующий Bootstrap error screen.
- Рабочий пользовательский путь Home→Profile→Back. Presentation ScreenNavigationController передаёт намерения в scoped sink, app guard возвращает typed decision, executor выполняет push/go/pop и возвращает typed outcome. Home/Profile получают минимальное пустое состояние; профильное хранилище и прочие actions не подменяются Widgetbook fixtures и ещё не подключены.
- Origin сохраняется для Home при возврате, новая запись Profile получает новый ID. Старые callbacks отклоняются. Методы controller не выбирают route или операцию стека. Системный Back проверяется через onExit, входы — onEnter с общей guard-политикой readiness.
- Popup results, confirmation workflow, typed screen-result contracts и бизнес-привязки остальных screens отложены. На старте нет полноценного domain bootstrap/session lifecycle. Не считать наличие typed TournamentRoute реализованной бизнес-операцией продолжения турнира.
- Codegen требует относительную пару part/part-of и три top-level getters: $appRoutes/$homeRoute/$bootstrapRoute. Исключения ограничены точными путями/именами в R-003.e/g и покрыты positive/negative fixtures. Generator обнаруживает onExit только при прямом override route-класса: делегирующие overrides явно объявлены на каждом route, а не только на общей базе. Generated helpers сами неизбежно содержат императивные SDK-вызовы, но app-код вызывает навигацию через effect adapter.
- AST границы дополнительно сохраняют только существующие локальные modal pops Select и Widgetbook dialog (R-003.h); это не переходы между экранами приложения. Проверки не заявляются полной resolved-моделью всех возможных third-party aliases/extensions.
- Проверки:25 navigation cases;14 boundary/codegen/modal fixtures; общий Flutter suite204 PASS/1 штатный SKIP; analyzer и scan554 файлов GREEN; повторная генерация даёт тот же SHA256 output. Существующие Windows goldens сравнивались без обновления.

## Исходная точка

До задачи106 в app/TournamentApp использовался MaterialApp с PlaceholderScreen.25 независимых screens получают presentation data и callbacks, доступны через Widgetbook. Источника состояния турнира пока нет. Navigation нельзя подменить соединением Widgetbook fixtures: они остаются детерминированными preview.

## Поток

```text
Screen callback → presentation controller → NavigationIntent
  → app NavigationCoordinator → NavigationGuard → NavigationDecision
  → app NavigationEffectExecutor → typed go_router route → route binding → screen
```

Screen отображает контракт и делегирует действие. Он не знает ни URL, ни route-классов, ни push/go/pop. Controller выражает намерение: открыть профиль, начать настройку турнира, продолжить выбранный турнир, вернуться назад. Одно намерение может привести к разным переходам в зависимости от актуального состояния.

Это описание целевого механизма. В текущем runtime есть только OpenProfileIntent, OpenTournamentIntent, BackRequestedIntent и BootstrapCompletedIntent. Добавление намерений настройки, истории и следующих этапов отложено; регистрация route сама их не создаёт.

Guard проверяет намерение вместе с текущим местом навигации и immutable snapshot состояния. Возвращает типизированное решение и ничего не открывает. Effect executor принимает только одобренную команду и выполняет ровно одно действие через router. Coordinator связывает эти операции, обрабатывает очередь и возвращает feedback.

## Владение и зависимости

| Контракт/реализация | Размещение | Ответственность |
| --- | --- | --- |
| NavigationIntent, специализированные намерения, NavigationIntentSink, UI feedback | presentation/navigation | Чистые Dart-контракты намерений, не зависят от go_router/app |
| Screen-specific controller/binding contract | presentation/screens/<screen> | Превращает действие в намерение; business use cases вызывает controller |
| Typed routes, route tree, builders/bindings | app/routing | Адресация, декодирование параметров, сборка screen с зависимостями |
| Coordinator, guard, decisions, effects, snapshot bridge | app/navigation | Политика переходов и выполнение через router |
| Бизнес-инварианты и queries | domain, когда появятся | Истинные правила турнира; app guard не дублирует их |

Presentation controller получает NavigationIntentSink через constructor injection. App реализует этот контракт, импортируя presentation, как уже разрешено матрицей. Presentation не импортирует app. IntentSink возвращает presentation feedback без route/effect/GoRouterState.

В domain не появляются маршруты, URL, названия экранов и push/pop. Infrastructure для go_router не нужен: библиотека относится к app-routing. Guard не получает BuildContext, widgets, глобальный DI или repository. Он использует snapshot, подготовленный штатными controllers/use cases, и не запускает бизнес-сценарий в обход state. Если данных нет, решение сообщает о необходимости их получить, а не угадывает состояние по URL или видимому тексту.

## Типы

Имена ниже — проект контракта, не уже существующий API:

- NavigationIntent — sealed family: OpenProfileIntent, OpenHistoryIntent, ConfigureTournamentIntent, ContinueTournamentIntent(типизированный TournamentId), BackRequestedIntent. Продолжение получает идентификатор предметного объекта, не route/location.
- NavigationContext — фактически подтверждённый текущий route instance, идентификатор записи стека и версия navigation/app state. Это app-контракт; presentation его не создаёт и не присылает произвольный from-route.
- NavigationDecision — sealed: Allowed(effect), Denied(reason), ConfirmationRequired(request). ConfirmationRequest содержит тип/данные вопроса и одноразовый request ID, не callback произвольного кода.
- NavigationEffect — sealed команды PushRoute, GoToRoute, ReplaceRoute, PopRoute. У Push/Go/Replace обязательный конкретный typed route; у Pop — типизированный результат и проверенная запись стека. Отсутствующие результаты представлены отдельным NoResult/void-контрактом, не dynamic.
- NavigationExecutionResult — Executed, Cancelled, Stale, Failed с типизированной причиной. Разрешение guard ещё не означает успешное выполнение навигации.
- Уточнение тестового контракта: executor.execute возвращает Future<NavigationExecutionResult>; конкретные варианты NavigationExecutionSucceeded/NavigationExecutionFailed содержат типизированный outcome. Ошибка routerUnavailable преобразуется coordinator в presentation NavigationFailureReason.routerUnavailable. Ни bool fail, ни строка/StateError не являются контрактом ожидаемого отказа. Непредвиденные исключения SDK перехватываются библиотечным адаптером и превращаются в типизированный Failed, техническая диагностика не раскрывается UI.
- Presentation feedback — Accepted, Rejected(типизированная UI-причина), ConfirmationRequested, Failed. Не содержит route, URI или команды стека. Тексты переводятся через intl.

Для маршрутов с результатом предусмотреть привязку результата к конкретному route-контракту: закрытие редактирования не должно позволять вернуть результат другого экрана. Точную generic-сигнатуру проверяем compile fixtures при реализации; go_router push<T> сам по себе не связывает T с классом destination. Не обещать эту гарантию без собственной типизированной границы и теста.

## Typed routes и go_router

Выбираем штатные GoRouteData + TypedGoRoute и go_router_builder/build_runner. Каждый адресуемый экран получает отдельный route-класс с обязательными типизированными параметрами. В коде app используются объекты вроде ProfileRoute(), TournamentRoute(tournamentId), не строковые константы и goNamed.

Не создаём параллельный enum всех маршрутов с ручной таблицей enum→path. Классы typed routes являются источником истины для destinations; snapshot/current-location сопоставляется с ними на app-границе. Варианты display state одного экрана не превращаются автоматически в49/50 отдельных маршрутов preview.

Пути в annotations и generated location неизбежно являются строками URI-протокола. Они разрешены только в app/routing и generated codec. Effect adapter может передать generated location в низкоуровневый router API, если API требует этого; вручную собирать URL или сравнивать пути вместо типов нельзя. Нельзя передавать generated go()/push() helpers в screens: такое вызовом обходит guard.

Долгоживущая адресация содержит валидируемые идентификаторы и сериализуемые параметры. Mutable screen-state, controller и domain entity не перевозятся через dynamic extra. Допустимый ввод URL парсится в typed destination, неверный — в типизированную ошибку; произвольный returnTo URL не используется для продолжения.

Каждый screen addressable отдельно; несколько workflow-адресов могут использовать одну композицию (например, разные операции loading на UtilityScreen). Dialog/bottom sheet получает route только когда нуждается в history/deeplink/result; локальное раскрытие details маршрутом не является. GuestRemove/Withdraw/Forfeit/MatchResult рассматриваются отдельно от обычных страниц, форма представления не меняется одной лишь сменой router.

## Проверки и выполнение

1. Controller передаёт намерение через sink. Доступность кнопки — подсказка UI, guard всё равно проверяет актуальное состояние.
2. Coordinator serializes изменение navigation state, читает fresh snapshot и текущую подтверждённую конфигурацию.
3. Guard возвращает решение. Denied не меняет стек. ConfirmationRequired приостанавливает намерение; отмена уничтожает continuation.
4. После подтверждения guard проверяет переход заново. Старое разрешение не переносится на изменившийся турнир или другой экран.
5. Перед effect commit сверяются route entry и state revision; проверка и запуск effect выполняются без async-gap. Устаревший запрос отклоняется/переоценивается, не выполняется по старому разрешению.
6. Effect выполняется once; исключение превращается в Failed. Текущий маршрут обновляется из реально committed router configuration, не сразу после вызова go/push. Completion push при закрытии экрана отличается от факта открытия.

Повторные нажатия на один и тот же переход обрабатываются как один in-flight запрос. Очередь ограничена жизнью controller: намерение уничтоженного экрана не должно навигировать позже. Не сериализовать очередь на весь Future push, иначе открытый экран заблокирует дальнейшую навигацию до своего закрытия.

Coordinator владеет общим OperationScope: dispose прекращает доставку и завершает pending ожидания NavigationCancelled, включая активный execute и очередь. Submit после dispose не читает router context; dequeued запрос проходит scope до guard/execute. Отдельного bool dispose нет. Уже выполненное SDK-действие не откатывается; физически неотменяемый execute Future может завершиться позже, его результат наблюдается без повторной доставки. Подробности и проверки — [отменяемые операции](cancellable-async.md).

Одновременно допускается не более одного effect execute. Вход привязывается к конкретному route entry через app-created scoped sink (bindToCurrentEntry); presentation не получает route/GoRouterState и не может указать произвольный from-route. Связь сохраняется на всё время жизни screen/controller, а не вычисляется заново при каждом позднем callback.

Два in-flight запроса с одинаковым origin, видом intent и равными типизированными payload объединяются в один transition с общим исходом. Равенство — по значениям, не по идентичности объектов и не только runtimeType. Два однотипных запроса с разными payload из одной исходной записи конфликтуют: первый выполняется, второй получает NavigationConflict(competingTransition); два экрана не открываются.

Остальные запросы могут ожидать освобождения executor, но guard проверяет свежий state И первоначальный origin. Очередь не наделяет старый callback правами нового экрана. OpenProfile и сразу Back от Home приводят к одному Push; Back отклоняется как stale после смены записи. Back из открытого Profile должен поступить от нового scoped sink этого Profile. Двойной Back из одного entry объединяется в один Pop с проверенным target entry; поздний Back от уничтоженного entry не закрывает новую запись даже с тем же route-классом.

Освобождение executor обязательно при ошибке/отмене; decisions для очереди не кешируются. У accepted opening transition есть один result channel, связанный с записью открытого экрана и вызвавшим его transition; coalesced observers получают тот же исход, а не создают дополнительные result channels. Одна операция Pop доставляет результат этой записи; произвольное завершение чужого запроса невозможно. Compile/runtime тесты результатов будут добавлены при конкретном typed-result API; текущие Home/Profile сценарии не выдаются за его покрытие.

Navigation guard проверяет возможность доступа, а не заменяет domain-валидацию действий. Навигация на «результаты» не завершает турнир. Выбор победителя и сохранение результатов остаются отдельным действием controller/use case.

## Внешние входы и Back

Декодирование deeplink, cold start, browser history, системный Back, жест закрытия sheet и программный pop учитывают ту же политику. URL не считается источником права на экран. App-адаптеры go_router onEnter/onExit и Flutter pop handling направляют события к общей guard-политике; не создают отдельные противоречащие наборы условий.

Effect-origin request содержит внутреннюю корреляцию с уже проверенным переходом. Router hooks не должны повторно породить такое же намерение и уйти в рекурсию; внешний переход, напротив, проходит полноценную проверку. Корреляция не является глобальным bypass и связана с конкретными from/to/revision.

У прямого входа может отсутствовать предыдущий экран. Block на cold start требует безопасной error/bootstrap конфигурации; нельзя полагаться на pop к несуществующей записи. Доступный fallback определяется типизированной политикой; redirect cycles ограничиваются и тестируются. Конкретные hooks зависят от выбранной совместимой версии пакета и проверяются интеграционными тестами.

## Предварительная политика стека

Предлагается для первого этапа: bootstrap→home через go; из home в profile/history/setup — push; закрытие дочернего экрана — pop, если запись существует; прямой вход без родительской записи — guard выбирает типизированный fallback. Завершение крупного workflow может использовать go, чтобы Back не возвращал пользователя в уже недействующий этап.

Это предложение, не утверждённые бизнес-правила турнира. Допустимость переходов setup→roster→distribution→live→results и ограничения выхода при несохранённых данных необходимо привязать к реальным состояниям controllers. Сейчас источника этих состояний нет. Не выводить бизнес-допуски из Widgetbook samples и не выдумывать их по макетам.

## Этапы внедрения

По итоговому scope задачи106 завершены механизм, первый сквозной сценарий и typed registry всех25 экранов. Следующие пункты сохраняют первоначальную последовательность проектирования; оставшаяся часть с результатами экранов, confirmation и бизнес-флоу не является обязательством текущей задачи и будет выполняться по отдельному запросу.

1. Согласовать это решение и таблицу первых разрешённых переходов. Подготовить tests guard/effect/typed routes и architectural negative fixtures, подтвердить RED по workflow.
2. Подключить совместимые go_router, builder и генератор; заменить MaterialApp на MaterialApp.router. Реализовать минимальный маршрут bootstrap/home и один сквозной сценарий OpenProfileIntent→guard→effect→ProfileRoute→Back. Данные preview не использовать как production storage.
3. Подключить остальные независимые страницы и возвращаемые результаты. Внедрить контракты в bindings/controller; сами screens остаются независимо вызываемыми в Widgetbook.
4. Подключать турнирные адреса по мере появления действительного session state и domain use cases; для каждого перехода нужна явная policy. Не маскировать отсутствие domain универсальным guard alwaysAllowed.
5. Защитить внешние входы, pop/gestures, подтверждения и async races; проверить полный flow, analyser, guards и native goldens.

## Архитектурная проверка и code generation

При реализации расширить checker: go_router/GoRouterData/GoRouterState и low-level Navigator navigation нельзя использовать в presentation/domain; typed route declarations живут в app/routing; только effect adapter вызывает императивные go/push/replace/pop. Проверять barrel/part/transitive exposure, generated files и отрицательные fixtures. Файл с именем effect сам по себе исключением не считается.

Текущий R-003.g запрещает top-level functions, а R-003.e — relative part. go_router_builder генерирует Dart с part и может добавлять top-level functions. Сначала исследовать фактический вывод выбранной версии. Package URI применять там, где поддерживает генератор; точные неизбежные исключения документировать и покрывать positive/negative tests. Не делать blanket-ignore для *.g.dart или всей app/routing. Не редактировать generated код вручную. Regeneration проверяется на reproducibility.

## Сценарии приёмки

- Constructor typed route требует обязательные параметры; неправильный destination/result type не компилируется. Round-trip URI сохраняет параметры; malformed/missing ID выдаёт controlled error.
- Один и тот же intent даёт разные Allowed/Denied по state; effect не вызывается при Denied, не вызывается до подтверждения и вызывается once при Allowed.
- Устаревшая версия, двойное нажатие, dispose controller, ошибка effect и отмена подтверждения не создают лишних переходов.
- Push сохраняет родительскую запись; go заменяет выбранную конфигурацию; pop возвращает правильный результат. Cold start и direct link не предполагают существующего parent.
- Back/браузерная история/deeplink/жест не обходят guard; хуки не зацикливаются.
- Screen и Widgetbook работают без router; запрещённый import/вызов отклоняет checker. Прежние goldens совпадают при одинаковом state.

## Источники

- [go_router: typed routes](https://pub.dev/documentation/go_router/latest/topics/Type-safe%20routes-topic.html): штатные route-классы и generated helpers.
- [go_router_builder](https://pub.dev/packages/go_router_builder): code generation, part, typed parameters и настройки коллизий paths.
- [go_router OnEnter](https://pub.dev/documentation/go_router/latest/go_router/OnEnter.html): типизированные Allow/Block на библиотечной границе. Наш NavigationDecision шире этого SDK-контракта и остаётся собственным app-контрактом.

Версии пакетов и точные API проверяются при реализации на SDK проекта. Источники подтверждают возможности библиотеки, а разделение intention/guard/effect и policies — проектное предложение.
