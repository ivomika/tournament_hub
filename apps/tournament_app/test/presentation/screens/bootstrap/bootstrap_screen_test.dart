import 'dart:io';

import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/profile_unavailable/profile_unavailable_use_case.dart';

import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/preparing_profile/preparing_profile_use_case.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/loading/loading_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/error/error_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/retrying/retrying_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/preparing_navigation/preparing_navigation_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/retrying_navigation/retrying_navigation_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/preparing_component/preparing_component_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/dependency_unavailable/dependency_unavailable_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/timed_out/timed_out_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/incompatible_version/incompatible_version_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/restart_required/restart_required_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/cancelled/cancelled_use_case.dart';

void main() => _BootstrapTests.run();

abstract final class _BootstrapTests {
  static void run() {
    testWidgets('profile unavailable mobile desktop', _profileError);
    testWidgets('preparing profile mobile desktop', _profile);
    testWidgets('preparing navigation mobile desktop', _navigation);
    testWidgets('retrying navigation mobile desktop', _retryingNavigation);
    testWidgets('preparing component mobile desktop', _component);
    testWidgets('dependency unavailable mobile desktop', _unavailable);
    testWidgets('timed out mobile desktop', _timeout);
    testWidgets('incompatible version mobile desktop', _incompatible);
    testWidgets('restart required mobile desktop', _restart);
    testWidgets('cancelled mobile desktop', _cancelled);
    testWidgets(
      'loading mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapLoadingUseCase.build),
        'bootstrap',
        'loading',
      ),
    );
    testWidgets(
      'error mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapErrorUseCase.build),
        'bootstrap',
        'error',
      ),
    );
    testWidgets(
      'retrying mobile desktop',
      (tester) async => ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapRetryingUseCase.build),
        'bootstrap',
        'retrying',
      ),
    );
  }

  static Future<void> _unavailable(WidgetTester tester) =>
      ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapDependencyUnavailableUseCase.build),
        'bootstrap',
        'dependency-unavailable',
      );

  static Future<void> _navigation(WidgetTester tester) =>
      ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapPreparingNavigationUseCase.build),
        'bootstrap',
        'preparing-navigation',
      );

  static Future<void> _profile(WidgetTester tester) =>
      ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapPreparingProfileUseCase.build),
        'bootstrap',
        'preparing-profile',
      );

  static Future<void> _profileError(WidgetTester tester) =>
      ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapProfileUnavailableUseCase.build),
        'bootstrap',
        'profile-unavailable',
      );

  static Future<void> _retryingNavigation(WidgetTester tester) =>
      ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapRetryingNavigationUseCase.build),
        'bootstrap',
        'retrying-navigation',
      );

  static Future<void> _component(WidgetTester tester) =>
      ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapPreparingComponentUseCase.build),
        'bootstrap',
        'preparing-component',
      );

  static Future<void> _timeout(WidgetTester tester) =>
      ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapTimedOutUseCase.build),
        'bootstrap',
        'timed-out',
      );

  static Future<void> _incompatible(WidgetTester tester) =>
      ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapIncompatibleVersionUseCase.build),
        'bootstrap',
        'incompatible-version',
      );

  static Future<void> _restart(WidgetTester tester) =>
      ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapRestartRequiredUseCase.build),
        'bootstrap',
        'restart-required',
      );

  static Future<void> _cancelled(WidgetTester tester) =>
      ScreenGoldenHarness.verify(
        tester,
        Builder(builder: BootstrapCancelledUseCase.build),
        'bootstrap',
        'cancelled',
      );
}

abstract final class ScreenGoldenHarness {
  static Future<void> verify(
    WidgetTester tester,
    Widget screen,
    String scope,
    String scenario,
  ) async {
    for (final viewport in [const Size(390, 844), const Size(1440, 900)]) {
      await tester.binding.setSurfaceSize(viewport);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.dark(),
          localizationsDelegates:
              FoundationLocalizations.localizationsDelegates,
          supportedLocales: FoundationLocalizations.supportedLocales,
          home: MediaQuery(
            data: MediaQueryData(size: viewport, disableAnimations: true),
            child: RepaintBoundary(
              key: const ValueKey('screen'),
              child: screen,
            ),
          ),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(
        tester.takeException(),
        isNull,
        reason: '$scope/$scenario $viewport',
      );
      await expectLater(
        find.byKey(const ValueKey('screen')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/screens/$scope/golden/${Platform.operatingSystem}/${viewport.width.toInt()}-$scenario.png',
          ),
        ),
      );
      await tester.pumpWidget(const SizedBox.shrink());
    }
    await tester.binding.setSurfaceSize(null);
  }
}
