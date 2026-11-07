import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon_theme.dart';

class AppIcon extends StatelessWidget {
  const AppIcon(
    this.glyph, {
    this.size = AppIconSize.standard,
    this.tone = AppIconTone.primary,
    this.color,
    this.semanticLabel,
    super.key,
  });
  final AppGlyph glyph;
  final AppIconSize size;
  final AppIconTone tone;
  final Color? color;
  final String? semanticLabel;
  @override
  Widget build(BuildContext context) {
    final theme = AppIconTheme.of(context, size, tone);
    return Semantics(
      label: semanticLabel,
      image: semanticLabel != null,
      excludeSemantics: true,
      child: CustomPaint(
        size: Size.square(theme.extent),
        painter: _GlyphPainter(
          glyph,
          theme,
          color ?? theme.color,
          Directionality.of(context) == TextDirection.rtl && glyph.directional,
        ),
      ),
    );
  }
}

class _GlyphPainter extends CustomPainter {
  const _GlyphPainter(this.glyph, this.theme, this.color, this.mirror);
  final AppGlyph glyph;
  final AppIconTheme theme;
  final Color color;
  final bool mirror;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(size.width / theme.grid, size.height / theme.grid);
    if (mirror) {
      canvas.translate(theme.grid, 0);
      canvas.scale(-1, 1);
    }
    canvas.drawPath(
      glyph.path(),
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = theme.stroke
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _GlyphPainter old) =>
      old.glyph != glyph ||
      old.theme != theme ||
      old.color != color ||
      old.mirror != mirror;
}
