import 'package:flutter/material.dart';

import 'ds_surface_theme.dart';

class DsSurface extends StatelessWidget {
  const DsSurface({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<DsSurfaceTheme>()!;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.background,
        border: Border.all(color: theme.border),
        borderRadius: BorderRadius.circular(theme.radius),
      ),
      child: Padding(padding: EdgeInsets.all(theme.padding), child: child),
    );
  }
}
