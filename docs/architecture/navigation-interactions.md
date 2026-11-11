# Возврат данных из экранов и модальные взаимодействия

Принято2026-11-10 как продолжение задачи106. Реализованы InteractionOutcome, InteractionOperation, внутренний InteractionResultChannel и общие push/modal adapters. Конкретные request/result pairs, screen bindings и их wiring в guard/effect ещё не реализованы по прямому запросу пользователя. Базовые routing, intents/guard/effect и25 routes уже существуют. Новый flow приложения не добавляется.

## Реализованные контракты

InteractionOutcome<Result extends Object> — sealed-модель в presentation/navigation. Completed хранит типизированное значение; Cancelled — причину отмены; Failed — причину отказа. Factory fromNullable переводит null SDK-результата в dismissed. Этот factory не запускает dialog/picker.

InteractionResultChannel<Result> находится в app/navigation. Его entryId — целевая запись child/overlay, а не вызывающая запись. complete проверяет source entry и возвращает InteractionCompletion.wrongEntry при несовпадении. Завершение, отмена и отказ публикуют первый исход; последующие попытки возвращают alreadyCompleted. Проверка и завершение выполняются синхронно в одном isolate, без await между ними. Отдельный lifecycle bool не вводится.

InteractionOperation<Result> предоставляет две переданные владельцем Future и cancel. Cancel вызывает onCancel ровно один раз, кеширует Future очистки до вызова callback и возвращает тот же Future при повторе. Ошибки callback передаются вызывающему через этот Future. Владелец callback обязан завершить открытие/результат и освободить ресурсы, включая отмену до подтверждения открытия. При уже принятом открытии transition остаётся Accepted, а result может стать Cancelled.

Сам handle не закрывает Navigator и не отменяет произвольный входной Future: это делает владелец onCancel. Общие adapters ниже уже предоставляют такой cleanup и возвращают operation. Существующие продуктовые intentions пока их не используют; текущий GoRouterEffectExecutor сохраняет прежний push<void> до подключения конкретных bindings.

## Общие adapters: фактический API

Все типы ниже находятся в app/navigation. Они не импортируются presentation и не выбирают бизнес-допуски.

| API | Механика |
| --- | --- |
| GoRouterPushInteractionAdapter.open<Result>(AppRoute, entryId) | Типизированный адрес через go_router, отдельный native push и его результат |
| FlutterModalInteractionAdapter.dialog<Result>(entryId, builder) | SDK DialogRoute |
| FlutterModalInteractionAdapter.modalBottomSheet<Result>(entryId, builder) | SDK ModalBottomSheetRoute с drag/barrier dismissal |
| FlutterModalInteractionAdapter.bottomSheet<Result>(entryId, builder) | Scaffold.showBottomSheet и принадлежащий ему controller |
| FlutterModalInteractionAdapter.datePicker(entryId, options) | SDK DatePickerDialog внутри собственного DialogRoute<DateTime> |

Каждый API возвращает app-only InteractionPresentation<Result>. Его operation — presentation-контракт ожиданий/отмены, complete(Result) — app-команда завершения для будущего effect. Параметр entryId предоставляет app; adapters не выводят его из названия экрана. Контент поступает через WidgetBuilder; ни одного screen-specific binding внутри нет. Стандартные SDK widgets используют текущую Material theme; новые проектные DS-компоненты/стили не создавались.

DatePickerInteractionOptions хранит initial/current/first/last calendar dates без времени. Границы включительны; обратный диапазон или initial вне диапазона отклоняется ArgumentError как ошибка конфигурации. CurrentDate может лежать вне диапазона доступного выбора. Это технический контракт date picker, не бизнес-правило турнира.

### Ключи, observer и подтверждение открытия

GoRouterPushInteractionAdapter принимает существующий router и InteractionRouteObserver, зарегистрированный при построении соответствующего Navigator (для обычного router — observers GoRouter). Observer хранит native routes по Page.key и освобождает записи при pop/remove/replace; страницы без key игнорируются. Нужно передавать observer именно Navigator-владельца запрашиваемой страницы. Не подключённый host/observer даёт presentationUnavailable.

Push связывается с конкретным ImperativeRouteMatch через identity его Completer из RouteInformationState, не через одинаковые URL. Подтверждение приходит после первого frame с native page. Для закрытия покрытой страницы строится новый RouteMatchList с удалением только собственного match, сохраняя остальные записи; go_router restore согласует реальный Navigator. Используются публичные constructors/exports pinned go_router18.1.4, без src-import, internal copyWith или ignore. SDK remove() здесь не используется, поскольку обрезает весь хвост истории.

Modal adapter получает navigatorKey и scaffoldKey явно. Переданный Navigator определяет root/local размещение; ближайший произвольный Navigator не ищется. Dialog/modal sheet считаются открытыми после принятого native push, не после загрузки контента. Обычный sheet дополнительно дожидается frame с controller UI перед close: SDK нельзя закрывать до построения его State.

