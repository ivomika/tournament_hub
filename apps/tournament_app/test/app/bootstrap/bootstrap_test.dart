import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/bootstrap/application_bootstrap_plan.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_application.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_failure.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_gate.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_plan.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_presentation_mapper.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_resource.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_runner.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_session.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_state.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_step.dart';
import 'package:tournament_app/app/bootstrap/steps/initialize_logging_step.dart';
import 'package:tournament_app/app/bootstrap/steps/initialize_navigation_step.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/app/tournament_app.dart';
import 'package:tournament_app/domain/logging/bootstrap_log_event.dart';
import 'package:tournament_app/domain/logging/log_record.dart';
import 'package:tournament_app/infrastructure/logging/log_sink.dart';
import 'package:tournament_app/infrastructure/logging/sink_logger.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/operations/operation_request.dart';
import 'package:tournament_app/presentation/operations/operation_scope.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen_state.dart';

void main() {
  _RunnerTests.run();
  _GateTests.run();
}

abstract final class _RunnerTests {
  static void run() {
    test('typed phases stop before the application boundary', _phases);
    test('invalid phase order is rejected before any step starts', _order);
    test('post phase cannot run before preparation', _earlyPost);
    test(
      'required backend failure blocks downstream and readiness',
      _backendFailure,
    );
    test(
      'retry preserves the valid prefix and resumes the failed step',
      _retry,
    );
    test('concurrent retries share one attempt', _doubleRetry);
    test('non-retryable failure never launches another attempt', _nonRetryable);
    test('unexpected exception preserves cause and stack trace', _unexpected);
    test(
      'typed backend timeout remains a retryable blocking failure',
      _timeout,
    );
    test(
      'invalid post checkpoint is released and repeated with its suffix',
      _invalidPost,
    );
    test(
      'invalid pre checkpoint requires a new bootstrap attempt',
      _invalidPre,
    );
    test(
      'close cancels pending run and releases a late successful lease',
      _cancelLateValue,
    );
    test(
      'late source error cannot revive a closed bootstrap',
      _cancelLateError,
    );
    test(
      'abandoned successful resources close in reverse order',
      _reverseClose,
    );
    test(
      'resource cleanup failure does not skip other resources',
      _cleanupFailure,
    );
    test(
      'ready transfers resource ownership to the application session',
      _transfer,
    );
    test('repeated post command reuses the ready session', _idempotentReady);
    test('running state identifies the current typed step', _progress);
    test('bootstrap lifecycle uses typed logging events', _logging);
    test(
      'retry waits for failed attempt cleanup before starting again',
      _abortBeforeRetry,
    );
    test(
      'production plan owns and prepares real navigation dependencies',
      _applicationPlan,
    );
    test(
      'dispose delegates to managed shutdown without losing pending waits',
      _disposePending,
    );
    test(
      'closing from progress notification prevents step initialization',
      _closeAtProgress,
    );
    test('one typed plan cannot belong to two runners', _planOwnership);
    test(
      'cancelled run settles before its abort cleanup completes',
      _cancelAwaitCleanup,
    );
  }

  static Future<void> _phases() async {
    final fixture = _Fixture();
    final prepared = await fixture.runner.runBeforeApp();
    expect(prepared, isA<BootstrapAwaitingApplication<_SessionData>>());
    expect(fixture.configuration.calls, 1);
    expect(fixture.backend.calls, 0);
    expect(fixture.session.calls, 0);
    final ready =
        await fixture.runner.runAfterApp() as BootstrapReady<_SessionData>;
    expect(
      ready.session.value.backend.configuration,
      same(fixture.configuration.value),
    );
    await fixture.runner.close();
    await ready.session.close();
  }

  static void _order() {
    final plan = BootstrapPlan.seed(const _Seed())
        .then(_AfterSeedStep())
        .then(_BeforeSeedStep());
    expect(
      () => BootstrapRunner<_Seed>(plan: plan),
      throwsA(isA<BootstrapPlanException>()),
    );
  }

