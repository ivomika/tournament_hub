import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/app_qr_code_theme.dart';
import 'package:tournament_app/presentation/design_system/components/qr_code/encoding/app_qr_matrix_encoder.dart';

/// Vector artwork in QR module coordinates. Styling comes from the runtime theme.
class AppQrPainter extends CustomPainter {
  AppQrPainter({required this.matrix, required this.theme});
  final AppQrMatrix matrix;
  final AppQrCodeTheme theme;

  bool _dark(int row, int col) =>
      row >= 0 &&
      col >= 0 &&
      row < matrix.modules.length &&
      col < matrix.modules.length &&
      matrix.modules[row][col];

  @override
  void paint(Canvas canvas, Size size) {
    final moduleCount = matrix.modules.length;
    final unit = size.width / (moduleCount + theme.quietZone * 2);
    final ink = Paint()..color = theme.foreground;
    final paper = Paint()..color = theme.background;
    canvas.drawRect(Offset.zero & size, paper);
    canvas.save();
    canvas.translate(theme.quietZone * unit, theme.quietZone * unit);
    canvas.scale(unit);
    final round = Radius.circular(theme.moduleRadius);
    final square = theme.squareRadius;
    final modulesPath = Path();
    for (var row = 0; row < moduleCount; row++) {
      for (var col = 0; col < moduleCount; col++) {
        // Finder patterns have standardized 7/5/3 geometry, styled below.
        if ((row < 7 && (col < 7 || col >= moduleCount - 7)) ||
            (row >= moduleCount - 7 && col < 7)) {
          continue;
        }
        if (!_dark(row, col)) continue;
        modulesPath.addRRect(
          RRect.fromRectAndCorners(
            Rect.fromLTWH(col.toDouble(), row.toDouble(), 1, 1),
            topLeft: !_dark(row - 1, col) && !_dark(row, col - 1)
                ? round
                : square,
            topRight: !_dark(row - 1, col) && !_dark(row, col + 1)
                ? round
                : square,
            bottomLeft: !_dark(row + 1, col) && !_dark(row, col - 1)
                ? round
                : square,
            bottomRight: !_dark(row + 1, col) && !_dark(row, col + 1)
                ? round
                : square,
          ),
        );
      }
    }
    canvas.drawPath(modulesPath, ink);
    for (final origin in [
      (0.0, 0.0),
      ((moduleCount - 7).toDouble(), 0.0),
      (0.0, (moduleCount - 7).toDouble()),
    ]) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(origin.$1, origin.$2, 7, 7),
          Radius.circular(theme.finderOuterRadius),
        ),
        ink,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(origin.$1 + 1, origin.$2 + 1, 5, 5),
          Radius.circular(theme.finderGapRadius),
        ),
        paper,
      );
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(origin.$1 + 2, origin.$2 + 2, 3, 3),
          Radius.circular(theme.finderCenterRadius),
        ),
        ink,
      );
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant AppQrPainter oldDelegate) =>
      oldDelegate.matrix != matrix || oldDelegate.theme != theme;
}
