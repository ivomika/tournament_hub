import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/logging/app_loggers.dart';
import 'package:tournament_app/domain/logging/log_level.dart';
import 'package:tournament_app/domain/logging/log_record.dart';
import 'package:tournament_app/domain/logging/log_scope.dart';
import 'package:tournament_app/domain/logging/log_submission_result.dart';
import 'package:tournament_app/domain/logging/navigation_log_event.dart';
import 'package:tournament_app/domain/logging/navigation_logger.dart';
import 'package:tournament_app/domain/logging/network_log_event.dart';
import 'package:tournament_app/domain/logging/network_logger.dart';
import 'package:tournament_app/infrastructure/logging/log_sink.dart';
import 'package:tournament_app/infrastructure/logging/print_log_sink.dart';
import 'package:tournament_app/infrastructure/logging/sink_logger.dart';

void main() => _LoggingTests.run();

abstract final class _LoggingTests {
  static void run() {
    test('scope loggers route exclusively to their injected sinks', _routing);
    test(
      'replacing network destination preserves navigation destination',
      _replaceNetwork,
    );
    test(
      'record preserves typed metadata and original failure information',
      _metadata,
    );
    test('all levels use the same contract without duplicate output', _levels);
    test('one shared sink receives one record per log', _sharedSink);
    test(
      'sink failure is a typed rejection without retry or recursion',
      _sinkFailure,
    );
    test('one failed scope does not affect the other scope', _isolatedFailure);
    test('clock failure is rejected before writing to the sink', _clockFailure);
    test(
      'print adapter emits timestamp scope level event and message',
      _console,
    );
    test('print adapter includes error and stack trace', _consoleError);
    test('default app logging sends both scope types to print', _consoleWiring);
    test(
      'console record has a visible frame around its contents',
      _consoleFrame,
    );
    test('multiline diagnostic details remain inside the frame', _multiline);
    test(
      'formatting failure is rejected without partial console output',
      _formatFailure,
    );
  }

  static void _routing() {
    final navigation = _RecordingSink();
    final network = _RecordingSink();
    final loggers = AppLoggers(
      navigationSink: navigation,
      networkSink: network,
    );
    final NavigationLogger navigationLogger = loggers.navigation;
    final NetworkLogger networkLogger = loggers.network;
    expect(
      navigationLogger.log(NavigationLogEvent.requested),
      isA<LogAccepted>(),
    );
    expect(
      networkLogger.log(NetworkLogEvent.requestStarted),
      isA<LogAccepted>(),
    );
    expect(navigation.records.map((record) => record.event), [
      NavigationLogEvent.requested,
    ]);
    expect(network.records.map((record) => record.event), [
      NetworkLogEvent.requestStarted,
    ]);
    expect(navigation.records.single.scope, LogScope.navigation);
    expect(network.records.single.scope, LogScope.network);
  }

  static void _replaceNetwork() {
    final navigation = _RecordingSink();
    final firstNetwork = _RecordingSink();
    final secondNetwork = _RecordingSink();
    final first = AppLoggers(
      navigationSink: navigation,
      networkSink: firstNetwork,
    );
    final second = AppLoggers(
      navigationSink: navigation,
      networkSink: secondNetwork,
    );
    first.network.log(NetworkLogEvent.requestStarted);
    second.network.log(NetworkLogEvent.requestCompleted);
    first.navigation.log(NavigationLogEvent.requested);
    second.navigation.log(NavigationLogEvent.accepted);
    expect(firstNetwork.records.single.event, NetworkLogEvent.requestStarted);
    expect(
      secondNetwork.records.single.event,
      NetworkLogEvent.requestCompleted,
    );
    expect(navigation.records.map((record) => record.event), [
      NavigationLogEvent.requested,
      NavigationLogEvent.accepted,
    ]);
  }

  static void _metadata() {
    final sink = _RecordingSink();
    final logger = SinkLogger<NetworkLogEvent>(sink: sink, clock: _Clock.now);
    final error = StateError('connection unavailable');
    final stackTrace = StackTrace.current;
    final result = logger.log(
      NetworkLogEvent.requestFailed,
      level: LogLevel.error,
      message: 'request failed',
      error: error,
      stackTrace: stackTrace,
    );
    expect(result, isA<LogAccepted>());
    final record = sink.records.single;
    expect(record.timestamp, _Clock.timestamp);
    expect(record.event, NetworkLogEvent.requestFailed);
    expect(record.scope, LogScope.network);
    expect(record.level, LogLevel.error);
    expect(record.message, 'request failed');
    expect(record.error, same(error));
    expect(record.stackTrace, same(stackTrace));
  }

  static void _levels() {
    final sink = _RecordingSink();
    final logger = SinkLogger<NavigationLogEvent>(sink: sink);
    for (final level in LogLevel.values) {
      logger.log(NavigationLogEvent.requested, level: level);
    }
    expect(sink.records.map((record) => record.level), LogLevel.values);
    expect(sink.calls, LogLevel.values.length);
  }

  static void _sharedSink() {
    final sink = _RecordingSink();
    final loggers = AppLoggers(navigationSink: sink, networkSink: sink);
    loggers.navigation.log(NavigationLogEvent.requested);
    loggers.network.log(NetworkLogEvent.requestStarted);
    expect(sink.calls, 2);
    expect(sink.records.map((record) => record.scope), [
      LogScope.navigation,
      LogScope.network,
    ]);
  }

