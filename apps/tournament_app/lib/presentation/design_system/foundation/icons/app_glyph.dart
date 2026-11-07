import 'package:flutter/widgets.dart';

/// Исходные SVG symbols; координаты начертания на grid24.
enum AppGlyph {
  shareLink,
  chevron,
  settings,
  info,
  contact,
  close,
  minus,
  arrow,
  back,
  person,
  history,
  plus,
  qr,
  trash,
  edit,
  alert,
  check,
  trophy;

  bool get directional => this == chevron || this == arrow || this == back;
  Path path() => switch (this) {
    AppGlyph.shareLink =>
      Path()
        ..addOval(Rect.fromLTWH(15.0, 2.0, 6.0, 6.0))
        ..addOval(Rect.fromLTWH(3.0, 9.0, 6.0, 6.0))
        ..addOval(Rect.fromLTWH(15.0, 16.0, 6.0, 6.0))
        ..moveTo(8.6, 10.5)
        ..lineTo(15.399999999999999, 6.5)
        ..moveTo(8.599999999999998, 13.5)
        ..lineTo(15.399999999999999, 17.5),
    AppGlyph.chevron =>
      Path()
        ..moveTo(9.0, 6.0)
        ..lineTo(15.0, 12.0)
        ..lineTo(9.0, 18.0),
    AppGlyph.settings =>
      Path()
        ..moveTo(4.0, 7.0)
        ..lineTo(20.0, 7.0)
        ..moveTo(4.0, 17.0)
        ..lineTo(20.0, 17.0)
        ..addOval(Rect.fromLTWH(6.0, 4.0, 6.0, 6.0))
        ..addOval(Rect.fromLTWH(12.0, 14.0, 6.0, 6.0)),
    AppGlyph.info =>
      Path()
        ..addOval(Rect.fromLTWH(3.0, 3.0, 18.0, 18.0))
        ..moveTo(12.0, 11.0)
        ..lineTo(12.0, 17.0)
        ..moveTo(12.0, 7.0)
        ..lineTo(12.0, 7.01),
    AppGlyph.contact =>
      Path()
        ..moveTo(4.0, 4.0)
        ..lineTo(20.0, 4.0)
        ..lineTo(20.0, 16.0)
        ..lineTo(9.0, 16.0)
        ..lineTo(4.0, 20.0)
        ..lineTo(4.0, 4.0)
        ..close()
        ..moveTo(8.0, 8.0)
        ..lineTo(16.0, 8.0)
        ..moveTo(8.0, 12.0)
        ..lineTo(13.0, 12.0),
    AppGlyph.close =>
      Path()
        ..moveTo(6.0, 6.0)
        ..lineTo(18.0, 18.0)
        ..moveTo(18.0, 6.0)
        ..lineTo(6.0, 18.0),
    AppGlyph.minus =>
      Path()
        ..moveTo(5.0, 12.0)
        ..lineTo(19.0, 12.0),
    AppGlyph.arrow =>
      Path()
        ..moveTo(5.0, 12.0)
        ..lineTo(19.0, 12.0)
        ..moveTo(13.0, 6.0)
        ..lineTo(19.0, 12.0)
        ..lineTo(13.0, 18.0),
    AppGlyph.back =>
      Path()
        ..moveTo(14.0, 6.0)
        ..lineTo(8.0, 12.0)
        ..lineTo(14.0, 18.0),
    AppGlyph.person =>
      Path()
        ..addOval(Rect.fromLTWH(8.5, 4.5, 7.0, 7.0))
        ..moveTo(5.0, 20.0)
        ..lineTo(5.0, 18.0)
        ..cubicTo(
          5.000000000,
          14.134006751,
          8.134006751,
          11.000000000,
          12.000000000,
          11.000000000,
        )
        ..cubicTo(
          15.865993249,
          11.000000000,
          19.000000000,
          14.134006751,
          19.000000000,
          18.000000000,
        )
        ..lineTo(19.0, 20.0),
    AppGlyph.history =>
      Path()
        ..moveTo(3.0, 11.0)
        ..cubicTo(
          3.305204343,
          6.776603019,
          6.513185016,
          3.337171185,
          10.705126651,
          2.738959616,
        )
        ..cubicTo(
          14.897068285,
          2.140748047,
          18.939054295,
          4.545572456,
          20.413418970,
          8.515015811,
        )
        ..cubicTo(
          21.887783645,
          12.484459167,
          20.395712615,
          16.944790475,
          16.829670367,
          19.228115777,
        )
        ..cubicTo(
          13.263628119,
          21.511441079,
          8.588225996,
          21.000122854,
          5.600000000,
          18.000000000,
        )
        ..moveTo(3.0, 5.0)
        ..lineTo(3.0, 11.0)
        ..lineTo(9.0, 11.0)
        ..moveTo(12.0, 7.0)
        ..lineTo(12.0, 12.0)
        ..lineTo(15.0, 14.0),
    AppGlyph.plus =>
      Path()
        ..moveTo(12.0, 5.0)
        ..lineTo(12.0, 19.0)
        ..moveTo(5.0, 12.0)
        ..lineTo(19.0, 12.0),
    AppGlyph.qr =>
      Path()
        ..moveTo(4.0, 3.0)
        ..lineTo(8.0, 3.0)
        ..quadraticBezierTo(9.0, 3.0, 9.0, 4.0)
        ..lineTo(9.0, 8.0)
        ..quadraticBezierTo(9.0, 9.0, 8.0, 9.0)
        ..lineTo(4.0, 9.0)
        ..quadraticBezierTo(3.0, 9.0, 3.0, 8.0)
        ..lineTo(3.0, 4.0)
        ..quadraticBezierTo(3.0, 3.0, 4.0, 3.0)
        ..close()
        ..moveTo(16.0, 3.0)
        ..lineTo(20.0, 3.0)
        ..quadraticBezierTo(21.0, 3.0, 21.0, 4.0)
        ..lineTo(21.0, 8.0)
        ..quadraticBezierTo(21.0, 9.0, 20.0, 9.0)
        ..lineTo(16.0, 9.0)
        ..quadraticBezierTo(15.0, 9.0, 15.0, 8.0)
        ..lineTo(15.0, 4.0)
        ..quadraticBezierTo(15.0, 3.0, 16.0, 3.0)
        ..close()
        ..moveTo(4.0, 15.0)
        ..lineTo(8.0, 15.0)
        ..quadraticBezierTo(9.0, 15.0, 9.0, 16.0)
        ..lineTo(9.0, 20.0)
        ..quadraticBezierTo(9.0, 21.0, 8.0, 21.0)
        ..lineTo(4.0, 21.0)
        ..quadraticBezierTo(3.0, 21.0, 3.0, 20.0)
        ..lineTo(3.0, 16.0)
        ..quadraticBezierTo(3.0, 15.0, 4.0, 15.0)
        ..close()
        ..moveTo(15.0, 15.0)
        ..lineTo(18.0, 15.0)
        ..lineTo(18.0, 18.0)
        ..lineTo(21.0, 18.0)
        ..moveTo(15.0, 21.0)
        ..lineTo(18.0, 21.0)
        ..moveTo(21.0, 12.0)
        ..lineTo(21.0, 15.0)
        ..moveTo(12.0, 12.0)
        ..lineTo(15.0, 12.0)
        ..moveTo(6.0, 6.0)
        ..lineTo(6.01, 6.0)
        ..moveTo(18.0, 6.0)
        ..lineTo(18.01, 6.0)
        ..moveTo(6.0, 18.0)
        ..lineTo(6.01, 18.0),
    AppGlyph.trash =>
      Path()
        ..moveTo(4.0, 7.0)
        ..lineTo(20.0, 7.0)
        ..moveTo(9.0, 7.0)
        ..lineTo(9.0, 4.0)
        ..lineTo(15.0, 4.0)
        ..lineTo(15.0, 7.0)
        ..moveTo(6.0, 7.0)
        ..lineTo(7.0, 20.0)
        ..lineTo(17.0, 20.0)
        ..lineTo(18.0, 7.0)
        ..moveTo(10.0, 10.0)
        ..lineTo(10.0, 17.0)
        ..moveTo(14.0, 10.0)
        ..lineTo(14.0, 17.0),
    AppGlyph.edit =>
      Path()
        ..moveTo(15.0, 4.0)
        ..lineTo(20.0, 9.0)
        ..lineTo(9.0, 20.0)
        ..lineTo(4.0, 20.0)
        ..lineTo(4.0, 15.0)
        ..lineTo(15.0, 4.0)
        ..close()
        ..moveTo(12.0, 7.0)
        ..lineTo(17.0, 12.0),
    AppGlyph.alert =>
      Path()
        ..addOval(Rect.fromLTWH(3.0, 3.0, 18.0, 18.0))
        ..moveTo(12.0, 7.0)
        ..lineTo(12.0, 13.0)
        ..moveTo(12.0, 17.0)
        ..lineTo(12.0, 17.01),
    AppGlyph.check =>
      Path()
        ..moveTo(5.0, 12.0)
        ..lineTo(9.0, 16.0)
        ..lineTo(19.0, 6.0),
    AppGlyph.trophy =>
      Path()
        ..moveTo(8.0, 3.0)
        ..lineTo(16.0, 3.0)
        ..lineTo(16.0, 9.0)
        ..cubicTo(
          16.000000000,
          11.209138999,
          14.209138999,
          13.000000000,
          12.000000000,
          13.000000000,
        )
        ..cubicTo(
          9.790861001,
          13.000000000,
          8.000000000,
          11.209138999,
          8.000000000,
          9.000000000,
        )
        ..lineTo(8.0, 3.0)
        ..close()
        ..moveTo(8.0, 5.0)
        ..lineTo(4.0, 5.0)
        ..lineTo(4.0, 7.0)
        ..cubicTo(
          4.000000000,
          9.209138999,
          5.790861001,
          11.000000000,
          8.000000000,
          11.000000000,
        )
        ..moveTo(16.0, 5.0)
        ..lineTo(20.0, 5.0)
        ..lineTo(20.0, 7.0)
        ..cubicTo(
          20.000000000,
          9.209138999,
          18.209138999,
          11.000000000,
          16.000000000,
          11.000000000,
        )
        ..moveTo(12.0, 13.0)
        ..lineTo(12.0, 19.0)
        ..moveTo(8.0, 21.0)
        ..lineTo(16.0, 21.0)
        ..moveTo(10.0, 19.0)
        ..lineTo(14.0, 19.0),
  };
}
