import 'package:flutter/widgets.dart';

/// Только токены, которые нужны текущим foundation-сценариям.
class FoundationLayout {
  const FoundationLayout();

  final pagePadding = const EdgeInsets.all(24);
  final tilePadding = const EdgeInsets.all(20);
  final smallGap = 8.0;
  final gap = 16.0;
  final sectionGap = 32.0;
  final tileWidth = 320.0;
  final colorTileHeight = 136.0;
  final swatchSize = 44.0;
  final borderWidth = 1.0;
  final cornerRadius = const BorderRadius.all(Radius.circular(16));
  final swatchRadius = const BorderRadius.all(Radius.circular(10));
  final fullWidth = double.infinity;
  final textAlignment = CrossAxisAlignment.start;
  final centered = MainAxisAlignment.center;
}
