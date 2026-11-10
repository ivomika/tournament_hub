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
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!,
        runtimeBorderMetrics = runtimeTheme.extension<AppBorderMetrics>()!,
        styles = AppTextStyles(runtimeTheme);
    final desktop =
        MediaQuery.sizeOf(context).width >
        runtimeResponsive.mobileToDesktopWidth;
    titleStyle = runtimeTheme.extension<AppTypeRoles>()!.interfaceStyle(
      styles.compactHeader.copyWith(
        fontWeight: runtimeTheme.extension<AppSelectMetrics>()!.optionWeight,
        color: runtimeTheme.colorScheme.onSurfaceVariant,
      ),
    );
    bodyStyle = styles.caption.copyWith(
      color: runtimeTheme.colorScheme.onSurfaceVariant,
    );
    padding = EdgeInsets.symmetric(
      horizontal: desktop ? runtimeSpacing.space4 : runtimeSpacing.space0,
    );
    bodyPadding = EdgeInsets.only(
      top: runtimeSpacing.space8,
      bottom: runtimeSpacing.space16,
    );
    buttonPadding = EdgeInsets.all(runtimeSpacing.space0);
    minSize = Size(runtimeSpacing.space0, runtimeResponsive.touchControlHeight);
    gap = runtimeSpacing.space16;
    turns = runtimeTheme.extension<AppSelectMetrics>()!.chevronTurns;
    stretch = runtimeTheme.extension<AppFieldMetrics>()!.stretch;
    transparent = runtimeControlMetrics.transparent;
    focusWidth = runtimeBorderMetrics.highContrastFocus;
    focusOffset = runtimeSpacing.space4 * runtimeControlMetrics.half;
    focusColor = runtimeTheme.focusColor;
    radius = runtimeTheme.extension<AppShape>()!.avatarTile;
    half = runtimeControlMetrics.half;
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
