import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/navigation/navigation_decision.dart';
import 'package:tournament_app/app/navigation/navigation_effect.dart';
import 'package:tournament_app/app/navigation/navigation_guard.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';

void main() => _NavigationGuardTests.run();

abstract final class _NavigationGuardTests {
  static void run() {
    test('home intent produces typed push to profile', _openProfile);
    test('profile cannot reopen itself', _rejectDuplicateDestination);
    test('bootstrap cannot open profile before ready', _bootstrapBlocked);
    test('back from pushed profile produces pop', _backFromProfile);
    test('direct profile entry has typed home fallback', _directEntryBack);
    test('bootstrap completion replaces flow with home', _bootstrapReady);
    test(
      'guard evaluation is deterministic and does not mutate context',
      _pureDecision,
    );
  }

  static NavigationContext _context({
    required AppRoute current,
    bool initialized = true,
    bool canPop = false,
  }) => NavigationContext(
    currentRoute: current,
    entryId: const NavigationEntryId(1),
    revision: 1,
    initialized: initialized,
    canPop: canPop,
  );

  static void _openProfile() {
    final context = _context(current: const HomeRoute());
    final decision = const NavigationGuard().evaluate(
      const OpenProfileIntent(),
      context,
    );
    expect(decision, isA<NavigationAllowed>());
    final effect = (decision as NavigationAllowed).effect;
    expect(effect, isA<PushRouteEffect>());
    expect((effect as PushRouteEffect).route, isA<ProfileRoute>());
    expect(decision.entryId, context.entryId);
    expect(decision.revision, context.revision);
  }

  static void _rejectDuplicateDestination() {
    final decision = const NavigationGuard().evaluate(
      const OpenProfileIntent(),
      _context(current: const ProfileRoute()),
    );
    expect(decision, isA<NavigationDenied>());
    expect(
      (decision as NavigationDenied).reason,
      NavigationRejection.alreadyAtDestination,
    );
  }

  static void _bootstrapBlocked() {
    final decision = const NavigationGuard().evaluate(
      const OpenProfileIntent(),
      _context(current: const BootstrapRoute(), initialized: false),
    );
    expect(decision, isA<NavigationDenied>());
    expect(
      (decision as NavigationDenied).reason,
      NavigationRejection.notInitialized,
    );
  }

  static void _backFromProfile() {
    final decision = const NavigationGuard().evaluate(
      const BackRequestedIntent(),
      _context(current: const ProfileRoute(), canPop: true),
    );
    expect(decision, isA<NavigationAllowed>());
    expect((decision as NavigationAllowed).effect, isA<PopRouteEffect>());
  }

  static void _directEntryBack() {
    final decision = const NavigationGuard().evaluate(
      const BackRequestedIntent(),
      _context(current: const ProfileRoute()),
    );
    final effect = (decision as NavigationAllowed).effect;
    expect(effect, isA<GoToRouteEffect>());
    expect((effect as GoToRouteEffect).route, isA<HomeRoute>());
  }

  static void _bootstrapReady() {
    final decision = const NavigationGuard().evaluate(
      const BootstrapCompletedIntent(),
      _context(current: const BootstrapRoute()),
    );
    final effect = (decision as NavigationAllowed).effect;
    expect(effect, isA<GoToRouteEffect>());
    expect((effect as GoToRouteEffect).route, isA<HomeRoute>());
  }

  static void _pureDecision() {
    final context = _context(current: const HomeRoute());
    final first = const NavigationGuard().evaluate(
      const OpenProfileIntent(),
      context,
    );
    final second = const NavigationGuard().evaluate(
      const OpenProfileIntent(),
      context,
    );
    expect(first, isA<NavigationAllowed>());
    expect(second, isA<NavigationAllowed>());
    expect(context.currentRoute, isA<HomeRoute>());
    expect(context.revision, 1);
  }
}
