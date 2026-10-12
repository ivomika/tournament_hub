import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/palette/palette_theme.dart';

typedef ColorSample = ({String label, Color value});

class ColorPalette extends StatelessWidget {
  const ColorPalette({
    required this.theme,
    required this.title,
    required this.description,
    required this.samples,
    super.key,
  });

  final PaletteTheme theme;
  final String title;
  final String description;
  final List<ColorSample> samples;

  // Внешнее представление цвета, а не строковый discriminator состояния.
  String _hex(Color color) =>
      '#${color.toARGB32().toRadixString(16).substring(2).toUpperCase()}';

  @override
  Widget build(BuildContext context) {
    final layout = theme.layout;
    return ColoredBox(
      color: theme.colors.background,
      child: SingleChildScrollView(
        padding: layout.pagePadding,
        child: Column(
          crossAxisAlignment: layout.textAlignment,
          children: [
            Text(title, style: theme.heading),
            SizedBox(height: layout.smallGap),
            Text(description, style: theme.description),
            SizedBox(height: layout.sectionGap),
            Wrap(
              spacing: layout.gap,
              runSpacing: layout.gap,
              children: [
                for (final sample in samples)
                  SizedBox(
                    width: layout.tileWidth,
                    height: layout.colorTileHeight,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colors.surface,
                        borderRadius: layout.cornerRadius,
                        border: Border.all(
                          color: theme.colors.border,
                          width: layout.borderWidth,
                        ),
                      ),
                      child: Padding(
                        padding: layout.tilePadding,
                        child: Row(
                          children: [
                            SizedBox(
                              width: layout.swatchSize,
                              height: layout.swatchSize,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: sample.value,
                                  borderRadius: layout.swatchRadius,
                                  border: Border.all(
                                    color: theme.colors.border,
                                    width: layout.borderWidth,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: layout.gap),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: layout.centered,
                                crossAxisAlignment: layout.textAlignment,
                                children: [
                                  Text(sample.label, style: theme.tokenLabel),
                                  SizedBox(height: layout.smallGap),
                                  Text(
                                    _hex(sample.value),
                                    style: theme.tokenValue,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
