import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_focus_ring_theme.dart';

class AppFocusRingPainter extends CustomPainter {
  const AppFocusRingPainter(this.theme);

  final AppFocusRingTheme theme;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = theme.capsule
        ? BorderRadius.circular(size.shortestSide * theme.half)
        : theme.radius!;
    final offsetRadius = Radius.circular(theme.offset);
    final rect = (Offset.zero & size).inflate(
      theme.offset + theme.width * theme.half,
    );
    canvas.drawRRect(
      BorderRadius.only(
        topLeft: radius.topLeft + offsetRadius,
        topRight: radius.topRight + offsetRadius,
        bottomLeft: radius.bottomLeft + offsetRadius,
        bottomRight: radius.bottomRight + offsetRadius,
      ).toRRect(rect),
      Paint()
        ..color = theme.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = theme.width,
    );
  }

  @override
  bool shouldRepaint(covariant AppFocusRingPainter oldDelegate) =>
      oldDelegate.theme.color != theme.color ||
      oldDelegate.theme.width != theme.width ||
      oldDelegate.theme.offset != theme.offset ||
      oldDelegate.theme.radius != theme.radius ||
      oldDelegate.theme.capsule != theme.capsule ||
      oldDelegate.theme.half != theme.half;
}
