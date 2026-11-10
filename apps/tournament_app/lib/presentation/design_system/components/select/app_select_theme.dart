import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_select_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';

class AppSelectTheme {
  AppSelectTheme.of(BuildContext context, bool enabled) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeSelectMetrics = runtimeTheme.extension<AppSelectMetrics>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        runtimeBorderMetrics = runtimeTheme.extension<AppBorderMetrics>()!,
        shape = runtimeTheme.extension<AppShape>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!,
        runtimeFieldMetrics = runtimeTheme.extension<AppFieldMetrics>()!,
        styles = AppTextStyles(runtimeTheme),
        roles = runtimeTheme.extension<AppTypeRoles>()!;
    desktop =
        MediaQuery.sizeOf(context).width >
        runtimeResponsive.mobileToDesktopWidth;
    zero = runtimeSpacing.space0;
    half = runtimeControlMetrics.half;
    color = enabled
        ? runtimeTheme.colorScheme.onSurface
        : runtimeTheme.disabledColor;
    background = runtimeTheme.colorScheme.surfaceContainerHigh;
    surface = runtimeTheme.colorScheme.surface;
    border = runtimeTheme.colorScheme.outlineVariant;
    accent = runtimeTheme.colorScheme.primary;
    transparent = runtimeControlMetrics.transparent;
    focusColor = runtimeTheme.focusColor;
    labelStyle = styles.caption.copyWith(
      color: runtimeTheme.colorScheme.onSurfaceVariant,
    );
    mobileLabel = roles.interfaceStyle(
      runtimeTheme.textTheme.labelLarge!.copyWith(
        fontWeight: runtimeControlMetrics.regularWeight,
        color: color,
      ),
    );
    selectedStyle = roles.interfaceStyle(
      mobileLabel.copyWith(fontWeight: runtimeSelectMetrics.selectedWeight),
    );
    desktopStyle = roles.interfaceStyle(
      runtimeTheme.textTheme.bodyMedium!.copyWith(
        fontWeight: runtimeSelectMetrics.optionWeight,
        height: runtimeSelectMetrics.desktopLine,
        color: color,
      ),
    );
    titleStyle = roles.interfaceStyle(
      runtimeTheme.textTheme.titleLarge!.copyWith(
        fontSize: runtimeSelectMetrics.sheetTitleSize,
        height: runtimeSelectMetrics.sheetTitleLine,
        letterSpacing: roles.normalTracking,
      ),
    );
    optionStyle = roles.interfaceStyle(
      runtimeTheme.textTheme.labelLarge!.copyWith(
        fontWeight: runtimeSelectMetrics.optionWeight,
        color: color,
      ),
    );
    descriptionStyle = styles.caption.copyWith(
      color: runtimeTheme.colorScheme.onSurfaceVariant,
    );
    gap = runtimeSpacing.space8;
    sectionGap = runtimeSpacing.space24;
    headerGap = runtimeSpacing.space16;
    handleGap = runtimeSpacing.space20;
    descriptionTop = runtimeSpacing.space12;
    height = desktop
        ? runtimeResponsive.touchControlHeight
        : runtimeResponsive.compactControlHeight;
    padding = desktop
        ? EdgeInsets.only(
            left: runtimeSpacing.space20 + runtimeBorderMetrics.hairline,
            right: runtimeSpacing.space16,
          )
        : EdgeInsets.all(zero);
    radius = desktop
        ? shape.nested
        : BorderRadius.circular(runtimeSpacing.space0);
    borderWidth = desktop ? runtimeBorderMetrics.hairline : zero;
    focusWidth = runtimeBorderMetrics.highContrastFocus;
    focusOffset = runtimeBorderMetrics.focusOffset;
    sheetRadius = shape.sheet;
    sheetPadding = EdgeInsets.fromLTRB(
      runtimeSpacing.space24 + runtimeBorderMetrics.hairline,
      runtimeSpacing.space12 + runtimeBorderMetrics.hairline,
      runtimeSpacing.space24 + runtimeBorderMetrics.hairline,
      runtimeSelectMetrics.sheetBottom + MediaQuery.paddingOf(context).bottom,
    );
    sheetBorder = runtimeBorderMetrics.hairline;
    sheetMaxWidth = runtimeSelectMetrics.sheetMaxWidth;
    closeExtent = runtimeSelectMetrics.closeExtent;
    handleWidth = runtimeSelectMetrics.handleWidth;
    handleHeight = runtimeSelectMetrics.handleHeight;
    handleRadius = shape.pill;
    optionPadding = EdgeInsets.all(
      runtimeSpacing.space16 + runtimeBorderMetrics.hairline,
    );
    optionRadius = shape.nested;
    optionMinHeight = runtimeResponsive.touchControlHeight;
    chevronTurns = runtimeSelectMetrics.chevronTurns;
    stretch = runtimeFieldMetrics.stretch;
    start = runtimeFieldMetrics.start;
    center = runtimeControlMetrics.centerCross;
    spaceBetween = runtimeControlMetrics.spaceBetween;
  }
  late final bool desktop;
  late final int chevronTurns;
  late final double zero,
      half,
      gap,
      sectionGap,
      headerGap,
      handleGap,
      descriptionTop,
      height,
      borderWidth,
      focusWidth,
      focusOffset,
      sheetBorder,
      sheetMaxWidth,
      closeExtent,
      handleWidth,
      handleHeight,
      optionMinHeight;
  late final Color color,
      background,
      surface,
      border,
      accent,
      transparent,
      focusColor;
  late final TextStyle labelStyle,
      mobileLabel,
      selectedStyle,
      desktopStyle,
      titleStyle,
      optionStyle,
      descriptionStyle;
  late final EdgeInsets padding, sheetPadding, optionPadding;
  late final BorderRadius radius, sheetRadius, handleRadius, optionRadius;
  late final CrossAxisAlignment stretch, start, center;
  late final MainAxisAlignment spaceBetween;
}