  static Future<void> _earlyPost() async {
    final fixture = _Fixture();
    await expectLater(
      fixture.runner.runAfterApp(),
      throwsA(isA<BootstrapPhaseException>()),
    );
    expect(fixture.configuration.calls, 0);
    expect(fixture.backend.calls, 0);
    await fixture.runner.close();
  }

  static Future<void> _backendFailure() async {
    final attempt = _Attempt.failure(_unavailable());
    final fixture = _Fixture(attempts: [attempt]);
    await fixture.runner.runBeforeApp();
    final failed =
        await fixture.runner.runAfterApp() as BootstrapFailed<_SessionData>;
    expect(failed.stepType, _BackendStep);
    expect(failed.failure.reason, BootstrapFailureReason.dependencyUnavailable);
    expect(failed.canRetry, isTrue);
    expect(fixture.session.calls, 0);
    expect(attempt.abortCalls, 1);
    expect(fixture.configuration.resource.releases, 0);
    await fixture.runner.close();
  }

  static Future<void> _retry() async {
    final fixture = _Fixture(
      attempts: [_Attempt.failure(_unavailable()), _Attempt.success()],
    );
    await fixture.runner.runBeforeApp();
    await fixture.runner.runAfterApp();
    final ready = await fixture.runner.retry() as BootstrapReady<_SessionData>;
    expect(fixture.configuration.calls, 1);
    expect(fixture.backend.calls, 2);
    expect(fixture.session.calls, 1);
    expect(
      ready.session.value.backend.configuration,
      same(fixture.configuration.value),
    );
    await fixture.runner.close();
    await ready.session.close();
  }

  static Future<void> _doubleRetry() async {
    final pending = _Attempt.pending();
    final fixture = _Fixture(
      attempts: [_Attempt.failure(_unavailable()), pending],
    );
    await fixture.runner.runBeforeApp();
    await fixture.runner.runAfterApp();
    final first = fixture.runner.retry();
    final second = fixture.runner.retry();
    expect(second, same(first));
    await pending.started.future;
    expect(fixture.backend.calls, 2);
    pending.release!.complete();
    final ready = await first as BootstrapReady<_SessionData>;
    expect(await second, same(ready));
    await fixture.runner.close();
    await ready.session.close();
  }

  static Future<void> _nonRetryable() async {
    final fixture = _Fixture(attempts: [_Attempt.failure(_incompatible())]);
    await fixture.runner.runBeforeApp();
    final failed =
        await fixture.runner.runAfterApp() as BootstrapFailed<_SessionData>;
    expect(failed.canRetry, isFalse);
    expect(await fixture.runner.retry(), same(failed));
    expect(fixture.backend.calls, 1);
    await fixture.runner.close();
  }

  static Future<void> _unexpected() async {
    final error = StateError('unexpected initialization failure');
    final fixture = _Fixture(attempts: [_Attempt.failure(error)]);
    await fixture.runner.runBeforeApp();
    final failed =
        await fixture.runner.runAfterApp() as BootstrapFailed<_SessionData>;
    expect(failed.failure.reason, BootstrapFailureReason.unexpected);
    expect(failed.failure.error, same(error));
    expect(failed.failure.stackTrace, isNotNull);
    expect(fixture.session.calls, 0);
    await fixture.runner.close();
  }

  static Future<void> _timeout() async {
    final fixture = _Fixture(
      attempts: [
        _Attempt.failure(
          const BootstrapStepException(
            BootstrapFailureReason.timedOut,
            retryAllowed: true,
          ),
        ),
      ],
    );
    await fixture.runner.runBeforeApp();
    final failed =
        await fixture.runner.runAfterApp() as BootstrapFailed<_SessionData>;
    expect(failed.failure.reason, BootstrapFailureReason.timedOut);
    expect(failed.stepType, _BackendStep);
    expect(failed.canRetry, isTrue);
    expect(fixture.session.calls, 0);
    await fixture.runner.close();
  }

