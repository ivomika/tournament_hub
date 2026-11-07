import 'package:flutter/widgets.dart';

/// Размеры среды визуального сравнения, не layout-токены продукта.
enum VisualViewport {
  mobile(Size(390, 844)),
  desktop(Size(1440, 900));

  const VisualViewport(this.size);

  final Size size;
}

abstract final class ResponsiveViewports {
  static const boundaries = <Size>[
    Size(390, 844),
    Size(739, 900),
    Size(740, 900),
    Size(741, 900),
    Size(999, 900),
    Size(1000, 900),
    Size(1001, 900),
    Size(1099, 900),
    Size(1100, 900),
    Size(1101, 900),
    Size(1440, 900),
  ];
}
