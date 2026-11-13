# Типизированное логирование

## Решение и границы

Решение2026-11-11, задача110: код приложения передаёт типизированные события через собственный Logger, а способ вывода определяется конечным адаптером. Navigation и network имеют независимые destinations. Сейчас реализован только синхронный print в консоль; HTTP-логирование, очередь доставки на сервер и сторонние logging-пакеты ещё не подключены.

```text
NavigationLogger ─→ SinkLogger<NavigationLogEvent> ─→ navigationSink
NetworkLogger    ─→ SinkLogger<NetworkLogEvent>    ─→ networkSink
BootstrapLogger  ─→ SinkLogger<BootstrapLogEvent>  ─→ bootstrapSink
ProfileLogger    ─→ SinkLogger<ProfileLogEvent>    ─→ profileSink

AppLoggers выбирает sinks независимо.
PrintLogSink → LogLineFormatter → print
```

Направление импортов сохраняет [границы слоёв](layer-boundaries.md). Logger — диагностический контракт приложения; LogSink — техническая граница вывода, доступная infrastructure и app. Нет глобального registry/service locator. Реализации не попадают в domain или presentation.

## Контракты и размещение

| Элемент | Расположение | Ответственность |
| --- | --- | --- |
| Logger<Event extends LogEvent> | domain/logging/logger.dart | Принять событие конкретного типа и вернуть типизированный исход записи |
| NavigationLogger / NetworkLogger | domain/logging/*_logger.dart | Алиасы Logger для разных событий, без дублирования реализации |
| NavigationLogEvent / NetworkLogEvent | domain/logging/*_log_event.dart | Типизированное событие с собственным LogScope |
| LogRecord | domain/logging/log_record.dart | Неизменяемые event, level, timestamp, message, error и stackTrace |
| LogScope / LogLevel | domain/logging | Типизированные каналы и уровни debug/info/warning/error |
| LogSubmissionResult | domain/logging | LogAccepted либо LogRejected(error, stackTrace) |
| LogSink | infrastructure/logging/log_sink.dart | Синхронная техническая граница принятия записи |
| SinkLogger<Event> | infrastructure/logging/sink_logger.dart | Сформировать запись, добавить время, передать sink, изолировать его ошибку |
| PrintLogSink | infrastructure/logging/print_log_sink.dart | Единственная точка вызова print |
| LogLineFormatter | infrastructure/logging/log_line_formatter.dart | Консольная рамка, подписи и форматирование многострочных данных |
| AppLoggers | app/logging/app_loggers.dart | Выбрать отдельные sinks и собрать typed logger каждого scope |
| NavigationLogTrace | app/navigation/navigation_log_trace.dart | Перевести факты app-навигации в diagnostic message и typed event |

Контракты domain используют только Dart SDK; зависимостей от Flutter, инфраструктуры или logging-библиотек нет. LogSink не нужен потребителю Logger: это интерфейс технического output внутри infrastructure. Потребители — app-навигация/bootstrap и domain-сценарий изменения имени; прямой вызов domain ports из presentation-state по-прежнему не разрешается этим документом. Widgets не получают логгер.

## Типизация

Scope берётся из события, а не передаётся строкой при каждом вызове. NavigationLogger принимает только NavigationLogEvent; NetworkLogger — только NetworkLogEvent. Компилятор отвергает вызов navigationLogger.log(NetworkLogEvent.requestStarted). Общий Logger не импортирует конкретные типы scoped-логгеров.

Роутинг и сравнения не используют .name/toString. Enum преобразуется в текст только на границе вывода; NavigationLogTrace формирует диагностические подробности из уже типизированных intent/effect/feedback. Свободная message — текст диагностики, не discriminator и не пользовательский UI. Это следует [R-004](../../ai-context/rules/core/004-typed-values.md); исключение для нелокализованных diagnostic messages уже предусмотрено R-005.

При добавлении scope: определить новый typed event и его LogScope, alias Logger<NewEvent> и app wiring выбранного sink. Общий SinkLogger и PrintLogSink копировать не нужно.

Задача111 добавила BootstrapLogger = Logger<BootstrapLogEvent> и LogScope.bootstrap. AppLoggers принимает отдельный bootstrapSink (по умолчанию PrintLogSink); ранний logger позволяет диагностировать pre-app шаги до готовности приложения. Bootstrap-события не меняют направления navigation/network. Фактические lifecycle/step events описаны в [bootstrap](bootstrap.md).

### Логирование изменения имени · задача114

Добавлены ProfileLogger = Logger<ProfileLogEvent>, LogScope.profile и независимый profileSink в AppLoggers (по умолчанию PrintLogSink). Новые события: updateStarted, readStarted/readCompleted, writeStarted и итоговые updateSucceeded/updateRejected/updateFailed/updateCancelled. Их пишет ProfileUpdateTrace из реального domain UpdateProfileNameUseCase; widgets/controllers не получают диагностический port напрямую. Другие destinations не меняются.

Каждый start получает UniqueIdentifier от общего генератора для diagnostic execution, не для замены ProfileId. Контекст содержит действие/фазу validation/reading/writing, номер попытки формы, измеренную длительность и конкретный исход. ProfileEditController увеличивает номер только для фактического save, не для duplicate submit. Retry получает новый execution ID; неизменившееся нормализованное имя заканчивается success без повторного write. Started означает запуск сценария проверки запроса, writeStarted — фактический старт repository.save.

Typed validation/notFound rejection не получает фиктивный stack. Технический failure сохраняет доступную ProfileException/cause и исходный stackTrace; причина/источник/фаза и последствия вынесены в подробности. Для reading отказ означает «запись не начиналась», для writing — «подтверждения нет, фактический итог может требовать чтения», а не гарантированный rollback. Cancelled не превращается в success после позднего ответа. Сбой sink остаётся LogRejected и не отменяет реальную запись.

Имя, новый ввод, ProfileId и JSON payload не записываются в message. ProfileException.toString отображает reason и тип cause; исходная cause остаётся в объекте для диагностики. Неизвестная техническая ошибка оборачивается диагностическим объектом с исходной cause и безопасным текстом типа источника, без raw exception payload. Stack trace сохраняется; внешние/удалённые adapters по R-010 по-прежнему ответственны за безопасную сериализацию чувствительных данных, а не за автоматический dump вложенных объектов.

Проверки используют реальный use case и независимый profile sink: ошибка записи не даёт ложного success, cause/stack/execution сохранены, имён в сообщениях нет, LogRejected не ломает save. Эта инструментализация относится к изменению имени; полный аудит старых bootstrap/navigation/network логов по R-010 не заявляется. Persistent registration/старые пути не были массово переинструментированы.

## Независимые адаптеры

Текущий запуск использует AppLoggers.console(): navigation/network/bootstrap/profile направлены в PrintLogSink. При другой сборке sinks задаются отдельно:

```dart
final loggers = AppLoggers(
  navigationSink: const PrintLogSink(),
  networkSink: remoteNetworkSink,
);

final navigation = AppNavigationSession(logger: loggers.navigation);
```

remoteNetworkSink здесь — параметр будущей сборки с реализацией LogSink, а не существующий серверный адаптер. Network-потребитель получит loggers.network при реализации HTTP-механики. Для замены networkSink не требуется менять navigation logger или правила вывода navigation-логов.

Domain/application consumers зависят только от Logger и своих событий. Сторонняя библиотека, HTTP либо запись в файл появляются только внутри конкретного infrastructure adapter. Generic sink получает исходные типизированные записи, а не обязан разбирать текст PrintLogSink.

## Оформление вывода

PrintLogSink передаёт одну полностью сформированную запись в один вызов print. Строки события не перемешиваются несколькими вызовами самого адаптера. Поддержка ANSI/цветного терминала не требуется. Формат включает рамку, scope, level, время UTC, event и дополнительные секции:

```text
┌─ [navigation] [info] ────────────────────────────────────────────────────
│ Время UTC:
│   2026-11-11T11:01:30.261092Z
│ Событие:
│   NavigationLogEvent.requested
├────────────────────────────────────────────────────
│ Подробности:
│   Намерение: OpenProfileIntent
│   Исходная запись: 2
│   Переход запрошен.
└────────────────────────────────────────────────────
```

Пример взят из настоящего print во время navigation regression tests. Каждый перевод строки message/error/stackTrace получает префикс рамки. Длинные значения не обрезаются. Если присутствуют error/stackTrace, formatter добавляет секции «Ошибка»/«Стек». Stack trace не выдумывается для типизированного отказа без исключения.

## Жизненный цикл навигационных логов

AppNavigationSession создаёт консольный NavigationLogger по умолчанию; при constructor injection используется переданный logger. NavigationCoordinator принимает только domain NavigationLogger и не импортирует инфраструктуру.

- requested записывается при принятии request factory открытым scope. Origin определяется внутри неё: после dispose контекст router не читается ради логирования.
- started появляется только после guard/revision проверки, непосредственно перед запуском executor. В подробностях есть тип эффекта, текущий экран, назначение и ревизия.
- coalesced сообщает о присоединении совпадающего запроса, не означает второй execute.
- accepted/rejected/stale/conflict/cancelled/failed формируются из фактического feedback каждого submit-caller. Совпавшие callers имеют по финальной записи, но одно started на общее выполнение.
- Реальное исключение executor сохраняет исходный error/stackTrace и прежний error-path caller. Типизированный NavigationFailed содержит доступную причину отказа в message.
- Dispose даёт cancelled, поздние success/error отменённой операции не становятся accepted/failed логами. Отмена ожидания не объявляет уже выполненный переход откатанным.

Уже закрытый scope может вернуть cancelled без requested: factory не запускалась. Наличие cancelled записи не даёт права дополнительно читать уничтоженный router. Навигационный trace не принимает решение о переходе и не заменяет guard.

## Ошибки и будущий async output

Logger.log не бросает сбой sink/formatter/clock в вызывающий сценарий: SinkLogger возвращает LogRejected с исходным исключением и stackTrace. Библиотечные адаптеры Logger обязаны сохранять этот контракт. Сбой не перенаправляется рекурсивно в тот же logger, не запускает автоматический retry и не блокирует другой scope. Если нужно реагировать на потерю диагностики, consumer может проверить LogSubmissionResult отдельно.

LogAccepted означает принятие записи адаптером. Для текущего print вывод синхронный; для будущей удалённой очереди это не будет подтверждением серверной доставки. Синхронный LogSink.write нельзя реализовывать как бесконтрольный async void: очередь/flush/cancel и обработка фоновых ошибок имеют явного владельца по [R-009](../../ai-context/rules/core/009-cancellable-async.md). Транспортный adapter инфраструктуры не импортирует presentation OperationScope в обход матрицы слоёв. Его runtime/ownership определяются в задаче реального транспорта.

## Проверка

Нормативное требование полноты диагностики с задачи113: [R-010](../../ai-context/rules/core/010-diagnostic-logging.md). Оно действует для всего проекта. Ниже — применение к существующему Flutter-контракту и примеры; автоматической проверки смысла сообщения пока нет. Добавление правила не означает, что все прежние вызовы logger уже прошли аудит.

### Почему одного текста отказа недостаточно

Запись `Ошибка` или `Не удалось выполнить запрос` не позволяет отличить отсутствие сети от нарушения предусловия, повреждённой локальной записи или сбоя cleanup. Даже scope и время не объясняют причину. Тип исключения без предметного контекста также может быть недостаточен: `ProfileException` имеет несколько разных причин. Диагностика должна сохранять доступную typed reason и цепочку cause вместе с фактическим stack trace, а не только имя класса.

В текущем Logger доступны typed event/level и message/error/stackTrace. Контекст можно оформить понятными именованными строками message из типизированных фактов trace-владельца, а исключение и стек передать отдельно через error/stackTrace. Отдельной модели произвольных structured metadata полей в API сейчас нет; документ её не вводит. Сырые сетевые/пользовательские payload не становятся message автоматически. PrintLogSink по-прежнему только оформляет запись; он не может угадать потерянную причину.

### Пример критического отказа

Пример ниже иллюстрирует достаточную диагностическую запись, а не снят с текущего runtime и не задаёт строковые discriminators приложения:

```text
[bootstrap] [error] BootstrapLogEvent.stepFailed
Выполнение: bootstrap-7/profile-read-1
Действие: загрузка локального профиля
Шаг: InitializeProfileStep, afterApplication
Ресурс: LocalProfile, чтение сохранённой записи
Условие: ожидается schema version 1, прочитана version 2
Причина: ProfileFailureReason.corrupt — неизвестная версия записи
Итог: профиль не загружен; запись не изменена
Продолжение: рабочие экраны заблокированы; доступен retry чтения
Длительность: 23 ms
Исключение: исходная цепочка cause без чувствительных данных
Стек: оригинальный stack trace этого отказа
```

Здесь version/phase/reason берутся из реально установленных фактов, длительность — из измерения, execution ID — из контекста конкретного выполнения. Если version или root cause неизвестны, лог сообщает об этом прямо: например «источник вернул технический отказ без подробностей», затем известные операция/этап/ресурс/typed code. Нельзя выводить «сервер недоступен», когда достоверно известен только timeout: причиной могут быть и сеть, и клиент, и сервер. ProfileId/имя/полный JSON для объяснения примера не нужны.

Успех этой операции — не «запрос отправлен», а профиль реально прочитан/декодирован. Если запись не найдена, это успешное чтение с исходом «профиль отсутствует; требуется регистрация», а не техническая ошибка. В случае попытки повторного чтения связываются исходное выполнение, номер попытки и новый фактический итог; предыдущий failure не переименовывается в success.

### Отмена, cleanup и уровни

| Ситуация | Какой факт должен быть ясен |
| --- | --- |
| Bootstrap не завершил обязательный шаг | Какой шаг, конкретная причина/неизвестность, блокировка запуска, допустимость retry |
| Сохранение профиля не подтверждено | Какая операция, typed reason, состояние записи подтверждено/неизвестно, дальнейшее действие; без имени пользователя/сырого payload |
| Guard отклонил переход | Intent, origin/текущее состояние и нарушенное предусловие; эффект не запускался, stack trace не выдумывается |
| Владелец отменил сохранение | Отменено ожидание/доставка; физически неотменяемая запись могла завершиться, rollback не подтверждён |
| Cleanup отказал после основной ошибки | Исходная ошибка и независимая ошибка освобождения, ресурс и известный итог cleanup; одно не затирает другое |
| Sink не принял запись | Основной сценарий продолжает прежний контракт; LogRejected не становится рекурсивным log в тот же sink |

Из существующих уровней info подходит для штатных значимых фаз/исходов и ожидаемой отмены, warning — для ожидаемого отказа/восстановления, error — для технического сбоя или незавершённого критического действия. Повторяемость отказа сама по себе не понижает error до debug. Debug оставляют подробностям, которые не нужны для восстановления критического пути. Конкретный уровень отражает последствия, а не просто наличие catch.

Диагностику одной операции ведёт её trace/владелец. Нижний слой сохраняет причину, верхний добавляет предметные последствия; один и тот же exception не печатается заново во всех catch. Если на другой границе нужна отдельная запись, в ней новый факт и тот же execution context. Существующая coalescing-схема навигации сохраняет различие: одно выполнение эффекта, отдельные результаты его callers. Шумные сообщения о каждом frame/getter не заменяют эти записи.

### Checklist для разработки и review

1. По scope/event/execution context различимы действие, этап и одновременно работающие операции; понятны origin/ресурс и существенные предусловия.
2. У критического запуска есть наблюдаемый итог. До начала внешнего действия не записан success; отказ предусловия не изображает запущенный запрос.
3. Каждая error-ветка объясняет установленную причину или явно отмечает её неизвестность, сохраняет доступные cause/stack и последствия для данных/продолжения.
4. Отмена, guard/validation rejection и технический отказ не смешаны. Поздняя запись/ошибка cleanup не выдаются за rollback или успешный retry.
5. Записи не раскрывают credentials/персональные payload; это касается также вложенного error, URL и stack. Пользовательское сообщение берётся из локализации отдельно от диагностики.
6. Изменённая логика проверяется с тестовым sink: события и значимые подробности соответствуют реальным исходам, нет ложного success/повторной итоговой записи, сбой вывода не ломает операцию. Тесты сравнивают факты/контракт, а не только полное буквальное оформление строки.

Задача113 изменила только правила и документацию. Сценарии таблицы проверены как критерии review; новый runtime logging coverage или AST-анализ сообщений этой задачей не заявляется. Результаты следующего списка относятся к реализации110, а не к аудиту всего приложения по R-010.

- test/infrastructure/logging/logging_test.dart:14 scenarios независимых destinations, общего sink, metadata/clock/levels, ошибок вывода/форматирования, настоящего print и рамки многострочных сообщений.
- test/app/logging/navigation_logging_test.dart:7 scenarios реального coordinator, включая отказ guard, typed executor failure, исходное исключение, coalescing, dispose и сбой sink.
- Вместе с navigation/operations regression —116 PASS; analyzer и architecture scan без нарушений. Compiler-negative probe отдельно подтвердил ARGUMENT_TYPE_NOT_ASSIGNABLE для NetworkLogEvent в NavigationLogger; временный файл удалён.
- Локальный ignore avoid_print разрешён только на согласованной строке PrintLogSink. В остальном runtime прямых print сейчас нет; проверяется целевым поиском/review. Новый AST-запрет direct print этой задачей не вводится.

UI/темы/goldens не менялись. Приложение не запускалось и не собиралось; hot reload недоступен без запущенного debug-процесса. Эти проверки не доказывают работу пока не реализованного HTTP/серверного logging transport.