  static Future<void> _invalidPost() async {
    final first = _Attempt.success();
    final second = _Attempt.success();
    final fixture = _Fixture(attempts: [first, second], sessionFailures: 1);
    await fixture.runner.runBeforeApp();
    expect(
      await fixture.runner.runAfterApp(),
      isA<BootstrapFailed<_SessionData>>(),
    );
    first.resource.valid = false;
    final ready = await fixture.runner.retry() as BootstrapReady<_SessionData>;
    expect(first.resource.releases, 1);
    expect(fixture.backend.calls, 2);
    expect(fixture.session.calls, 2);
    expect(fixture.configuration.calls, 1);
    expect(ready.session.value.backend, same(second.value));
    await fixture.runner.close();
    await ready.session.close();
  }

  static Future<void> _invalidPre() async {
    final fixture = _Fixture(attempts: [_Attempt.failure(_unavailable())]);
    await fixture.runner.runBeforeApp();
    await fixture.runner.runAfterApp();
    fixture.configuration.resource.valid = false;
    expect(
      await fixture.runner.retry(),
      isA<BootstrapRestartRequired<_SessionData>>(),
    );
    expect(fixture.configuration.calls, 1);
    expect(fixture.backend.calls, 1);
    expect(fixture.session.calls, 0);
    await fixture.runner.close();
  }

  static Future<void> _cancelLateValue() async {
    final attempt = _Attempt.pending();
    final fixture = _Fixture(attempts: [attempt]);
    await fixture.runner.runBeforeApp();
    final running = fixture.runner.runAfterApp();
    await attempt.started.future;
    final closing = fixture.runner.close();
    expect(await running, isA<BootstrapCancelled<_SessionData>>());
    await closing;
    expect(attempt.abortCalls, 1);
    attempt.release!.complete();
    await attempt.produced.future;
    await _drain();
    expect(attempt.resource.releases, 1);
    expect(fixture.configuration.resource.releases, 1);
    expect(fixture.session.calls, 0);
    expect(fixture.runner.state, isA<BootstrapCancelled<_SessionData>>());
  }

  static Future<void> _cancelLateError() async {
    final attempt = _Attempt.pending(
      failure: StateError('late backend failure'),
    );
    final fixture = _Fixture(attempts: [attempt]);
    await fixture.runner.runBeforeApp();
    final running = fixture.runner.runAfterApp();
    await attempt.started.future;
    await fixture.runner.close();
    attempt.release!.complete();
    await _drain();
    expect(await running, isA<BootstrapCancelled<_SessionData>>());
    expect(fixture.runner.state, isA<BootstrapCancelled<_SessionData>>());
    expect(fixture.session.calls, 0);
  }

  static Future<void> _reverseClose() async {
    final attempt = _Attempt.success();
    final fixture = _Fixture(attempts: [attempt], sessionFailures: 1);
    await fixture.runner.runBeforeApp();
    await fixture.runner.runAfterApp();
    final closing = fixture.runner.close();
    expect(fixture.runner.close(), same(closing));
    await closing;
    expect(fixture.cleanupOrder, [_BackendStep, _ConfigurationStep]);
    expect(attempt.resource.releases, 1);
    expect(fixture.configuration.resource.releases, 1);
  }

  static Future<void> _cleanupFailure() async {
    final attempt = _Attempt.success();
    final error = StateError('backend resource cleanup failed');
    attempt.resource.failure = error;
    final fixture = _Fixture(attempts: [attempt], sessionFailures: 1);
    await fixture.runner.runBeforeApp();
    await fixture.runner.runAfterApp();
    await expectLater(
      fixture.runner.close(),
      throwsA(
        isA<OperationCleanupException>().having(
          (failure) => failure.errors,
          'errors',
          contains(same(error)),
        ),
      ),
    );
    expect(fixture.configuration.resource.releases, 1);
    expect(fixture.cleanupOrder, [_BackendStep, _ConfigurationStep]);
  }

  static Future<void> _transfer() async {
    final fixture = _Fixture();
    await fixture.runner.runBeforeApp();
    final ready =
        await fixture.runner.runAfterApp() as BootstrapReady<_SessionData>;
    await fixture.runner.close();
    expect(fixture.cleanupOrder, isEmpty);
    final closing = ready.session.close();
    expect(ready.session.close(), same(closing));
    await closing;
    expect(fixture.cleanupOrder, [
      _SessionStep,
      _BackendStep,
      _ConfigurationStep,
    ]);
  }

