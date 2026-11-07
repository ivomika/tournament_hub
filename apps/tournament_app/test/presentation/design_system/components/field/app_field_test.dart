import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';
import 'package:tournament_app/presentation/widgetbook/components/field/field_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _FieldTests.run();

abstract final class _FieldTests {
  static String? changed;
  static void _changed(String value) => changed = value;
  static void run() {
    testWidgets(
      'editing delegates and rebuild preserves supplied controller',
      _editing,
    );
    testWidgets(
      'readonly and disabled block edits; error semantics',
      _availability,
    );
    testWidgets('current main TextTheme and ColorScheme reach input', _theme);
    testWidgets('narrow scaled and long multiline native goldens', _goldens);
  }

  static Future<void> _pump(
    WidgetTester tester,
    Widget child, {
    ThemeData? theme,
    double scale = 1,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: theme ?? AppTheme.dark(),
        localizationsDelegates: FoundationLocalizations.localizationsDelegates,
        supportedLocales: FoundationLocalizations.supportedLocales,
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: MediaQuery(
              data: MediaQueryData(
                size: const Size(390, 844),
                textScaler: TextScaler.linear(scale),
              ),
              child: RepaintBoundary(
                key: const ValueKey('field'),
                child: SizedBox(width: 240, child: child),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  }

  static Future<void> _editing(WidgetTester tester) async {
    final c = TextEditingController(text: 'Иван');
    addTearDown(c.dispose);
    changed = null;
    await _pump(
      tester,
      AppField(label: 'Имя', controller: c, onChanged: _changed),
    );
    await tester.enterText(find.byType(TextField), 'Александр');
    expect(c.text, 'Александр');
    expect(changed, 'Александр');
    await _pump(
      tester,
      AppField(label: 'Название', controller: c, onChanged: _changed),
    );
    expect(c.text, 'Александр');
  }

  static Future<void> _availability(WidgetTester tester) async {
    final c = TextEditingController(text: 'Иван');
    addTearDown(c.dispose);
    final semantics = tester.ensureSemantics();

    await _pump(
      tester,
      AppField(
        label: 'Имя',
        controller: c,
        readOnly: true,
        errorText: 'Проверь значение',
      ),
    );
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).readOnly,
      isTrue,
    );
    expect(find.bySemanticsLabel('Имя'), findsWidgets);
    expect(find.text('Проверь значение'), findsOneWidget);
    await _pump(tester, AppField(label: 'Имя', controller: c, enabled: false));
    await tester.tap(find.byType(TextField));
    await tester.pump();
    expect(
      tester.widget<EditableText>(find.byType(EditableText)).focusNode.hasFocus,
      isFalse,
    );
    expect(c.text, 'Иван');
    semantics.dispose();
  }

  static Future<void> _theme(WidgetTester tester) async {
    final c = TextEditingController(text: 'Иван');
    addTearDown(c.dispose);
    final base = AppTheme.dark();
    await _pump(
      tester,
      AppField(label: 'Имя', controller: c),
      theme: base.copyWith(
        colorScheme: base.colorScheme.copyWith(
          onSurface: Colors.cyan,
          surface: Colors.blue,
        ),
        textTheme: base.textTheme.copyWith(
          bodyMedium: base.textTheme.bodyMedium!.copyWith(fontSize: 22),
        ),
      ),
    );
    final e = tester.widget<EditableText>(find.byType(EditableText));
    expect(e.style.color, Colors.cyan);
    expect(e.style.fontSize, 22);
    expect(
      tester
          .widgetList<DecoratedBox>(find.byType(DecoratedBox))
          .any(
            (w) =>
                w.decoration is BoxDecoration &&
                (w.decoration as BoxDecoration).color == Colors.blue,
          ),
      isTrue,
    );
  }

  static Future<void> _goldens(WidgetTester tester) async {
    for (final kind in AppFieldKind.values) {
      await _pump(
        tester,
        FieldFixture(
          key: ValueKey(kind),
          kind: kind,
          sample: FieldSample.invalid,
        ),
        scale: 1.6,
      );
      await expectLater(
        find.byKey(const ValueKey('field')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/field/golden/${Platform.operatingSystem}/${kind.name.toLowerCase()}-scaled.png',
          ),
        ),
      );
    }
  }
}
