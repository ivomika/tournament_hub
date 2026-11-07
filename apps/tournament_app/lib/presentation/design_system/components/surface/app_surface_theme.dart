import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';

enum AppSurfaceTone { adaptive, surface, raised }

enum AppSurfaceShape { panel, nested, card }

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
    final t = Theme.of(context),
        s = t.extension<AppShape>()!,
        space = t.extension<AppSpacing>()!;
    final desktop =
        MediaQuery.sizeOf(context).width >=
        t.extension<AppResponsive>()!.mobileToDesktopWidth;
    return AppSurfaceTheme(
      color:
          tone == AppSurfaceTone.raised ||
              (tone == AppSurfaceTone.adaptive && desktop)
          ? t.colorScheme.surfaceContainerHigh
          : t.colorScheme.surface,
      radius: switch (shape) {
        AppSurfaceShape.panel => desktop ? s.desktopSurface : s.surface,
        AppSurfaceShape.nested => s.nested,
        AppSurfaceShape.card => s.surface,
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
