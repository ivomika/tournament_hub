import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';

void main() {
  for (final state in ConnectionQrState.values) {
    testWidgets('ConnectionQrCard ${state.name} сохраняет mobile contract', (
      tester,
    ) async {
      tester.view.devicePixelRatio = 1;
      tester.view.physicalSize = const Size(390, 900);
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(_goldenApp(state: state));
      await tester.pump();

      expect(tester.takeException(), isNull);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/connection_qr_card/${state.name}_mobile.png',
        ),
      );
    });
  }

  testWidgets('ConnectionQrCard сохраняет desktop split с длинным адресом', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1280, 720);
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      _goldenApp(
        state: ConnectionQrState.ready,
        address: 'http://[fe80::20c:29ff:fe9c:409b]:18080/spectator',
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile(
        'goldens/connection_qr_card/ready_desktop_long_address.png',
      ),
    );
  });
}

Widget _goldenApp({
  required ConnectionQrState state,
  String address = 'http://192.168.1.42:8080',
}) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: TournamentTheme.dark,
  home: Scaffold(
    body: SingleChildScrollView(
      child: DsPagePadding(
        child: ConnectionQrCard(
          encodedValue: address,
          displayAddress: address,
          state: state,
          onCopyAddress: () {},
          onShare: () {},
          onRetry: () {},
        ),
      ),
    ),
  ),
);