  static void _sinkFailure() {
    final error = StateError('sink failure');
    final sink = _RecordingSink(failure: error);
    final logger = SinkLogger<NavigationLogEvent>(sink: sink);
    final rejected = logger.log(NavigationLogEvent.requested) as LogRejected;
    expect(rejected.error, same(error));
    expect(rejected.stackTrace, isA<StackTrace>());
    expect(sink.calls, 1);
    expect(sink.records, isEmpty);
  }

  static void _isolatedFailure() {
    final navigation = _RecordingSink();
    final network = _RecordingSink(failure: StateError('network sink offline'));
    final loggers = AppLoggers(
      navigationSink: navigation,
      networkSink: network,
    );
    expect(
      loggers.network.log(NetworkLogEvent.requestFailed),
      isA<LogRejected>(),
    );
    expect(
      loggers.navigation.log(NavigationLogEvent.accepted),
      isA<LogAccepted>(),
    );
    expect(navigation.records.single.event, NavigationLogEvent.accepted);
    expect(network.calls, 1);
  }

  static void _clockFailure() {
    final sink = _RecordingSink();
    final logger = SinkLogger<NetworkLogEvent>(sink: sink, clock: _Clock.fail);
    expect(logger.log(NetworkLogEvent.requestStarted), isA<LogRejected>());
    expect(sink.calls, 0);
  }

  static void _console() {
    final capture = _ConsoleCapture();
    final logger = SinkLogger<NavigationLogEvent>(
      sink: const PrintLogSink(),
      clock: _Clock.now,
    );
    capture.run(
      () => logger.log(NavigationLogEvent.requested, message: 'open profile'),
    );
    expect(capture.lines, hasLength(1));
    final line = capture.lines.single;
    expect(line, contains(_Clock.timestamp.toIso8601String()));
    expect(line, contains('navigation'));
    expect(line, contains('info'));
    expect(line, contains('requested'));
    expect(line, contains('open profile'));
  }

  static void _consoleError() {
    final capture = _ConsoleCapture();
    final logger = SinkLogger<NetworkLogEvent>(
      sink: const PrintLogSink(),
      clock: _Clock.now,
    );
    final stackTrace = StackTrace.fromString('logging-test-stack');
    capture.run(
      () => logger.log(
        NetworkLogEvent.requestFailed,
        level: LogLevel.error,
        error: StateError('request-failed'),
        stackTrace: stackTrace,
      ),
    );
    final output = capture.lines.join('\n');
    expect(output, contains('request-failed'));
    expect(output, contains('logging-test-stack'));
    expect(output, contains('network'));
  }

  static void _consoleWiring() {
    final capture = _ConsoleCapture();
    final loggers = AppLoggers.console(clock: _Clock.now);
    capture.run(() {
      loggers.navigation.log(NavigationLogEvent.requested);
      loggers.network.log(NetworkLogEvent.requestStarted);
    });
    expect(capture.lines, hasLength(2));
    expect(capture.lines.first, contains('navigation'));
    expect(capture.lines.last, contains('network'));
  }

  static void _consoleFrame() {
    final capture = _ConsoleCapture();
    final logger = SinkLogger<NavigationLogEvent>(
      sink: const PrintLogSink(),
      clock: _Clock.now,
    );
    capture.run(
      () => logger.log(
        NavigationLogEvent.requested,
        message: 'OpenProfileIntent',
      ),
    );
    final lines = capture.lines.single.trimRight().split('\n');
    expect(lines.first, startsWith('┌'));
    expect(lines.last, startsWith('└'));
    expect(lines.length, greaterThan(3));
    expect(
      lines
          .skip(1)
          .take(lines.length - 2)
          .every((line) => line.startsWith('│') || line.startsWith('├')),
      isTrue,
    );
  }

  static void _multiline() {
    final capture = _ConsoleCapture();
    final logger = SinkLogger<NetworkLogEvent>(
      sink: const PrintLogSink(),
      clock: _Clock.now,
    );
    capture.run(
      () => logger.log(
        NetworkLogEvent.requestStarted,
        message: 'First detail\nSecond detail',
      ),
    );
    final lines = capture.lines.single.split('\n');
    expect(
      lines.where((line) => line.contains('First detail')).single,
      startsWith('│'),
    );
    expect(
      lines.where((line) => line.contains('Second detail')).single,
      startsWith('│'),
    );
  }

  static void _formatFailure() {
    final capture = _ConsoleCapture();
    final logger = SinkLogger<NetworkLogEvent>(sink: const PrintLogSink());
    LogSubmissionResult? result;
    capture.run(() {
      result = logger.log(
        NetworkLogEvent.requestFailed,
        error: _UnprintableError(),
      );
    });
    expect(result, isA<LogRejected>());
    expect(capture.lines, isEmpty);
  }
}

final class _UnprintableError implements Exception {
  @override
  String toString() => throw StateError('cannot format error');
}

final class _RecordingSink implements LogSink {
  _RecordingSink({this.failure});

  final Object? failure;
  final List<LogRecord> records = [];
  int calls = 0;

  @override
  void write(LogRecord record) {
    calls++;
    final error = failure;
    if (error != null) throw error;
    records.add(record);
  }
}

abstract final class _Clock {
  static final timestamp = DateTime.utc(2026, 11, 11, 12);

  static DateTime now() => timestamp;

  static DateTime fail() => throw StateError('clock unavailable');
}

final class _ConsoleCapture {
  final List<String> lines = [];

  void run(void Function() body) => runZoned<void>(
    body,
    zoneSpecification: ZoneSpecification(print: _capture),
  );

  void _capture(Zone self, ZoneDelegate parent, Zone zone, String line) =>
      lines.add(line);
}
