import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/rendering.dart';
import 'package:zxing2/qrcode.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/app_qr_code.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/app_qr_painter.dart';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/qr_fixture.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

void main() => _QrTests.run();

abstract final class _QrTests {
  static void run() {
    testWidgets(
      'generated QR current theme semantics scaled native goldens',
      _samples,
    );
    testWidgets(
      'rendered styled QR decodes short long and UTF8 links at mobile and desktop sizes',
      _readsPixels,
    );
  }

  static Future<void> _readsPixels(WidgetTester tester) async {
    for (final width in [220.0, 320.0]) {
      for (final payload in [
        'http://host.local/spectator',
        'https://example.test/spectator/tournament-with-a-long-session-address?session=48271930615&token=abcdefghijklmnopqrstuvwxyz0123456789',
        'https://example.test/турнир?имя=Иван',
      ]) {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.dark(),
            home: Scaffold(
              body: Align(
                alignment: Alignment.topLeft,
                child: RepaintBoundary(
                  key: const ValueKey('pixels'),
                  child: SizedBox(
                    width: width,
                    child: AppQrCode(data: payload, semanticLabel: 'QR'),
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        final boundary = tester.renderObject<RenderRepaintBoundary>(
          find.byKey(const ValueKey('pixels')),
        );
        final decoded = await tester.runAsync(() => _decodePixels(boundary));
        expect(
          decoded,
          payload,
          reason: 'Rendered $width px QR must scan without encoding hints',
        );
        expect(tester.takeException(), isNull);
      }
    }
  }

  static Future<String> _decodePixels(RenderRepaintBoundary boundary) async {
    final image = await boundary.toImage();
    try {
      final bytes = (await image.toByteData(
        format: ui.ImageByteFormat.rawRgba,
      ))!.buffer.asUint8List();
      final pixels = Int32List(image.width * image.height);
      for (var i = 0; i < pixels.length; i++) {
        pixels[i] =
            (bytes[i * 4] << 16) | (bytes[i * 4 + 1] << 8) | bytes[i * 4 + 2];
      }
      final decoded = QRCodeReader().decode(
        BinaryBitmap(
          HybridBinarizer(
            RGBLuminanceSource(image.width, image.height, pixels),
          ),
        ),
      );
      final segments =
          decoded.resultMetadata[ResultMetadataType.byteSegments]!
              as List<Int8List>;
      return utf8.decode(Uint8List.fromList(segments.single));
    } finally {
      image.dispose();
    }
  }

  static Future<void> _samples(WidgetTester tester) async {
    final base = AppTheme.dark(), handle = tester.ensureSemantics();
    for (final code in [false, true]) {
      await tester.pumpWidget(
        MaterialApp(
          theme: base.copyWith(
            colorScheme: base.colorScheme.copyWith(onSurface: Colors.white),
            scaffoldBackgroundColor: Colors.blue,
          ),
          localizationsDelegates:
              FoundationLocalizations.localizationsDelegates,
          supportedLocales: FoundationLocalizations.supportedLocales,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: MediaQuery(
                data: const MediaQueryData(
                  size: Size(390, 844),
                  textScaler: TextScaler.linear(1.6),
                ),
                child: RepaintBoundary(
                  key: const ValueKey('qr'),
                  child: SizedBox(width: 220, child: QrFixture(withCode: code)),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        find.bySemanticsLabel('Демонстрационный QR подключения участников'),
        findsOneWidget,
      );
      expect(
        (tester
                    .widgetList<CustomPaint>(find.byType(CustomPaint))
                    .singleWhere((paint) => paint.painter is AppQrPainter)
                    .painter!
                as AppQrPainter)
            .theme
            .foreground,
        Colors.blue,
      );
      await expectLater(
        find.byKey(const ValueKey('qr')),
        matchesGoldenFile(
          Uri.file(
            '${Directory.current.path}/lib/presentation/design_system/components/qr_code/golden/${Platform.operatingSystem}/${code ? 'access' : 'graphic'}-scaled-theme.png',
          ),
        ),
      );
    }
    handle.dispose();
  }
}
