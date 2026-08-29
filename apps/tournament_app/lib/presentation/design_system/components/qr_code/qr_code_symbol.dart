import 'dart:ui';

import 'package:pretty_qr_code/pretty_qr_code.dart';

PrettyQrShape qrCodeShape({
  required Color color,
  required Color background,
  required double moduleRoundFactor,
  required double finderOuterRadiusFactor,
  required double finderCenterRadiusFactor,
}) => _QrCodeSymbol(
  color: color,
  background: background,
  moduleRoundFactor: moduleRoundFactor,
  finderOuterRadiusFactor: finderOuterRadiusFactor,
  finderCenterRadiusFactor: finderCenterRadiusFactor,
);

class _QrCodeSymbol extends PrettyQrShape {
  const _QrCodeSymbol({
    required this.color,
    required this.background,
    required this.moduleRoundFactor,
    required this.finderOuterRadiusFactor,
    required this.finderCenterRadiusFactor,
  });

  final Color color;
  final Color background;
  final double moduleRoundFactor;
  final double finderOuterRadiusFactor;
  final double finderCenterRadiusFactor;

  @override
  void paint(PrettyQrPaintingContext context) {
    PrettyQrSmoothSymbol(
      color: color,
      roundFactor: moduleRoundFactor,
    ).paint(context);

    final module = context.moduleDimension;
    final origin = context.estimatedBounds.topLeft;
    final farEdge = context.matrix.dimension - 7;
    final starts = <Offset>[
      origin,
      origin.translate(farEdge * module, 0),
      origin.translate(0, farEdge * module),
    ];
    final paint = Paint()..color = color;
    final backgroundPaint = Paint()..color = background;

    for (final start in starts) {
      final outer = Rect.fromLTWH(start.dx, start.dy, 7 * module, 7 * module);
      final inner = outer.deflate(module);
      final center = outer.deflate(2 * module);
      final ring = Path()
        ..fillType = PathFillType.evenOdd
        ..addRRect(
          RRect.fromRectAndRadius(
            outer,
            Radius.circular(finderOuterRadiusFactor * module),
          ),
        )
        ..addRRect(
          RRect.fromRectAndRadius(
            inner,
            Radius.circular((finderOuterRadiusFactor - 0.5) * module),
          ),
        );

      context.canvas
        ..drawRect(outer, backgroundPaint)
        ..drawPath(ring, paint)
        ..drawRRect(
          RRect.fromRectAndRadius(
            center,
            Radius.circular(finderCenterRadiusFactor * module),
          ),
          paint,
        );
    }
  }

  @override
  int get hashCode => Object.hash(
    color,
    background,
    moduleRoundFactor,
    finderOuterRadiusFactor,
    finderCenterRadiusFactor,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is _QrCodeSymbol &&
          color == other.color &&
          background == other.background &&
          moduleRoundFactor == other.moduleRoundFactor &&
          finderOuterRadiusFactor == other.finderOuterRadiusFactor &&
          finderCenterRadiusFactor == other.finderCenterRadiusFactor;
}
