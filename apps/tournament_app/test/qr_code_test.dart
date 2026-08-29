import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/design_system/components/qr_code/qr_code_theme.dart';
import 'package:tournament_hub_app/presentation/design_system/components/qr_quiet_zone/qr_quiet_zone_theme.dart';

const _value = 'http://192.168.1.42:8080';
const _semanticLabel = 'QR-код тестового подключения.';

void main() {
  testWidgets('QrCode строит каждый size preset', (tester) async {
    final theme = TournamentTheme.dark.extension<QrCodeTheme>()!;
    final cases = {
      QrCodeSize.compact: theme.compactSize,
      QrCodeSize.standard: theme.standardSize,
      QrCodeSize.large: theme.largeSize,
    };

    for (final entry in cases.entries) {
      await tester.pumpWidget(_app(size: entry.key));
      await tester.pump();

      expect(find.byKey(const Key('qr-code-image')), findsOneWidget);
      expect(
        tester.getSize(find.byKey(const Key('qr-code-image'))),
        Size.square(entry.value),
      );
    }
  });

  testWidgets('QrCode гарантирует подложку и quiet zone минимум 4 модуля', (
    tester,
  ) async {
    await tester.pumpWidget(_app(size: QrCodeSize.compact));
    await tester.pump();

    final quietZoneTheme = TournamentTheme.dark.extension<QrQuietZoneTheme>()!;
    expect(quietZoneTheme.modules, greaterThanOrEqualTo(4));
    expect(find.byType(QrQuietZone), findsOneWidget);
    expect(find.byType(ClipRRect), findsOneWidget);

    final padding = tester.widget<Padding>(
      find.descendant(
        of: find.byType(QrQuietZone),
        matching: find.byType(Padding),
      ),
    );
    final inset = (padding.padding as EdgeInsets).left;
    expect(inset, greaterThan(0));
  });

  testWidgets('opaque value не раскрывается через semantics', (tester) async {
    final semantics = tester.ensureSemantics();
    const privateValue = 'http://192.168.1.42:8080/private-payload-marker';

    await tester.pumpWidget(_app(value: privateValue));
    await tester.pump();

    expect(find.bySemanticsLabel(_semanticLabel), findsOneWidget);
    expect(
      find.bySemanticsLabel(RegExp('private-payload-marker')),
      findsNothing,
    );
    semantics.dispose();
  });

  testWidgets('unavailable и слишком плотный payload показывают fallback', (
    tester,
  ) async {
    await tester.pumpWidget(_app(state: QrCodeState.unavailable));
    await tester.pump();
    expect(find.byKey(const Key('qr-code-fallback')), findsOneWidget);
    expect(find.byKey(const Key('qr-code-image')), findsNothing);

    await tester.pumpWidget(_app(value: List.filled(1000, 'x').join()));
    await tester.pump();
    expect(find.byKey(const Key('qr-code-fallback')), findsOneWidget);
    expect(find.byKey(const Key('qr-code-image')), findsNothing);
  });

  test('QR theme фиксирует scan-safe visual contract', () {
    final qrTheme = TournamentTheme.dark.extension<QrCodeTheme>()!;
    final quietZoneTheme = TournamentTheme.dark.extension<QrQuietZoneTheme>()!;
    final lighter = quietZoneTheme.background.computeLuminance();
    final darker = qrTheme.foreground.computeLuminance();
    final contrast = (lighter + 0.05) / (darker + 0.05);

    expect(contrast, greaterThanOrEqualTo(7));
    expect(qrTheme.moduleRoundFactor, greaterThan(0));
    expect(qrTheme.moduleRoundFactor, lessThan(1));
    expect(qrTheme.finderOuterRadiusFactor, greaterThan(1));
    expect(qrTheme.finderCenterRadiusFactor, greaterThan(0));
    expect(qrTheme.minimumModulePitch, greaterThanOrEqualTo(4));
    expect(quietZoneTheme.modules, greaterThanOrEqualTo(4));
    expect(quietZoneTheme.radius, greaterThan(0));
    expect(
      quietZoneTheme.radius,
      lessThanOrEqualTo(quietZoneTheme.modules * qrTheme.minimumModulePitch),
    );
  });

  test('QrQuietZoneTheme запрещает менее четырёх модулей', () {
    expect(
      () => QrQuietZoneTheme(
        background: TournamentTheme.dark.colorScheme.surface,
        modules: 3,
        radius: 0,
      ),
      throwsAssertionError,
    );
  });
}

Widget _app({
  String value = _value,
  QrCodeState state = QrCodeState.scannable,
  QrCodeSize size = QrCodeSize.standard,
}) => MaterialApp(
  theme: TournamentTheme.dark,
  home: Scaffold(
    body: Center(
      child: QrCode(
        value: value,
        semanticLabel: _semanticLabel,
        state: state,
        size: size,
      ),
    ),
  ),
);
