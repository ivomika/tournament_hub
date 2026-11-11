import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/navigation/navigation_coordinator.dart';
import 'package:tournament_app/app/navigation/navigation_effect.dart';
import 'package:tournament_app/app/navigation/navigation_effect_executor.dart';
import 'package:tournament_app/app/navigation/navigation_execution_result.dart';
import 'package:tournament_app/app/navigation/navigation_guard.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/domain/tournament/tournament_id.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';
import 'package:tournament_app/presentation/navigation/navigation_feedback.dart';

void main() => _CoordinatorTests.run();

abstract final class _CoordinatorTests {
  static void run() {
    test('allowed intent executes one typed effect', _allowed);
    test('denied intent never reaches executor', _denied);
    test('repeated in-flight intent cannot push twice', _duplicate);
    test('executor failure becomes typed feedback', _failure);
    test('disposed coordinator rejects new requests', _disposed);
    test('changed context invalidates the approved effect', _stale);
    test(
      'queued Back cannot impersonate the newly opened screen',
      _serialIntents,
    );
    test(
      'equal intent payloads from one entry coalesce by value',
      _equalPayloads,
    );
    test(
      'different payloads from one entry conflict instead of opening two screens',
      _differentPayloads,
    );
    test(
      'a callback bound to an old entry cannot navigate after commit',
      _staleOrigin,
    );
    test(
      'two Back requests close their origin entry only once',
      _duplicateBack,
    );
    test('an old Back callback cannot close a later route instance', _oldBack);
  }

  static Future<void> _allowed() async {
    final source = _ContextSource();
    final executor = _RecordingExecutor();
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);
    final feedback = await coordinator.submit(const OpenProfileIntent());
    expect(feedback, isA<NavigationAccepted>());
    expect(executor.effects, hasLength(1));
    expect(
      (executor.effects.single as PushRouteEffect).route,
      isA<ProfileRoute>(),
    );
  }

  static Future<void> _denied() async {
    final source = _ContextSource(profile: true);
    final executor = _RecordingExecutor();
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);
    expect(
      await coordinator.submit(const OpenProfileIntent()),
      isA<NavigationRejected>(),
    );
    expect(executor.effects, isEmpty);
  }

  static Future<void> _duplicate() async {
    final source = _ContextSource();
    final executor = _RecordingExecutor(pause: Completer<void>());
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);
    final first = coordinator.submit(const OpenProfileIntent());
    final second = coordinator.submit(const OpenProfileIntent());
    executor.pause!.complete();
    await Future.wait([first, second]);
    expect(executor.effects, hasLength(1));
  }

  static Future<void> _failure() async {
    final source = _ContextSource();
    final executor = _RecordingExecutor(
      outcome: const NavigationExecutionFailed(
        NavigationExecutionFailure.routerUnavailable,
      ),
    );
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);
    final feedback = await coordinator.submit(const OpenProfileIntent());
    expect(feedback, isA<NavigationFailed>());
    expect(
      (feedback as NavigationFailed).reason,
      NavigationFailureReason.routerUnavailable,
    );
  }

  static Future<void> _disposed() async {
    final source = _ContextSource();
    final executor = _RecordingExecutor();
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    coordinator.dispose();
    expect(
      await coordinator.submit(const OpenProfileIntent()),
      isA<NavigationCancelled>(),
    );
    expect(executor.effects, isEmpty);
  }

  static Future<void> _stale() async {
    final source = _ContextSource(changeOnRead: true);
    final executor = _RecordingExecutor();
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);
    expect(
      await coordinator.submit(const OpenProfileIntent()),
      isA<NavigationStale>(),
    );
    expect(executor.effects, isEmpty);
  }

  static Future<void> _serialIntents() async {
    final source = _ContextSource();
    final releaseFirst = Completer<void>();
    final executor = _RecordingExecutor(
      pause: releaseFirst,
      onCommitted: source.commit,
    );
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);

    final homeOrigin = coordinator.bindToCurrentEntry();
    final openProfile = homeOrigin.submit(const OpenProfileIntent());
    await executor.started.future;
    final goBack = homeOrigin.submit(const BackRequestedIntent());
    try {
      // Give an incorrectly concurrent implementation an event-loop turn to start.
      await Future<void>.delayed(Duration.zero);
      expect(executor.effects, hasLength(1));
      expect(executor.activeExecutions, 1);
      expect(executor.maximumActiveExecutions, 1);
    } finally {
      releaseFirst.complete();
    }

    expect(await openProfile, isA<NavigationAccepted>());
    expect(await goBack, isA<NavigationStale>());
    expect(executor.effects, hasLength(1));
    expect(executor.effects.first, isA<PushRouteEffect>());
    expect(executor.maximumActiveExecutions, 1);
    expect(executor.activeExecutions, 0);
    expect(source.profile, isTrue);
  }

  static Future<void> _equalPayloads() async {
    final source = _ContextSource();
    final release = Completer<void>();
    final executor = _RecordingExecutor(
      pause: release,
      onCommitted: source.commit,
    );
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);
    final origin = coordinator.bindToCurrentEntry();
    // Separate instances with equal values must share one transition.
    final first = origin.submit(
      OpenTournamentIntent(TournamentId('first-tournament')),
    );
    await executor.started.future;
    final second = origin.submit(
      OpenTournamentIntent(TournamentId('first-tournament')),
    );
    release.complete();
    expect(await first, isA<NavigationAccepted>());
    expect(await second, isA<NavigationAccepted>());
    expect(executor.effects, hasLength(1));
    expect(
      (executor.effects.single as PushRouteEffect).route,
      isA<TournamentRoute>(),
    );
  }

  static Future<void> _differentPayloads() async {
    final source = _ContextSource();
    final release = Completer<void>();
    final executor = _RecordingExecutor(
      pause: release,
      onCommitted: source.commit,
    );
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);
    final origin = coordinator.bindToCurrentEntry();
    final first = origin.submit(
      OpenTournamentIntent(TournamentId('first-tournament')),
    );
    await executor.started.future;
    final second = origin.submit(
      OpenTournamentIntent(TournamentId('second-tournament')),
    );
    release.complete();
    expect(await first, isA<NavigationAccepted>());
    final feedback = await second;
    expect(feedback, isA<NavigationConflict>());
    expect(
      (feedback as NavigationConflict).reason,
      NavigationConflictReason.competingTransition,
    );
    expect(executor.effects, hasLength(1));
    final route =
        (executor.effects.single as PushRouteEffect).route as TournamentRoute;
    expect(route.tournamentId, TournamentId('first-tournament'));
    expect(executor.maximumActiveExecutions, 1);
  }

  static Future<void> _staleOrigin() async {
    final source = _ContextSource();
    final executor = _RecordingExecutor(onCommitted: source.commit);
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);
    final homeOrigin = coordinator.bindToCurrentEntry();
    expect(
      await homeOrigin.submit(const OpenProfileIntent()),
      isA<NavigationAccepted>(),
    );
    expect(
      await homeOrigin.submit(const BackRequestedIntent()),
      isA<NavigationStale>(),
    );
    expect(executor.effects, hasLength(1));
  }

  static Future<void> _duplicateBack() async {
    final source = _ContextSource(profile: true);
    final originEntry = source.read().entryId;
    final release = Completer<void>();
    final executor = _RecordingExecutor(
      pause: release,
      onCommitted: source.commit,
    );
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);
    final profileOrigin = coordinator.bindToCurrentEntry();
    final first = profileOrigin.submit(const BackRequestedIntent());
    await executor.started.future;
    final second = profileOrigin.submit(const BackRequestedIntent());
    release.complete();
    final feedback = await Future.wait([first, second]);
    expect(feedback, everyElement(isA<NavigationAccepted>()));
    expect(executor.effects, hasLength(1));
    expect(executor.effects.single, isA<PopRouteEffect>());
    expect((executor.effects.single as PopRouteEffect).entryId, originEntry);
    expect(source.profile, isFalse);
  }

  static Future<void> _oldBack() async {
    final source = _ContextSource(profile: true);
    final executor = _RecordingExecutor(onCommitted: source.commit);
    final coordinator = NavigationCoordinator(
      guard: const NavigationGuard(),
      readContext: source.read,
      executor: executor,
    );
    addTearDown(coordinator.dispose);
    final firstProfile = coordinator.bindToCurrentEntry();
    await firstProfile.submit(const BackRequestedIntent());
    final home = coordinator.bindToCurrentEntry();
    await home.submit(const OpenProfileIntent());
    // Same route class, different entry. The old callback must not pop it.
    expect(
      await firstProfile.submit(const BackRequestedIntent()),
      isA<NavigationStale>(),
    );
    expect(executor.effects, hasLength(2));
    final secondProfile = coordinator.bindToCurrentEntry();
    expect(
      await secondProfile.submit(const BackRequestedIntent()),
      isA<NavigationAccepted>(),
    );
    expect(executor.effects, hasLength(3));
  }
}

