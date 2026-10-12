import 'package:flutter/widgets.dart';

/// Размеры среды визуального сравнения, не layout-токены продукта.
enum VisualViewport {
  mobile(Size(390, 844)),
  desktop(Size(1440, 900));

  const VisualViewport(this.size);

  final Size size;
}
