import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_dialog_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/elevation/app_elevation.dart';

class AppDialogTheme {
  AppDialogTheme.of(BuildContext context) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        runtimeDialogMetrics = runtimeTheme.extension<AppDialogMetrics>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!,
        runtimeBorderMetrics = runtimeTheme.extension<AppBorderMetrics>()!,
        shape = runtimeTheme.extension<AppShape>()!,
        roles = runtimeTheme.extension<AppTypeRoles>()!,
        styles = AppTextStyles(runtimeTheme),
        desktop =
            MediaQuery.sizeOf(context).width >
            runtimeResponsive.mobileToDesktopWidth;
    maxWidth = runtimeDialogMetrics.maxWidth;
    gap = runtimeSpacing.space16;
    actionGap = runtimeSpacing.space8;
    borderWidth = desktop
        ? runtimeBorderMetrics.hairline
        : runtimeSpacing.space0;
    borderColor = runtimeTheme.colorScheme.outlineVariant;
    border = desktop
        ? Border.all(color: borderColor, width: borderWidth)
        : null;
    background = runtimeTheme.colorScheme.surface;
    radius = desktop ? shape.surface : shape.panel;
    padding = EdgeInsets.all(
      desktop
          ? runtimeDialogMetrics.desktopInset + runtimeBorderMetrics.hairline
          : runtimeSpacing.space24,
    );
    shadows = desktop ? [runtimeTheme.extension<AppElevation>()!.dialog] : [];
    stretch = runtimeTheme.extension<AppFieldMetrics>()!.stretch;
    titleStyle = roles.interfaceStyle(
      runtimeTheme.textTheme.bodyMedium!.copyWith(
        fontSize: desktop
            ? runtimeDialogMetrics.desktopTitleSize
            : runtimeTheme.textTheme.bodyMedium!.fontSize,
        fontWeight: runtimeTheme.textTheme.labelLarge!.fontWeight,
        height: desktop
            ? runtimeDialogMetrics.desktopTitleLine
            : runtimeDialogMetrics.mobileTitleLine,
        color: runtimeTheme.colorScheme.onSurface,
      ),
    );
    bodyStyle = roles.interfaceStyle(
      styles.label.copyWith(
        fontWeight: runtimeControlMetrics.regularWeight,
        color: runtimeTheme.colorScheme.onSurfaceVariant,
      ),
    );
  }
  late final double maxWidth, gap, actionGap, borderWidth;
  late final Color borderColor, background;
  late final Border? border;
  late final BorderRadius radius;
  late final EdgeInsets padding;
  late final List<BoxShadow> shadows;
  late final CrossAxisAlignment stretch;
  late final TextStyle titleStyle, bodyStyle;
}
