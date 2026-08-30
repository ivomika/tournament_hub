import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';
import 'package:tournament_hub_app/presentation/screens/host_open/host_open_screen.dart';
import 'package:tournament_hub_app/presentation/screens/join/join_screen.dart';

void main() {
  for (final viewport in const [
    (name: 'mobile', size: Size(390, 844)),
    (name: 'tablet', size: Size(768, 1024)),
    (name: 'desktop', size: Size(1280, 960)),
    (name: 'wide_desktop', size: Size(1800, 1000)),
  ]) {
    testWidgets('role connection сохраняет ${viewport.name} composition', (
      tester,
    ) async {
      await _setViewport(tester, viewport.size);

      await tester.pumpWidget(_app(const HostOpenScreenPreview()));
      await tester.pumpAndSettle();

      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile(
          'goldens/role_connection/host_open_${viewport.name}.png',
        ),
      );
    });
  }

  testWidgets('participant join сохраняет scanner-code composition', (
    tester,
  ) async {
    await _setViewport(tester, const Size(390, 844));
    await tester.pumpWidget(_app(const JoinScreenPreview()));
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/role_connection/join_mobile.png'),
    );
  });

  testWidgets('spectator dialog читается в large-TV composition', (
    tester,
  ) async {
    await _setViewport(tester, const Size(1920, 1080));
    await tester.pumpWidget(
      _app(
        SpectatorAccessDialog(
          data: const SpectatorAccessViewData(
            endpoint: 'http://192.168.1.42:8080',
            state: ConnectionQrState.ready,
            connectedClients: 2,
          ),
          onClose: () {},
          onCopyAddress: () {},
          onShare: () {},
          onRetry: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    await expectLater(
      find.byType(MaterialApp),
      matchesGoldenFile('goldens/role_connection/spectator_tv.png'),
    );
  });
}

Future<void> _setViewport(WidgetTester tester, Size size) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = size;
  addTearDown(() {
    tester.view.resetPhysicalSize();
    tester.view.resetDevicePixelRatio();
  });
}

Widget _app(Widget child) => MaterialApp(
  debugShowCheckedModeBanner: false,
  theme: TournamentTheme.dark,
  home: child,
);
