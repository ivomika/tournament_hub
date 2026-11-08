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
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        r = t.extension<AppResponsive>()!,
        m = t.extension<AppDialogMetrics>()!,
        c = t.extension<AppControlMetrics>()!,
        b = t.extension<AppBorderMetrics>()!,
        shape = t.extension<AppShape>()!,
        roles = t.extension<AppTypeRoles>()!,
        styles = AppTextStyles(t),
        desktop = MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth;
    maxWidth = m.maxWidth;
    gap = s.space16;
    actionGap = s.space8;
    borderWidth = desktop ? b.hairline : s.space0;
    borderColor = t.colorScheme.outlineVariant;
    border = desktop
        ? Border.all(color: borderColor, width: borderWidth)
        : null;
    background = t.colorScheme.surface;
    radius = desktop ? shape.surface : shape.panel;
    padding = EdgeInsets.all(desktop ? m.desktopInset + b.hairline : s.space24);
    shadows = desktop ? [t.extension<AppElevation>()!.dialog] : [];
    stretch = t.extension<AppFieldMetrics>()!.stretch;
    titleStyle = roles.interfaceStyle(
      t.textTheme.bodyMedium!.copyWith(
        fontSize: desktop
            ? m.desktopTitleSize
            : t.textTheme.bodyMedium!.fontSize,
        fontWeight: t.textTheme.labelLarge!.fontWeight,
        height: desktop ? m.desktopTitleLine : m.mobileTitleLine,
        color: t.colorScheme.onSurface,
      ),
    );
    bodyStyle = roles.interfaceStyle(
      styles.label.copyWith(
        fontWeight: c.regularWeight,
        color: t.colorScheme.onSurfaceVariant,
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