  static Future<void> _idempotentReady() async {
    final fixture = _Fixture();
    await fixture.runner.runBeforeApp();
    final ready =
        await fixture.runner.runAfterApp() as BootstrapReady<_SessionData>;
    expect(await fixture.runner.runAfterApp(), same(ready));
    expect(fixture.configuration.calls, 1);
    expect(fixture.backend.calls, 1);
    expect(fixture.session.calls, 1);
    await fixture.runner.close();
    await ready.session.close();
  }

  static Future<void> _progress() async {
    final pending = _Attempt.pending();
    final fixture = _Fixture(attempts: [pending]);
    await fixture.runner.runBeforeApp();
    final running = fixture.runner.runAfterApp();
    await pending.started.future;
    final progress = fixture.runner.state as BootstrapRunning<_SessionData>;
    expect(progress.stepType, _BackendStep);
    expect(progress.placement, BootstrapPlacement.afterApplication);
    pending.release!.complete();
    final ready = await running as BootstrapReady<_SessionData>;
    await fixture.runner.close();
    await ready.session.close();
  }

  static Future<void> _logging() async {
    final sink = _BootstrapSink();
    final fixture = _Fixture(
      attempts: [_Attempt.failure(_unavailable()), _Attempt.success()],
      sink: sink,
    );
    await fixture.runner.runBeforeApp();
    await fixture.runner.runAfterApp();
    final ready = await fixture.runner.retry() as BootstrapReady<_SessionData>;
    final events = sink.records.map((record) => record.event);
    expect(events, contains(BootstrapLogEvent.stepStarted));
    expect(events, contains(BootstrapLogEvent.stepFailed));
    expect(events, contains(BootstrapLogEvent.retrying));
    expect(
      events.where((event) => event == BootstrapLogEvent.ready),
      hasLength(1),
    );
    await fixture.runner.close();
    await ready.session.close();
  }

  static Future<void> _abortBeforeRetry() async {
    final attempt = _Attempt.failure(
      _unavailable(),
      abortGate: Completer<void>(),
    );
    final fixture = _Fixture(attempts: [attempt, _Attempt.success()]);
    await fixture.runner.runBeforeApp();
    final running = fixture.runner.runAfterApp();
    await attempt.abortStarted.future;
    final duplicate = fixture.runner.retry();
    expect(duplicate, same(running));
    expect(fixture.backend.calls, 1);
    attempt.abortGate!.complete();
    expect(await running, isA<BootstrapFailed<_SessionData>>());
    final ready = await fixture.runner.retry() as BootstrapReady<_SessionData>;
    expect(fixture.backend.calls, 2);
    expect(attempt.abortCalls, 1);
    await fixture.runner.close();
    await ready.session.close();
  }

  static Future<void> _applicationPlan() async {
    final runner = BootstrapRunner<AppNavigationSession>(
      plan: ApplicationBootstrapPlan.create(),
    );
    expect(
      await runner.runBeforeApp(),
      isA<BootstrapAwaitingApplication<AppNavigationSession>>(),
    );
    final ready =
        await runner.runAfterApp() as BootstrapReady<AppNavigationSession>;
    await runner.close();
    final navigation = ready.session.value;
    expect(navigation.currentRoute, isA<HomeRoute>());
    expect(navigation.readContext().initialized, isTrue);
    await ready.session.close();
    expect(
      await navigation.coordinator.submit(const OpenProfileIntent()),
      isA<NavigationCancelled>(),
    );
  }

  static Future<void> _disposePending() async {
    final attempt = _Attempt.pending();
    final fixture = _Fixture(attempts: [attempt]);
    await fixture.runner.runBeforeApp();
    final running = fixture.runner.runAfterApp();
    await attempt.started.future;
    fixture.runner.dispose();
    expect(await running, isA<BootstrapCancelled<_SessionData>>());
    await fixture.runner.close();
    expect(attempt.abortCalls, 1);
    attempt.release!.complete();
    await attempt.produced.future;
    await _drain();
    expect(attempt.resource.releases, 1);
  }