class _ContextSource {
  _ContextSource({this.profile = false, this.changeOnRead = false});
  bool profile;
  final bool changeOnRead;
  int reads = 0;
  int revision = 1;
  int entryNumber = 1;
  AppRoute? routeOverride;
  void commit(NavigationEffect effect) {
    if (effect is PushRouteEffect) {
      profile = effect.route is ProfileRoute;
      routeOverride = effect.route;
    } else if (effect is PopRouteEffect) {
      profile = false;
      routeOverride = null;
    }
    revision++;
    entryNumber++;
  }

  NavigationContext read() {
    reads++;
    return NavigationContext(
      currentRoute:
          routeOverride ?? (profile ? const ProfileRoute() : const HomeRoute()),
      entryId: NavigationEntryId(entryNumber),
      revision: changeOnRead ? revision + reads - 1 : revision,
      initialized: true,
      canPop: profile,
    );
  }
}

class _RecordingExecutor implements NavigationEffectExecutor {
  _RecordingExecutor({
    this.pause,
    this.outcome = const NavigationExecutionSucceeded(),
    this.onCommitted,
  });
  final Completer<void>? pause;
  final NavigationExecutionResult outcome;
  final void Function(NavigationEffect)? onCommitted;
  final started = Completer<void>();
  int activeExecutions = 0;
  int maximumActiveExecutions = 0;
  final effects = <NavigationEffect>[];

  @override
  Future<NavigationExecutionResult> execute(NavigationEffect effect) async {
    effects.add(effect);
    activeExecutions++;
    if (activeExecutions > maximumActiveExecutions) {
      maximumActiveExecutions = activeExecutions;
    }
    if (!started.isCompleted) started.complete();
    try {
      if (pause != null) await pause!.future;
      if (outcome is NavigationExecutionSucceeded) onCommitted?.call(effect);
      return outcome;
    } finally {
      activeExecutions--;
    }
  }
}
