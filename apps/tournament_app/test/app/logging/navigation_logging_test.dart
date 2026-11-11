import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/logging/app_loggers.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/navigation/navigation_coordinator.dart';
import 'package:tournament_app/app/navigation/navigation_effect.dart';
import 'package:tournament_app/app/navigation/navigation_effect_executor.dart';
import 'package:tournament_app/app/navigation/navigation_execution_result.dart';
import 'package:tournament_app/app/navigation/navigation_guard.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/domain/logging/log_event.dart';
import 'package:tournament_app/domain/logging/log_record.dart';
import 'package:tournament_app/domain/logging/navigation_log_event.dart';
import 'package:tournament_app/infrastructure/logging/log_sink.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';

void main() => _NavigationLoggingTests.run();

abstract final class _NavigationLoggingTests {
  static void run() {
    test('accepted request logs the real transition lifecycle', _accepted);
    test('denied request has no execution-start log', _denied);
    test('typed executor failure logs failed feedback', _failed);
    test('dispose logs cancellation and never late acceptance', _cancelled);
    test('logging failure cannot change successful navigation', _sinkFailure);
    test('coalesced requests execute and log started only once', _coalesced);
    test(
      'executor exception preserves original error and logs its stack',
      _exception,
    );
  }

  static Future<void> _accepted() async {
    final fixture = _Fixture();
    addTearDown(fixture.coordinator.dispose);
    expect(
      await fixture.coordinator.submit(const OpenProfileIntent()),
      isA<NavigationAccepted>(),
    );
    expect(fixture.events, [
      NavigationLogEvent.requested,
      NavigationLogEvent.started,
      NavigationLogEvent.accepted,
    ]);
    expect(
      fixture.sink.records.every(
        (record) => record.message?.contains('OpenProfileIntent') == true,
      ),
      isTrue,
    );
    expect(
      fixture.sink.records.any(
        (record) => record.message?.contains('1') == true,
      ),
      isTrue,
    );
  }

  static Future<void> _denied() async {
    final fixture = _Fixture(profile: true);
    addTearDown(fixture.coordinator.dispose);
    expect(
      await fixture.coordinator.submit(const OpenProfileIntent()),
      isA<NavigationRejected>(),
    );
    expect(fixture.events, [
      NavigationLogEvent.requested,
      NavigationLogEvent.rejected,
    ]);
    expect(fixture.executor.calls, 0);
  }

  static Future<void> _failed() async {
    final fixture = _Fixture(
      outcome: const NavigationExecutionFailed(
        NavigationExecutionFailure.routerUnavailable,
      ),
    );
    addTearDown(fixture.coordinator.dispose);
    expect(
      await fixture.coordinator.submit(const OpenProfileIntent()),
      isA<NavigationFailed>(),
    );
    expect(fixture.events, [
      NavigationLogEvent.requested,
      NavigationLogEvent.started,
      NavigationLogEvent.failed,
    ]);
  }

  static Future<void> _cancelled() async {
    final pause = Completer<void>();
    final fixture = _Fixture(pause: pause);
    final request = fixture.coordinator.submit(const OpenProfileIntent());
    await fixture.executor.started.future;
    fixture.coordinator.dispose();
    try {
      expect(await request, isA<NavigationCancelled>());
      expect(fixture.events, [
        NavigationLogEvent.requested,
        NavigationLogEvent.started,
        NavigationLogEvent.cancelled,
      ]);
    } finally {
      pause.complete();
    }
    await Future<void>.delayed(Duration.zero);
    expect(
      fixture.events.where((event) => event == NavigationLogEvent.accepted),
      isEmpty,
    );
    expect(
      fixture.events.where((event) => event == NavigationLogEvent.failed),
      isEmpty,
    );
  }

  static Future<void> _sinkFailure() async {
    final fixture = _Fixture(
      sinkFailure: StateError('logging output unavailable'),
    );
    addTearDown(fixture.coordinator.dispose);
    expect(
      await fixture.coordinator.submit(const OpenProfileIntent()),
      isA<NavigationAccepted>(),
    );
    expect(fixture.executor.calls, 1);
  }

  static Future<void> _coalesced() async {
    final pause = Completer<void>();
    final fixture = _Fixture(pause: pause);
    addTearDown(fixture.coordinator.dispose);
    final first = fixture.coordinator.submit(const OpenProfileIntent());
    await fixture.executor.started.future;
    final second = fixture.coordinator.submit(const OpenProfileIntent());
    pause.complete();
    expect(await first, isA<NavigationAccepted>());
    expect(await second, isA<NavigationAccepted>());
    expect(fixture.executor.calls, 1);
    expect(
      fixture.events.where((event) => event == NavigationLogEvent.started),
      hasLength(1),
    );
    expect(
      fixture.events.where((event) => event == NavigationLogEvent.accepted),
      hasLength(2),
    );
  }

  static Future<void> _exception() async {
    final error = StateError('executor exception');
    final fixture = _Fixture(executionError: error);
    addTearDown(fixture.coordinator.dispose);
    await expectLater(
      fixture.coordinator.submit(const OpenProfileIntent()),
      throwsA(same(error)),
    );
    final failure = fixture.sink.records
        .where((record) => record.event == NavigationLogEvent.failed)
        .single;
    expect(failure.error, same(error));
    expect(failure.stackTrace, isNotNull);
    expect(
      fixture.events.where((event) => event == NavigationLogEvent.accepted),
      isEmpty,
    );
  }
}

final class _Fixture {
  _Fixture({
    this.profile = false,
    Completer<void>? pause,
    NavigationExecutionResult outcome = const NavigationExecutionSucceeded(),
    Object? sinkFailure,
    Object? executionError,
  }) {
    sink = _Sink(sinkFailure);
    executor = _Executor(pause, outcome, executionError);
    final loggers = AppLoggers(navigationSink: sink, networkSink: _Sink(null));
    coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: readContext,
      executor: executor,
      logger: loggers.navigation,
    );
  }

  final bool profile;
  late final _Sink sink;
  late final _Executor executor;
  late final NavigationCoordinator coordinator;

  Iterable<LogEvent> get events => sink.records.map((record) => record.event);

  NavigationContext readContext() => NavigationContext(
    currentRoute: profile ? const ProfileRoute() : const HomeRoute(),
    entryId: const NavigationEntryId(1),
    revision: 1,
    initialized: true,
    canPop: profile,
  );
}

final class _Sink implements LogSink {
  _Sink(this.failure);

  final Object? failure;
  final List<LogRecord> records = [];

  @override
  void write(LogRecord record) {
    final error = failure;
    if (error != null) throw error;
    records.add(record);
  }
}

final class _Executor implements NavigationEffectExecutor {
  _Executor(this.pause, this.outcome, this.executionError);

  final Completer<void>? pause;
  final NavigationExecutionResult outcome;
  final Object? executionError;
  final started = Completer<void>();
  int calls = 0;

  @override
  Future<NavigationExecutionResult> execute(NavigationEffect effect) async {
    calls++;
    if (!started.isCompleted) started.complete();
    await pause?.future;
    final error = executionError;
    if (error != null) throw error;
    return outcome;
  }
}