  static Future<void> _closeAtProgress() async {
    final fixture = _Fixture();
    final observer = _CloseAtProgress(fixture.runner);
    await fixture.runner.runBeforeApp();
    fixture.runner.addListener(observer.changed);
    expect(
      await fixture.runner.runAfterApp(),
      isA<BootstrapCancelled<_SessionData>>(),
    );
    fixture.runner.removeListener(observer.changed);
    await observer.closing;
    expect(fixture.backend.calls, 0);
    expect(fixture.session.calls, 0);
    expect(fixture.configuration.resource.releases, 1);
  }

  static Future<void> _planOwnership() async {
    final plan = BootstrapPlan.seed(const _Seed()).then(_BeforeSeedStep());
    final first = BootstrapRunner<_Seed>(plan: plan);
    expect(
      () => BootstrapRunner<_Seed>(plan: plan),
      throwsA(isA<BootstrapPlanException>()),
    );
    await first.close();
  }

  static Future<void> _cancelAwaitCleanup() async {
    final abortGate = Completer<void>();
    final attempt = _Attempt.pending(abortGate: abortGate);
    final fixture = _Fixture(attempts: [attempt]);
    await fixture.runner.runBeforeApp();
    final running = fixture.runner.runAfterApp();
    await attempt.started.future;
    final closing = fixture.runner.close();
    expect(await running, isA<BootstrapCancelled<_SessionData>>());
    final probe = _CleanupProbe();
    final observed = closing.then(probe.finished);
    await _drain();
    expect(probe.calls, 0);
    abortGate.complete();
    await observed;
    expect(probe.calls, 1);
    attempt.release!.complete();
    await attempt.produced.future;
    await _drain();
    expect(attempt.resource.releases, 1);
  }

  static BootstrapStepException _unavailable() => const BootstrapStepException(
    BootstrapFailureReason.dependencyUnavailable,
    retryAllowed: true,
  );

  static BootstrapStepException _incompatible() => const BootstrapStepException(
    BootstrapFailureReason.incompatibleVersion,
    retryAllowed: false,
  );

  static Future<void> _drain() => Future<void>.delayed(Duration.zero);
}

abstract final class _GateTests {
  static void run() {
    testWidgets(
      'current step label is localized and only shown after application startup',
      _currentStep,
    );
    testWidgets(
      'required backend error is visible and retry opens the application',
      _retry,
    );
    testWidgets('retry action cannot start a second running attempt', _busy);
    testWidgets(
      'non-retryable error does not expose an active retry',
      _permanent,
    );
    testWidgets(
      'pre-app failure can render fallback without launching post steps',
      _preFailure,
    );
    testWidgets(
      'production bootstrap host opens the app and owns its session',
      _applicationHost,
    );
  }

  static Future<void> _retry(WidgetTester tester) async {
    final first = _Attempt.pending(failure: _RunnerTests._unavailable());
    final fixture = _Fixture(attempts: [first, _Attempt.success()]);
    await fixture.runner.runBeforeApp();
    await tester.pumpWidget(_GateHost(runner: fixture.runner));
    expect(find.byType(BootstrapScreen), findsOneWidget);
    expect(find.byKey(_GateHost.readyKey), findsNothing);
    final progressLocalizations = FoundationLocalizations.of(
      tester.element(find.byType(BootstrapScreen)),
    );
    expect(
      find.text(progressLocalizations.screenBootPreparingComponent),
      findsOneWidget,
    );
    first.release!.complete();
    await tester.pump();
    await tester.pump();
    final localizations = FoundationLocalizations.of(
      tester.element(find.byType(BootstrapScreen)),
    );
    expect(
      find.text(localizations.screenBootDependencyUnavailable),
      findsOneWidget,
    );
    expect(find.text(localizations.screenBootPreparingComponent), findsNothing);
    expect(find.byKey(_GateHost.readyKey), findsNothing);
    await tester.tap(find.text(localizations.screenRetry));
    await tester.pump();
    await tester.pump();
    expect(find.byKey(_GateHost.readyKey), findsOneWidget);
    expect(find.byType(BootstrapScreen), findsNothing);
    expect(fixture.configuration.calls, 1);
    expect(fixture.backend.calls, 2);
    await tester.pumpWidget(const SizedBox.shrink());
    await fixture.runner.close();
    await tester.pump();
    expect(fixture.configuration.resource.releases, 1);
  }

