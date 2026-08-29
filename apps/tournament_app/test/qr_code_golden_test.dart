import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';

void main() {
  const cases = <({String name, String value, QrCodeSize size, double dpr})>[
    (
      name: 'ipv4_compact_dpr1',
      value: 'http://192.168.1.42:8080',
      size: QrCodeSize.compact,
      dpr: 1,
    ),
    (
      name: 'ipv6_standard_dpr2',
      value: 'http://[fe80::20c:29ff:fe9c:409b]:18080/spectator',
      size: QrCodeSize.standard,
      dpr: 2,
    ),
    (
      name: 'participant_large_dpr3',
      value: 'http://192.168.1.42:8080/join?role=participant&tournament=demo&code=ABCD-EFGH',
      size: QrCodeSize.large,
      dpr: 3,
    ),
  ];

  for (final testCase in cases) {
    testWidgets('QrCode ${testCase.name} сохраняет visual contract', (
      tester,
    ) async {
      tester.view.devicePixelRatio = testCase.dpr;
      tester.view.physicalSize = Size.square(560 * testCase.dpr);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _goldenApp(value: testCase.value, size: testCase.size),
      );
      await tester.pump();

      expect(find.byKey(const Key('qr-code-image')), findsOneWidget);
      await expectLater(
        find.byType(QrCode),
        matchesGoldenFile('goldens/qr_code/${testCase.name}.png'),
      );
    });
  }

  testWidgets('QrCode unavailable сохраняет fallback contract', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size.square(560);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _goldenApp(
        value: 'http://192.168.1.42:8080',
        size: QrCodeSize.compact,
        state: QrCodeState.unavailable,
      ),
    );
    await tester.pump();

    await expectLater(
      find.byType(QrCode),
      matchesGoldenFile('goldens/qr_code/unavailable_compact.png'),
    );
  });
}

Widget _goldenApp({
  required String value,
  required QrCodeSize size,
  QrCodeState state = QrCodeState.scannable,
}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: TournamentTheme.dark,
  home: Scaffold(
    body: Center(
      child: QrCode(
        value: value,
        semanticLabel: 'QR-код тестового подключения.',
        state: state,
        size: size,
      ),
    ),
  ),
);