### Завершение и отмена

Complete закрывает принадлежащий operation route/controller и возвращает InteractionCompletion.accepted. Повторный/поздний complete возвращает alreadyCompleted. Native null переводится в dismissed; значение сохраняет Result. Requested, ownerEnded и технический failure не заменяются друг другом при поздних событиях.

Каждый adapter имеет идемпотентный close(): все его pending interactions завершаются ownerEnded, новые открытия после close дают typed failure. Framework владеет стандартными route animations, adapter — собственными callbacks/ожиданиями. Сборщик app обязан вызвать close при завершении своего scope; общего автоматически внедрённого lifecycle framework нет. Cleanup также проверен после unmount Navigator/Scaffold. У уже завершённой операции первый исход сохраняется.

При повторном bottomSheet adapter сначала явно закрывает свою предыдущую панель и завершает её dismissed. Это необходимо: в используемом Flutter _closeCurrentBottomSheet не гарантирует завершение closed для панели с LocalHistoryEntry при прямой замене. Старый controller не может закрыть новый. SDK-точка _openSheet содержит этот асинхронный порядок; tests/checker разрешают её адресно.

Техническая невозможность открыть interaction завершает transition как NavigationFailed(routerUnavailable), result как InteractionFailed(presentationUnavailable). Показанный UI не объявляется «никогда не открывавшимся»: при отмене во время первого frame transition может быть Accepted либо Cancelled, результат и cleanup при этом завершаются.

### Границы готовности

Adapters готовы к последующему вызову из app effects. В обычный запуск приложения они пока не подключены. Guard/сериализация и связывание конкретного request с Result остаются ответственностью будущего app binding; сами generic adapters этого не доказывают. Child state не должен получать InteractionPresentation publisher. Нужен отдельный completion port конкретного результата при реализации экрана.

Проверены27 widget scenarios настоящих GoRouter/Navigator/Scaffold и3 unit scenarios date options, включая nested root/local Navigator, covered push cancellation, Back/barrier/drag, замену controller sheet, выбор даты, unavailable host и cleanup после unmount. Общая замена coordinator _disposed по-прежнему отложена. Произвольные topology/redirect/onExit бизнес-политики не выдаются за проверенные screen bindings.

## Открытие и завершение — разные события

Пользовательский запрос возвращает InteractionOperation<Result extends Object>. Его transition сообщает NavigationFeedback об открытии, result — InteractionOutcome<Result> о завершении, cancel завершает запрос отменой. Отказ открытия завершает оба ожидания: transition содержит отказ, result — типизированный отказ, а не бесконечно ожидающий Future. Техническая ошибка остаётся ошибкой; отмена не маскирует её.

InteractionOutcome<Result> имеет варианты InteractionCompleted(value), InteractionCancelled(reason), InteractionFailed(reason). Причины отмены: пользовательское закрытие без значения, явный запрос отмены, завершение владельца, вытеснение другим сценарием. Значение результата не является bool-дискриминатором или Object?/Map payload. Nullable-значения внешнего API преобразуются на границе в отдельный cancelled outcome; тип Result не nullable.

Пока effect открывает экран, действует существующая сериализация. После подтверждения открытия блокировка очереди освобождается. Ожидание result продолжается отдельно и не удерживает очередь: иначе Back/завершение того же экрана окажутся за незавершённым push. Coalesced opening requests разделяют одну принятую операцию и один result channel; конфликтующие payload не открывают второй экран. Отказ до открытия не создаёт лишний channel.

```text
state → typed request → guard → opening effect → opening acknowledged
                               │                  ↓ очередь свободна
                               └──────── result channel ждёт отдельно

child state → typed completion intention → guard → targeted close effect
                                                   ↓
                                            channel завершён
                                                   ↓
                                          результат вызывающему state
```

## Типы и владение

| Контракт | Владелец/слой | Назначение |
| --- | --- | --- |
| InteractionOutcome<Result> | presentation/navigation | Значение, отмена либо отказ взаимодействия, без SDK-типов навигации |
| InteractionOperation<Result> | presentation/navigation | Два независимых ожидания и явная отмена |
| Конкретный request и completion port<Result> | presentation | Компилятор связывает вид взаимодействия с результатом; state не выбирает route/pop |
| InteractionResultChannel<Result> | app/navigation, внутренний | Доставка результата ровно один раз, привязанная к целевому route/overlay entry |
| Route/result binding | app | Связывает конкретный request, конкретный route и completion port того же Result |
| Modal adapter | app | Владение Flutter route/controller, root/local navigator и точным закрытием overlay |
| Локальный picker wrapper | presentation/design_system | Только визуальный выбор значения, без бизнес-операции/роутера |

Нельзя дать виджету сам publisher app result channel, произвольный generic pop<Result> или AppRoute. Child state получает только типизированный completion port нужного результата. Закрытие идёт через guard/effect, после принятого закрытия app публикует исход. Сам result channel не заменяет guard и не разрешает переходы.

