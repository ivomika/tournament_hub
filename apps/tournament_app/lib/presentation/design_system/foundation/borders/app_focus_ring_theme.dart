import 'package:flutter/material.dart';

/// Оформление передаётся из runtime-темы компонента, без собственных defaults.
class AppFocusRingTheme {
  const AppFocusRingTheme({
    required this.color,
    required this.width,
    required this.offset,
    required this.radius,
    required this.capsule,
    required this.half,
  }) : assert(capsule || radius != null);

  final Color color;
  final double width;
  final double offset;

  /// Не нужен для капсулы: её углы определяются фактическим размером.
  final BorderRadius? radius;
  final bool capsule;
  final double half;
}
