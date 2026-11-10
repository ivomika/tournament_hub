import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_modal_canvas_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

class MatchResultScreenTheme extends AppModalCanvasTheme {
  MatchResultScreenTheme.of(BuildContext context) : super.of(context) {
    final appearance = Theme.of(context),
        runtimeSpacing = appearance.extension<AppSpacing>()!,
        shape = appearance.extension<AppShape>()!;
    final base = AppIdentityTheme.of(
      context,
      AppIdentityKind.character,
      AppIdentityLayout.stacked,
      MediaQuery.sizeOf(context).width,
    );
    playerIdentity = base.copyWith(
      avatar: base.avatar.copyWith(
        extent: desktop ? resultDesktopAvatar : matchMobileAvatar,
      ),
      leading: centerCross,
      textAlign: centerText,
      primary: base.primary.copyWith(
        fontSize: desktop
            ? appearance.textTheme.titleLarge!.fontSize
            : (MediaQuery.sizeOf(context).width * matchMobileNameFactor).clamp(
                appearance.textTheme.bodyMedium!.fontSize!,
                appearance.textTheme.titleLarge!.fontSize!,
              ),
      ),
    );
    sheetSurface = AppSurfaceTheme(
      color: appearance.colorScheme.surface,
      radius: desktop
          ? shape.surface
          : BorderRadius.only(
              topLeft: shape.panel.topLeft,
              topRight: shape.panel.topRight,
            ),
      padding: EdgeInsets.all(
        desktop ? runtimeSpacing.space32 : runtimeSpacing.space24,
      ),
    );
    outcomeHeight =
        appearance.textTheme.bodySmall!.fontSize! * resultOutcomeFactor;
  }
  late final AppIdentityTheme playerIdentity;
  late final AppSurfaceTheme sheetSurface;
  late final double outcomeHeight;
}