  static Future<void> _busy(WidgetTester tester) async {
    final pending = _Attempt.pending();
    final fixture = _Fixture(
      attempts: [_Attempt.failure(_RunnerTests._unavailable()), pending],
    );
    await fixture.runner.runBeforeApp();
    await tester.pumpWidget(_GateHost(runner: fixture.runner));
    await tester.pump();
    final button = find.byType(AppButton);
    await tester.tap(button);
    await tester.pump();
    expect(fixture.backend.calls, 2);
    for (final buttonWidget in tester.widgetList<AppButton>(
      find.byType(AppButton),
    )) {
      expect(buttonWidget.onPressed, isNull);
    }
    expect(find.byKey(_GateHost.readyKey), findsNothing);
    pending.release!.complete();
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    await fixture.runner.close();
    await tester.pump();
  }

  static Future<void> _permanent(WidgetTester tester) async {
    final fixture = _Fixture(
      attempts: [_Attempt.failure(_RunnerTests._incompatible())],
    );
    await fixture.runner.runBeforeApp();
    await tester.pumpWidget(_GateHost(runner: fixture.runner));
    await tester.pump();
    expect(find.byType(BootstrapScreen), findsOneWidget);
    expect(find.byKey(_GateHost.readyKey), findsNothing);
    final localizations = FoundationLocalizations.of(
      tester.element(find.byType(BootstrapScreen)),
    );
    expect(
      find.text(localizations.screenBootIncompatibleVersion),
      findsOneWidget,
    );
    for (final button in tester.widgetList<AppButton>(find.byType(AppButton))) {
      expect(button.onPressed, isNull);
    }
    expect(fixture.backend.calls, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    await fixture.runner.close();
  }

  static Future<void> _preFailure(WidgetTester tester) async {
    final fixture = _Fixture(
      configurationFailure: StateError('cannot prepare application'),
    );
    expect(
      await fixture.runner.runBeforeApp(),
      isA<BootstrapFailed<_SessionData>>(),
    );
    await tester.pumpWidget(_GateHost(runner: fixture.runner));
    await tester.pump();
    expect(find.byType(BootstrapScreen), findsOneWidget);
    expect(find.byKey(_GateHost.readyKey), findsNothing);
    expect(fixture.backend.calls, 0);
    expect(fixture.session.calls, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    await fixture.runner.close();
  }

  static Future<void> _applicationHost(WidgetTester tester) async {
    final runner = BootstrapRunner<AppNavigationSession>(
      plan: ApplicationBootstrapPlan.create(),
    );
    await runner.runBeforeApp();
    await tester.pumpWidget(
      BootstrapApplication(runner: runner, theme: AppTheme.dark()),
    );
    await tester.pump();
    await tester.pump();
    expect(find.byType(TournamentApp), findsOneWidget);
    expect(find.byType(BootstrapScreen), findsNothing);
    final ready = runner.state as BootstrapReady<AppNavigationSession>;
    await tester.pumpWidget(const SizedBox.shrink());
    await runner.close();
    await tester.pump();
    expect(
      await ready.session.value.coordinator.submit(const OpenProfileIntent()),
      isA<NavigationCancelled>(),
    );
  }

  static Future<void> _currentStep(WidgetTester tester) async {
    final navigation = BootstrapPresentationMapper.map(
      const BootstrapRunning<void>(
        InitializeNavigationStep,
        BootstrapPlacement.afterApplication,
        BootstrapRunKind.initial,
      ),
    );
    await tester.pumpWidget(_StepPreview(state: navigation));
    final localizations = FoundationLocalizations.of(
      tester.element(find.byType(BootstrapScreen)),
    );
    expect(
      find.text(localizations.screenBootPreparingNavigation),
      findsOneWidget,
    );
    final Type implementationType = InitializeNavigationStep;
    expect(find.text(implementationType.toString()), findsNothing);
    final beforeApplication = BootstrapPresentationMapper.map(
      const BootstrapRunning<void>(
        InitializeLoggingStep,
        BootstrapPlacement.beforeApplication,
        BootstrapRunKind.initial,
      ),
    );
    await tester.pumpWidget(_StepPreview(state: beforeApplication));
    expect(
      find.text(localizations.screenBootPreparingNavigation),
      findsNothing,
    );
    expect(find.text(localizations.screenBootPreparingComponent), findsNothing);
    expect(find.text(localizations.screenBootPreparing), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  }
}

class _StepPreview extends StatelessWidget {
  const _StepPreview({required this.state});

  final BootstrapScreenState state;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: FoundationLocalizations.localizationsDelegates,
    supportedLocales: FoundationLocalizations.supportedLocales,
    home: BootstrapScreen(state: state, onRetry: null),
  );
}

final class _Fixture {
  _Fixture({
    List<_Attempt>? attempts,
    int sessionFailures = 0,
    Object? configurationFailure,
    _BootstrapSink? sink,
  }) {
    configuration = _ConfigurationStep(
      cleanupOrder,
      failure: configurationFailure,
    );
    backend = _BackendStep(attempts ?? [_Attempt.success()], cleanupOrder);
    session = _SessionStep(cleanupOrder, sessionFailures);
    final plan = BootstrapPlan.seed(const _Seed())
        .then(configuration)
        .then(backend)
        .then(session);
    runner = BootstrapRunner<_SessionData>(
      plan: plan,
      logger: sink == null ? null : SinkLogger<BootstrapLogEvent>(sink: sink),
    );
  }

  final List<Type> cleanupOrder = [];
  late final _ConfigurationStep configuration;
  late final _BackendStep backend;
  late final _SessionStep session;
  late final BootstrapRunner<_SessionData> runner;
}

final class _Seed {
  const _Seed();
}

final class _Configuration {
  const _Configuration(this.seed);

  final _Seed seed;
}

final class _Backend {
  const _Backend(this.configuration);

  final _Configuration configuration;
}

final class _SessionData {
  const _SessionData(this.backend);

  final _Backend backend;
}

final class _ResourceState {
  _ResourceState(this.owner);

  final Type owner;
  List<Type>? cleanupOrder;
  bool valid = true;
  int releases = 0;
  Object? failure;

  bool isValid() => valid;

  Future<void> close() async {
    releases++;
    cleanupOrder?.add(owner);
    final error = failure;
    if (error != null) throw error;
  }
}

final class _ConfigurationStep implements BootstrapStep<_Seed, _Configuration> {
  _ConfigurationStep(List<Type> cleanupOrder, {this.failure}) {
    resource.cleanupOrder = cleanupOrder;
  }

  final Object? failure;
  final resource = _ResourceState(_ConfigurationStep);
  late final _Configuration value;
  int calls = 0;

  @override
  BootstrapPlacement get placement => BootstrapPlacement.beforeApplication;

  @override
  OperationRequest<BootstrapResource<_Configuration>> start(_Seed input) {
    calls++;
    final error = failure;
    if (error != null) {
      return OperationRequest(result: Future.error(error), onCancel: _abort);
    }
    value = _Configuration(input);
    final lease = BootstrapResource(
      value: value,
      onClose: resource.close,
      isValid: resource.isValid,
    );
    return OperationRequest(result: Future.value(lease), onCancel: lease.close);
  }

  Future<void> _abort() => Future<void>.value();
}

final class _BackendStep implements BootstrapStep<_Configuration, _Backend> {
  _BackendStep(this.attempts, List<Type> cleanupOrder) {
    for (final attempt in attempts) {
      attempt.resource.cleanupOrder = cleanupOrder;
    }
  }

  final List<_Attempt> attempts;
  int calls = 0;

  @override
  BootstrapPlacement get placement => BootstrapPlacement.afterApplication;

  @override
  OperationRequest<BootstrapResource<_Backend>> start(_Configuration input) {
    final attempt = attempts[calls++];
    return OperationRequest(
      result: attempt.initialize(input),
      onCancel: attempt.abort,
    );
  }
}

final class _Attempt {
  _Attempt.success() : failure = null, release = null, abortGate = null;

  _Attempt.failure(this.failure, {this.abortGate}) : release = null;

  _Attempt.pending({this.failure, this.abortGate})
    : release = Completer<void>();

  final Object? failure;
  final Completer<void>? release;
  final Completer<void>? abortGate;
  final started = Completer<void>();
  final abortStarted = Completer<void>();
  final produced = Completer<BootstrapResource<_Backend>>();
  final resource = _ResourceState(_BackendStep);
  late final _Backend value;
  int abortCalls = 0;

  Future<BootstrapResource<_Backend>> initialize(
    _Configuration configuration,
  ) async {
    started.complete();
    await release?.future;
    final error = failure;
    if (error != null) throw error;
    value = _Backend(configuration);
    final lease = BootstrapResource(
      value: value,
      onClose: resource.close,
      isValid: resource.isValid,
    );
    produced.complete(lease);
    return lease;
  }

  Future<void> abort() {
    abortCalls++;
    if (!abortStarted.isCompleted) abortStarted.complete();
    return abortGate?.future ?? Future<void>.value();
  }
}

final class _SessionStep implements BootstrapStep<_Backend, _SessionData> {
  _SessionStep(List<Type> cleanupOrder, this.failuresRemaining) {
    resource.cleanupOrder = cleanupOrder;
  }

  final resource = _ResourceState(_SessionStep);
  int failuresRemaining;
  int calls = 0;

  @override
  BootstrapPlacement get placement => BootstrapPlacement.afterApplication;

  @override
  OperationRequest<BootstrapResource<_SessionData>> start(_Backend input) {
    calls++;
    if (failuresRemaining > 0) {
      failuresRemaining--;
      return OperationRequest(
        result: Future.error(_RunnerTests._unavailable()),
        onCancel: _abort,
      );
    }
    final lease = BootstrapResource(
      value: _SessionData(input),
      onClose: resource.close,
      isValid: resource.isValid,
    );
    return OperationRequest(result: Future.value(lease), onCancel: lease.close);
  }

  Future<void> _abort() => Future<void>.value();
}

final class _AfterSeedStep implements BootstrapStep<_Seed, _Seed> {
  @override
  BootstrapPlacement get placement => BootstrapPlacement.afterApplication;

  @override
  OperationRequest<BootstrapResource<_Seed>> start(_Seed input) =>
      OperationRequest(
        result: Future.value(BootstrapResource(value: input)),
        onCancel: _abort,
      );

  Future<void> _abort() => Future<void>.value();
}

final class _BeforeSeedStep implements BootstrapStep<_Seed, _Seed> {
  @override
  BootstrapPlacement get placement => BootstrapPlacement.beforeApplication;

  @override
  OperationRequest<BootstrapResource<_Seed>> start(_Seed input) =>
      OperationRequest(
        result: Future.value(BootstrapResource(value: input)),
        onCancel: _abort,
      );

  Future<void> _abort() => Future<void>.value();
}

final class _BootstrapSink implements LogSink {
  final List<LogRecord> records = [];

  @override
  void write(LogRecord record) => records.add(record);
}

final class _CloseAtProgress {
  _CloseAtProgress(this.runner);

  final BootstrapRunner<_SessionData> runner;
  late final Future<void> closing;

  void changed() {
    final current = runner.state;
    if (current is BootstrapRunning<_SessionData> &&
        current.stepType == _BackendStep) {
      closing = runner.close();
    }
  }
}

final class _CleanupProbe {
  int calls = 0;

  void finished(void result) => calls++;
}

class _GateHost extends StatelessWidget {
  const _GateHost({required this.runner});

  static const readyKey = ValueKey<Type>(_SessionData);

  final BootstrapRunner<_SessionData> runner;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: AppTheme.dark(),
    localizationsDelegates: FoundationLocalizations.localizationsDelegates,
    supportedLocales: FoundationLocalizations.supportedLocales,
    home: BootstrapGate<_SessionData>(runner: runner, readyBuilder: _ready),
  );

  Widget _ready(BuildContext context, BootstrapSession<_SessionData> session) =>
      const SizedBox(key: readyKey);
}
