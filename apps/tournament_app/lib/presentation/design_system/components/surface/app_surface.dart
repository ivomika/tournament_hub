import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface_theme.dart';

class AppSurface extends StatelessWidget {
  const AppSurface({
    required this.child,
    this.tone = AppSurfaceTone.adaptive,
    this.shape = AppSurfaceShape.panel,
    this.inset = AppSurfaceInset.standard,
    super.key,
  });
  final Widget child;
  final AppSurfaceTone tone;
  final AppSurfaceShape shape;
  final AppSurfaceInset inset;
  @override
  Widget build(BuildContext context) {
    final theme = AppSurfaceTheme.of(context, tone, shape, inset);
    return DecoratedBox(
      decoration: BoxDecoration(color: theme.color, borderRadius: theme.radius),
      child: Padding(padding: theme.padding, child: child),
    );
  }
}
