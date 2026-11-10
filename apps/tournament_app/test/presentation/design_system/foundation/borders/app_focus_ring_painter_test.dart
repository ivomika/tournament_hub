import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_painter.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_theme.dart';

void main() => _FocusRingTests.run();

abstract final class _FocusRingTests {
  static void run() {
    test('preserves all elliptical corners and external gap', _corners);
    test('capsule follows shortest side', _capsule);
    test('equal visual values do not repaint', _repaint);
    testWidgets('asymmetric focus ring golden', _golden);
  }

  static AppFocusRingTheme _theme({bool capsule = false, double width = 2}) =>
      AppFocusRingTheme(
        color: const Color(0xFFFFAA00),
        width: width,
        offset: 3,
        radius: const BorderRadius.only(
          topLeft: Radius.elliptical(4, 6),
          topRight: Radius.elliptical(8, 10),
          bottomLeft: Radius.elliptical(12, 14),
          bottomRight: Radius.elliptical(16, 18),
        ),
        capsule: capsule,
        half: 0.5,
      );

  static void _corners() {
    final canvas = _RecordingCanvas();
    AppFocusRingPainter(_theme()).paint(canvas, const Size(200, 100));
    expect(
      canvas.rect,
      const BorderRadius.only(
        topLeft: Radius.elliptical(7, 9),
        topRight: Radius.elliptical(11, 13),
        bottomLeft: Radius.elliptical(15, 17),
        bottomRight: Radius.elliptical(19, 21),
      ).toRRect(const Rect.fromLTRB(-4, -4, 204, 104)),
    );
    expect(canvas.paintValue!.strokeWidth, 2);
    expect(canvas.paintValue!.style, PaintingStyle.stroke);
    expect(canvas.paintValue!.color.toARGB32(), _theme().color.toARGB32());
  }

  static void _capsule() {
    final canvas = _RecordingCanvas();
    AppFocusRingPainter(_theme(capsule: true))
        .paint(canvas, const Size(200, 56));
    expect(canvas.rect!.tlRadius, const Radius.circular(31));
    expect(canvas.rect!.brRadius, const Radius.circular(31));
  }

  static void _repaint() {
    final painter = AppFocusRingPainter(_theme());
    expect(painter.shouldRepaint(AppFocusRingPainter(_theme())), isFalse);
    expect(
      painter.shouldRepaint(AppFocusRingPainter(_theme(width: 4))),
      isTrue,
    );
    expect(
      painter.shouldRepaint(AppFocusRingPainter(_theme(capsule: true))),
      isTrue,
    );
  }

  static Future<void> _golden(WidgetTester tester) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: RepaintBoundary(
            key: const ValueKey('focus-ring'),
            child: ColoredBox(
              color: const Color(0xFF101216),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: CustomPaint(
                  foregroundPainter: AppFocusRingPainter(_theme()),
                  child: const SizedBox(width: 200, height: 100),
                ),
              ),
            ),
          ),
        ),
      ),
    );
    await expectLater(
      find.byKey(const ValueKey('focus-ring')),
      matchesGoldenFile(
        Uri.file(
          '${Directory.current.path}/lib/presentation/design_system/foundation/borders/golden/${Platform.operatingSystem}/asymmetric-focus.png',
        ),
      ),
    );
  }
}

class _RecordingCanvas implements Canvas {
  RRect? rect;
  Paint? paintValue;

  @override
  void drawRRect(RRect rrect, Paint paint) {
    rect = rrect;
    paintValue = paint;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
