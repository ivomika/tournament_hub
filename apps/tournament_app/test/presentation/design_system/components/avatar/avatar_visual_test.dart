import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_avatar_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/avatar_fixture.dart';

import 'package:tournament_app/presentation/widgetbook/components/avatar/avatar_comparison.dart';

void main() => _AvatarVisualTests.run();

abstract final class _AvatarVisualTests {
  static const _captureKey = ValueKey('avatar-capture');
  static void run() {
    testWidgets('Avatar native goldens use declared scenarios', _goldens);
    testWidgets(
      'Avatar reads replacement main theme and extensions',
      _themeReplacement,
    );
    testWidgets(
      'Avatar empty and two-letter data preserve size and decorative semantics',
      _content,
    );
  }

  static Future<void> _pump(
    WidgetTester tester,
    AppAvatarSize size,
    AppAvatarShape shape, {
    ThemeData? theme,
    String initials = 'И',
    Color? foreground,
  }) async {
    final current = theme ?? AppTheme.dark();
    await tester.pumpWidget(
      MaterialApp(
        theme: current,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: RepaintBoundary(
              key: _captureKey,
              child: ColoredBox(
                color: current.scaffoldBackgroundColor,
                child: AvatarFixture(
                  size: size,
                  shape: shape,
                  initials: initials,
                  foreground: foreground,
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    addTearDown(tester.view.reset);
    for (final scenario in AvatarComparison.spec.scenarios) {
      if (scenario.expectedFailure != null) continue;
      tester.view.physicalSize = scenario.viewport.size;
      final theme = AppTheme.dark();
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: RepaintBoundary(
                key: _captureKey,
                child: ColoredBox(
                  color: theme.scaffoldBackgroundColor,
                  child: Builder(builder: scenario.builder),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      final golden = Uri.file(
        '${Directory.current.path}/lib/presentation/design_system/components/avatar/golden/${Platform.operatingSystem}/${scenario.goldenId}.png',
      );
      await expectLater(find.byKey(_captureKey), matchesGoldenFile(golden));
    }
  }

  static Future<void> _themeReplacement(WidgetTester tester) async {
    await _pump(tester, AppAvatarSize.large, AppAvatarShape.tile);
    final base = AppTheme.dark();
    final theme = base.copyWith(
      colorScheme: base.colorScheme.copyWith(
        onSurfaceVariant: Colors.cyan,
        surfaceContainerHigh: Colors.indigo,
      ),
      extensions: [
        ...base.extensions.values.where(
          (e) => e is! AppResponsive && e is! AppAvatarMetrics,
        ),
        base.extension<AppResponsive>()!.copyWith(avatarLarge: 80),
        base.extension<AppAvatarMetrics>()!.copyWith(
          avatarFont64: 30,
          avatarRadius64: 20,
        ),
      ],
    );
    await _pump(tester, AppAvatarSize.large, AppAvatarShape.tile, theme: theme);
    expect(tester.getSize(find.byType(AppAvatar)), const Size(80, 80));
    expect(tester.widget<Text>(find.text('И')).style!.fontSize, 30);
    expect(tester.widget<Text>(find.text('И')).style!.color, Colors.cyan);
    final box =
        tester
                .widget<DecoratedBox>(
                  find.descendant(
                    of: find.byType(AppAvatar),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as BoxDecoration;
    expect(box.color, Colors.indigo);
    expect(box.borderRadius, BorderRadius.circular(20));
  }

  static Future<void> _content(WidgetTester tester) async {
    for (final initials in ['', 'SZ']) {
      await _pump(
        tester,
        AppAvatarSize.large,
        AppAvatarShape.tile,
        initials: initials,
      );
      expect(tester.getSize(find.byType(AppAvatar)), const Size(64, 64));
      expect(find.text(initials), findsOneWidget);
      expect(tester.takeException(), isNull);
      final suffix = initials.isEmpty ? 'empty' : 'two_letters';
      await expectLater(
        find.byKey(_captureKey),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/avatar/golden/${Platform.operatingSystem}/64_tile_$suffix.png',
          ),
        ),
      );
    }
    final color = AppTheme.dark().colorScheme.secondary;
    await _pump(
      tester,
      AppAvatarSize.large,
      AppAvatarShape.tile,
      initials: 'SZ',
      foreground: color,
    );
    expect(tester.widget<Text>(find.text('SZ')).style!.color, color);
    await expectLater(
      find.byKey(_captureKey),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/components/avatar/golden/${Platform.operatingSystem}/64_tile_color_data.png',
        ),
      ),
    );
    expect(find.bySemanticsLabel('SZ'), findsNothing);
  }
}
