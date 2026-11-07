import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/identity_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _IdentityTests.run();

abstract final class _IdentityTests {
  static void run() {
    testWidgets('participant sizes and long narrow native goldens', _goldens);
    testWidgets('theme replacement and semantics', _theme);
  }

  static Future<void> _goldens(WidgetTester tester) async {
    for (final layout in AppIdentityLayout.values) {
      for (final long in [false, true]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.dark(),
            localizationsDelegates:
                FoundationLocalizations.localizationsDelegates,
            supportedLocales: FoundationLocalizations.supportedLocales,
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: RepaintBoundary(
                  key: const ValueKey('identity'),
                  child: SizedBox(
                    width: 200,
                    child: IdentityFixture(
                      layout: layout,
                      participant: true,
                      long: long,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull);
        expect(
          tester.getSize(find.byType(AppAvatar)),
          Size.square(layout == AppIdentityLayout.inline ? 48 : 64),
        );
        expect(find.text('Участник турнира'), findsNothing);
        await expectLater(
          find.byKey(const ValueKey('identity')),
          matchesGoldenFile(
            Uri.file(
              '${Directory.current.path}/lib/presentation/design_system/widgets/identity/golden/${Platform.operatingSystem}/participant_${layout.name}_${long ? 'long' : 'short'}.png',
            ),
          ),
        );
      }
    }
  }

  static Future<void> _theme(WidgetTester tester) async {
    final base = AppTheme.dark(), semantics = tester.ensureSemantics();
    final theme = base.copyWith(
      colorScheme: base.colorScheme.copyWith(onSurface: Colors.cyan),
      textTheme: base.textTheme.copyWith(
        bodyMedium: base.textTheme.bodyMedium!.copyWith(fontSize: 20),
      ),
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: theme,
        home: const Center(
          child: SizedBox(
            width: 240,
            child: AppIdentity(
              primary: 'Иван',
              initials: 'И',
              kind: AppIdentityKind.participant,
            ),
          ),
        ),
      ),
    );
    expect(tester.widget<Text>(find.text('Иван')).style!.fontSize, 20);
    expect(tester.widget<Text>(find.text('Иван')).style!.color, Colors.cyan);
    expect(find.bySemanticsLabel('Иван'), findsOneWidget);
    expect(find.bySemanticsLabel('И'), findsNothing);
    semantics.dispose();
  }
}