Typed push<Result> из go_router допускает выбор generic вызывающим кодом и сам не связывает Result с route. Требуемый контракт задаётся конкретной request/result парой и её app binding, с compile-positive и compile-negative проверками несовместимых результатов. Произвольный тип не должен проходить через Object и поздний cast вместо этой связи.

Child entry и caller entry различаются. Child может завершить только собственный channel; старый callback не закрывает новую запись того же route. Caller может быть временно под child и поэтому не обязан быть текущим экраном во время ожидания. Если caller действительно уничтожен, поздний результат ему не доставляется. У прямого deep link может не быть caller: закрытие регулируется guard, ожидатель результата не выдумывается.

## Модальные шаги сценария

Подтверждение удаления, выбор результата матча и другие шаги бизнес-сценария запускает state через typed request. Guard проверяет origin/state; app effect выбирает dialog, modal sheet либо другой способ отображения. State не выбирает Flutter API. Modal не обязан иметь самостоятельный URL; существующий route экрана не означает уже реализованный sheet workflow.

На SDK-границе showDialog<Result>/showModalBottomSheet<Result> возвращают Future<Result?>; showDatePicker возвращает Future<DateTime?>. Null при закрытии/Back/свайпе/нажатии на barrier переводится в InteractionCancelled(dismissed). Успешный выбор — InteractionCompleted. Ошибка открытия/адаптера не преобразуется в «пользователь отменил».

showBottomSheet возвращает PersistentBottomSheetController, а не Future<Result?>. Его адаптер владеет controller и слушает closed; результат приходит из typed callback содержимого. Закрытие без выбранного значения означает отмену. Повторные close/callback безопасны и не доставляют результат дважды.

Каждая modal-операция хранит собственный route/controller handle. root/local navigator выбирается адаптером явно; закрытие по принципу «pop того, что сейчас сверху» запрещено: поверх могло открыться другое окно. Native Back/barrier/drag и программное закрытие сходятся в одном exactly-once completion. Удаление parent route не оставляет бесхозное окно и ожидатель.

## Локальные визуальные взаимодействия

Календарь поля, dropdown, локальная панель выбора — ответственность DS-компонента с собственным visual state. Компонент может использовать Flutter picker/modal внутри своей изолированной реализации, преобразовать native outcome и передать значение именованным callback в presentation state. Отдельные business intent/route для каждого dropdown не нужны.

Screen по-прежнему только компонует DS. Он не вызывает showDialog/showDatePicker/showBottomSheet и не содержит обработку бизнес-подтверждения. State/controller также не получает BuildContext/Navigator для показа окна. Если выбор запускает бизнес-действие или меняет сценарий, используется app interaction pipeline.

Checker сохраняет точечные локальные Select/Widgetbook open/pop и разрешает общие app adapters по path/class/method/API. Новые разрешения для local modal adapter требуют таких же positive/negative tests; любой файл с названием modal не получает blanket exemption.

## Отмена и отложенный lifecycle

Применяется [R-009](../../ai-context/rules/core/009-cancellable-async.md). Операция предоставляет отмену, но обычный Future не принудительно останавливается. Для уже открытого UI адаптер закрывает именно принадлежащий ему route/controller; ранее выполненный push не объявляется никогда не происходившим. Cleanup закрытия завершается независимо от отменённого ожидателя.

Выбор общей cancellation/lifetime реализации, замена _disposed и shutdown уже активного executor — отдельное отложенное обсуждение третьего вопроса пользователя. Текущая архитектура не объявляет прежний runtime уже соответствующим этому решению.

## Состояние этапов

Контракты и общие adapters реализованы и проверены отдельно. Тесты используют минимальный технический контент, настоящий GoRouter/Navigator/Scaffold и DatePickerDialog. Они не добавляют production screens и не являются screen-specific bindings.

По уточнению пользователя2026-11-10 задача106 завершается на общем механизме. При реализации экранов будут добавлены конкретные request/result пары, completion ports и wiring в queue/guard/effect. Эти bindings должны иметь compile-negative fixtures несовместимых результатов и сквозные tests бизнес-намерения → разрешённый переход → typed close → caller state. Наличие generic push<Result> или один GREEN result channel этого не доказывают.

Общая библиотека lifecycle и существующий coordinator _disposed остаются отдельной темой, отложенной пользователем. Ресурсный close новых adapters не является массовой миграцией lifecycle приложения.

## Источники

- [go_router: возвращаемые значения](https://pub.dev/documentation/go_router/latest/topics/Navigation-topic.html).
- [showDialog](https://api.flutter.dev/flutter/material/showDialog.html), [showDatePicker](https://api.flutter.dev/flutter/material/showDatePicker.html).
- [showModalBottomSheet](https://api.flutter.dev/flutter/material/showModalBottomSheet.html), [showBottomSheet](https://api.flutter.dev/flutter/material/showBottomSheet.html).
