import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_select_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';

class AppDisclosureTheme {
  AppDisclosureTheme.of(BuildContext context) {
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        r = t.extension<AppResponsive>()!,
        c = t.extension<AppControlMetrics>()!,
        b = t.extension<AppBorderMetrics>()!,
        styles = AppTextStyles(t);
    final desktop = MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth;
    titleStyle = t.extension<AppTypeRoles>()!.interfaceStyle(
      styles.compactHeader.copyWith(
        fontWeight: t.extension<AppSelectMetrics>()!.optionWeight,
        color: t.colorScheme.onSurfaceVariant,
      ),
    );
    bodyStyle = styles.caption.copyWith(color: t.colorScheme.onSurfaceVariant);
    padding = EdgeInsets.symmetric(horizontal: desktop ? s.space4 : s.space0);
    bodyPadding = EdgeInsets.only(top: s.space8, bottom: s.space16);
    buttonPadding = EdgeInsets.all(s.space0);
    minSize = Size(s.space0, r.touchControlHeight);
    gap = s.space16;
    turns = t.extension<AppSelectMetrics>()!.chevronTurns;
    stretch = t.extension<AppFieldMetrics>()!.stretch;
    transparent = c.transparent;
    focusWidth = b.highContrastFocus;
    focusOffset = s.space4 * c.half;
    focusColor = t.focusColor;
    radius = t.extension<AppShape>()!.avatarTile;
    half = c.half;
  }
  late final TextStyle titleStyle, bodyStyle;
  late final EdgeInsets padding, bodyPadding, buttonPadding;
  late final Size minSize;
  late final double gap, focusWidth, focusOffset, half;
  late final int turns;
  late final CrossAxisAlignment stretch;
  late final Color transparent, focusColor;
  late final BorderRadius radius;
}
