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
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        m = t.extension<AppSelectMetrics>()!,
        r = t.extension<AppResponsive>()!,
        b = t.extension<AppBorderMetrics>()!,
        shape = t.extension<AppShape>()!,
        c = t.extension<AppControlMetrics>()!,
        f = t.extension<AppFieldMetrics>()!,
        styles = AppTextStyles(t),
        roles = t.extension<AppTypeRoles>()!;
    desktop = MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth;
    zero = s.space0;
    half = c.half;
    color = enabled ? t.colorScheme.onSurface : t.disabledColor;
    background = t.colorScheme.surfaceContainerHigh;
    surface = t.colorScheme.surface;
    border = t.colorScheme.outlineVariant;
    accent = t.colorScheme.primary;
    transparent = c.transparent;
    focusColor = t.focusColor;
    labelStyle = styles.caption.copyWith(color: t.colorScheme.onSurfaceVariant);
    mobileLabel = roles.interfaceStyle(
      t.textTheme.labelLarge!.copyWith(
        fontWeight: c.regularWeight,
        color: color,
      ),
    );
    selectedStyle = roles.interfaceStyle(
      mobileLabel.copyWith(fontWeight: m.selectedWeight),
    );
    desktopStyle = roles.interfaceStyle(
      t.textTheme.bodyMedium!.copyWith(
        fontWeight: m.optionWeight,
        height: m.desktopLine,
        color: color,
      ),
    );
    titleStyle = roles.interfaceStyle(
      t.textTheme.titleLarge!.copyWith(
        fontSize: m.sheetTitleSize,
        height: m.sheetTitleLine,
        letterSpacing: roles.normalTracking,
      ),
    );
    optionStyle = roles.interfaceStyle(
      t.textTheme.labelLarge!.copyWith(
        fontWeight: m.optionWeight,
        color: color,
      ),
    );
    descriptionStyle = styles.caption.copyWith(
      color: t.colorScheme.onSurfaceVariant,
    );
    gap = s.space8;
    sectionGap = s.space24;
    headerGap = s.space16;
    handleGap = s.space20;
    descriptionTop = s.space12;
    height = desktop ? r.touchControlHeight : r.compactControlHeight;
    padding = desktop
        ? EdgeInsets.only(left: s.space20 + b.hairline, right: s.space16)
        : EdgeInsets.all(zero);
    radius = desktop ? shape.nested : BorderRadius.circular(s.space0);
    borderWidth = desktop ? b.hairline : zero;
    focusWidth = b.highContrastFocus;
    focusOffset = b.focusOffset;
    sheetRadius = shape.sheet;
    sheetPadding = EdgeInsets.fromLTRB(
      s.space24 + b.hairline,
      s.space12 + b.hairline,
      s.space24 + b.hairline,
      m.sheetBottom + MediaQuery.paddingOf(context).bottom,
    );
    sheetBorder = b.hairline;
    sheetMaxWidth = m.sheetMaxWidth;
    closeExtent = m.closeExtent;
    handleWidth = m.handleWidth;
    handleHeight = m.handleHeight;
    handleRadius = shape.pill;
    optionPadding = EdgeInsets.all(s.space16 + b.hairline);
    optionRadius = shape.nested;
    optionMinHeight = r.touchControlHeight;
    chevronTurns = m.chevronTurns;
    stretch = f.stretch;
    start = f.start;
    center = c.centerCross;
    spaceBetween = c.spaceBetween;
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
