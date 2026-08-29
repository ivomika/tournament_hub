import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/presentation/design_system/design_system.dart';

const _displayAddress = 'http://192.168.1.42:8080';
const _encodedValue = 'http://192.168.1.42:8080/spectator-session';
const _qrSemantics =
    'QR-код подключения к spectator. Адрес также доступен для ручного ввода.';

void main() {
  testWidgets('все состояния строятся на mobile и desktop', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    for (final size in const [Size(320, 1100), Size(1024, 760)]) {
      tester.view.physicalSize = size;
      for (final state in ConnectionQrState.values) {
        await tester.pumpWidget(_app(state: state));
        await tester.pump();
        expect(
          tester.takeException(),
          isNull,
          reason: '${state.name} at $size',
        );
      }
    }
  });

  testWidgets('QR доступен только в сканируемых состояниях', (tester) async {
    final semantics = tester.ensureSemantics();

    for (final state in ConnectionQrState.values) {
      await tester.pumpWidget(_app(state: state));
      await tester.pump();

      final expected = switch (state) {
        ConnectionQrState.ready ||
        ConnectionQrState.reconnecting ||
        ConnectionQrState.stale ||
        ConnectionQrState.copied => findsOneWidget,
        _ => findsNothing,
      };
      expect(find.bySemanticsLabel(_qrSemantics), expected, reason: state.name);
      expect(
        find.byType(QrCode),
        findsOneWidget,
        reason: 'ConnectionQrCard должен композировать QrCode: ${state.name}',
      );
    }
    semantics.dispose();
  });

  testWidgets('encodedValue не раскрывается через semantics', (tester) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      _app(
        state: ConnectionQrState.ready,
        encodedValue: 'http://192.168.1.42:8080/private-payload-marker',
      ),
    );
    await tester.pump();

    expect(
      find.bySemanticsLabel(RegExp('private-payload-marker')),
      findsNothing,
    );
    expect(
      find.bySemanticsLabel('Адрес для браузера: $_displayAddress'),
      findsOneWidget,
    );
    semantics.dispose();
  });

  testWidgets('copy, share и retry делегируются наружу', (tester) async {
    var copyCount = 0;
    var shareCount = 0;
    var retryCount = 0;

    await tester.pumpWidget(
      _app(
        state: ConnectionQrState.ready,
        onCopyAddress: () => copyCount++,
        onShare: () => shareCount++,
        onRetry: () => retryCount++,
      ),
    );
    await tester.tap(find.text('Копировать адрес'));
    await tester.tap(find.text('Поделиться'));
    expect(copyCount, 1);
    expect(shareCount, 1);
    expect(retryCount, 0);

    await tester.pumpWidget(
      _app(
        state: ConnectionQrState.expired,
        onCopyAddress: () => copyCount++,
        onShare: () => shareCount++,
        onRetry: () => retryCount++,
      ),
    );
    await tester.tap(find.text('Попробовать снова'));
    expect(retryCount, 1);
  });

  testWidgets('mobile и desktop используют разные композиции', (tester) async {
    tester.view.devicePixelRatio = 1;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    tester.view.physicalSize = const Size(390, 1000);
    await tester.pumpWidget(_app(state: ConnectionQrState.ready));
    await tester.pump();
    final mobileQr = tester.getTopLeft(
      find.byKey(const Key('connection-qr-panel')),
    );
    final mobileDetails = tester.getTopLeft(
      find.byKey(const Key('connection-qr-details')),
    );
    expect(mobileDetails.dy, greaterThan(mobileQr.dy));

    tester.view.physicalSize = const Size(1024, 760);
    await tester.pumpWidget(_app(state: ConnectionQrState.ready));
    await tester.pump();
    final desktopDetails = tester.getTopLeft(
      find.byKey(const Key('connection-qr-details')),
    );
    final desktopQrRight = tester.getTopRight(
      find.byKey(const Key('connection-qr-panel')),
    );
    expect(desktopDetails.dx, greaterThan(desktopQrRight.dx));
  });

  testWidgets('длинный адрес выдерживает 320 px и 200% text scale', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 1500);
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
      tester.platformDispatcher.clearTextScaleFactorTestValue();
    });

    await tester.pumpWidget(
      _app(
        state: ConnectionQrState.ready,
        displayAddress: 'http://[fe80::20c:29ff:fe9c:409b]:18080/spectator',
      ),
    );
    await tester.pump();

    expect(tester.takeException(), isNull);
  });
}

Widget _app({
  required ConnectionQrState state,
  String encodedValue = _encodedValue,
  String displayAddress = _displayAddress,
  VoidCallback? onCopyAddress,
  VoidCallback? onShare,
  VoidCallback? onRetry,
}) => MaterialApp(
  theme: TournamentTheme.dark,
  home: Scaffold(
    body: SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ConnectionQrCard(
          encodedValue: encodedValue,
          displayAddress: displayAddress,
          state: state,
          onCopyAddress: onCopyAddress,
          onShare: onShare,
          onRetry: onRetry,
        ),
      ),
    ),
  ),
);
