import 'package:qr/qr.dart';

/// Immutable visual matrix; no third-party types cross the adapter boundary.
class AppQrMatrix {
  AppQrMatrix(List<List<bool>> rows)
    : modules = List.unmodifiable(rows.map(List<bool>.unmodifiable));
  final List<List<bool>> modules;
}

/// Local pure encoding for rendering; no network, session or URL creation.
abstract final class AppQrMatrixEncoder {
  static AppQrMatrix encode(String data) {
    try {
      final image = QrImage(
        QrCode(
          payload: QrPayload()
            ..addECI(QrEciValue.utf8)
            ..addString(data),
          errorCorrectLevel: QrErrorCorrectLevel.medium,
          minTypeNumber: 4,
        ),
      );
      return AppQrMatrix([
        for (var row = 0; row < image.moduleCount; row++)
          [
            for (var col = 0; col < image.moduleCount; col++)
              image.isDark(row, col),
          ],
      ]);
    } on InputTooLongException {
      throw ArgumentError("QR payload exceeds version40 capacity");
    }
  }
}
