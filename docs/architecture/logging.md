# Типизированное логирование

## Решение и границы

Решение2026-11-11, задача110: код приложения передаёт типизированные события через собственный Logger, а способ вывода определяется конечным адаптером. Navigation и network имеют независимые destinations. Сейчас реализован только синхронный print в консоль; HTTP-логирование, очередь доставки на сервер и сторонние logging-пакеты ещё не подключены.

```text
NavigationLogger ─→ SinkLogger<NavigationLogEvent> ─→ navigationSink
NetworkLogger    ─→ SinkLogger<NetworkLogEvent>    ─→ networkSink

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

Контракты domain используют только Dart SDK; зависимостей от Flutter, инфраструктуры или logging-библиотек нет. LogSink не нужен потребителю Logger: это интерфейс технического output внутри infrastructure. Все существующие consumers нового механизма — app-навигация и её сборка; прямой вызов domain ports из presentation-state по-прежнему не разрешается этим документом. Widgets не получают логгер.

## Типизация

Scope берётся из события, а не передаётся строкой при каждом вызове. NavigationLogger принимает только NavigationLogEvent; NetworkLogger — только NetworkLogEvent. Компилятор отвергает вызов navigationLogger.log(NetworkLogEvent.requestStarted). Общий Logger не импортирует конкретные типы scoped-логгеров.

Роутинг и сравнения не используют .name/toString. Enum преобразуется в текст только на границе вывода; NavigationLogTrace формирует диагностические подробности из уже типизированных intent/effect/feedback. Свободная message — текст диагностики, не discriminator и не пользовательский UI. Это следует [R-004](../../ai-context/rules/core/004-typed-values.md); исключение для нелокализованных diagnostic messages уже предусмотрено R-005.

При добавлении scope: определить новый typed event и его LogScope, alias Logger<NewEvent> и app wiring выбранного sink. Общий SinkLogger и PrintLogSink копировать не нужно.

## Независимые адаптеры

Текущий запуск использует AppLoggers.console(): оба scope направлены в PrintLogSink. При другой сборке sinks задаются отдельно:

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

- test/infrastructure/logging/logging_test.dart:14 scenarios независимых destinations, общего sink, metadata/clock/levels, ошибок вывода/форматирования, настоящего print и рамки многострочных сообщений.
- test/app/logging/navigation_logging_test.dart:7 scenarios реального coordinator, включая отказ guard, typed executor failure, исходное исключение, coalescing, dispose и сбой sink.
- Вместе с navigation/operations regression —116 PASS; analyzer и architecture scan без нарушений. Compiler-negative probe отдельно подтвердил ARGUMENT_TYPE_NOT_ASSIGNABLE для NetworkLogEvent в NavigationLogger; временный файл удалён.
- Локальный ignore avoid_print разрешён только на согласованной строке PrintLogSink. В остальном runtime прямых print сейчас нет; проверяется целевым поиском/review. Новый AST-запрет direct print этой задачей не вводится.

UI/темы/goldens не менялись. Приложение не запускалось и не собиралось; hot reload недоступен без запущенного debug-процесса. Эти проверки не доказывают работу пока не реализованного HTTP/серверного logging transport.
