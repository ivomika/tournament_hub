import 'package:flutter/material.dart';

import 'ds_surface_theme.dart';

enum DsSurfaceTone { base, elevated, accent }

class DsSurface extends StatelessWidget {
  const DsSurface({
    required this.child,
    this.tone = DsSurfaceTone.base,
    super.key,
  });

  final Widget child;
  final DsSurfaceTone tone;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsSurfaceTheme>()!;
    final (background, border) = switch (tone) {
      DsSurfaceTone.base => (theme.background, theme.border),
      DsSurfaceTone.elevated => (theme.elevatedBackground, theme.border),
      DsSurfaceTone.accent => (theme.accentBackground, theme.accentBorder),
    };
    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: Padding(padding: EdgeInsets.all(theme.padding), child: child),
    );
  }
}
