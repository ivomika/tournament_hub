import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';

enum AppSurfaceTone { adaptive, surface, raised }

enum AppSurfaceShape { panel, nested, card, flat, sheet, largeSheet }

enum AppSurfaceInset { standard, none }

class AppSurfaceTheme {
  const AppSurfaceTheme({
    required this.color,
    required this.radius,
    required this.padding,
  });
  factory AppSurfaceTheme.of(
    BuildContext context,
    AppSurfaceTone tone,
    AppSurfaceShape shape,
    AppSurfaceInset inset,
  ) {
    final runtimeTheme = Theme.of(context),
        runtimeShape = runtimeTheme.extension<AppShape>()!,
        space = runtimeTheme.extension<AppSpacing>()!;
    final desktop =
        MediaQuery.sizeOf(context).width >
        runtimeTheme.extension<AppResponsive>()!.mobileToDesktopWidth;
    return AppSurfaceTheme(
      color:
          tone == AppSurfaceTone.raised ||
              (tone == AppSurfaceTone.adaptive && desktop)
          ? runtimeTheme.colorScheme.surfaceContainerHigh
          : runtimeTheme.colorScheme.surface,
      radius: switch (shape) {
        AppSurfaceShape.panel =>
          desktop ? runtimeShape.desktopSurface : runtimeShape.surface,
        AppSurfaceShape.nested => runtimeShape.nested,
        AppSurfaceShape.card => runtimeShape.surface,
        AppSurfaceShape.sheet => runtimeShape.sheet,
        AppSurfaceShape.largeSheet => BorderRadius.only(
          topLeft: runtimeShape.panel.topLeft,
          topRight: runtimeShape.panel.topRight,
        ),
        AppSurfaceShape.flat => BorderRadius.circular(space.space0),
      },
      padding: EdgeInsets.all(
        inset == AppSurfaceInset.none ? space.space0 : space.space24,
      ),
    );
  }
  final Color color;
  final BorderRadius radius;
  final EdgeInsets padding;
}
