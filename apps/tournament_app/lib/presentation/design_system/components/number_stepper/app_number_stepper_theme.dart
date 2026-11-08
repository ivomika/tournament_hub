import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_stepper_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';

class AppNumberStepperTheme {
  AppNumberStepperTheme.of(BuildContext context) {
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        m = t.extension<AppStepperMetrics>()!,
        c = t.extension<AppControlMetrics>()!;
    final b = t.extension<AppBorderMetrics>()!;
    focusWidth = b.highContrastFocus;
    focusOffset = b.focusOffset;
    focusColor = t.focusColor;
    half = c.half;
    contentHeightFactor = c.half + c.half;
    height = t.extension<AppResponsive>()!.touchControlHeight;
    buttonSize = Size.square(height);
    outputWidth = s.space48;
    inputWidth = s.space32;
    labelStackWidth = m.labelStackWidth;
    disabledOpacity = m.disabledOpacity;
    enabledOpacity = c.half + c.half;
    background = t.colorScheme.surfaceContainerHigh;
    foreground = t.colorScheme.onSurface;
    disabled = t.disabledColor;
    hoverBackground = t.colorScheme.outlineVariant;
    transparent = c.transparent;
    radius = t.extension<AppShape>()!.pill;
    buttonShape = RoundedRectangleBorder(borderRadius: radius);
    padding = EdgeInsets.all(s.space0);
    smallGap = s.space8;
    gap = s.space16;
    fullWidth = t.extension<FoundationLayout>()!.fullWidth;
    labelStyle = AppTextStyles(t).caption
        .copyWith(color: t.colorScheme.onSurfaceVariant);
    valueStyle = AppTextStyles(t).label
        .copyWith(color: foreground, fontFeatures: m.numericFeatures);
    textAlign = m.valueAlignment;
    center = m.center;
    start = t.extension<AppFieldMetrics>()!.start;
    spaceBetween = c.spaceBetween;
    singleLine = t.extension<AppFieldMetrics>()!.singleLine;
  }
  late final double focusWidth, focusOffset, half, contentHeightFactor;
  late final Color focusColor;
  late final double height,
      outputWidth,
      inputWidth,
      labelStackWidth,
      disabledOpacity,
      enabledOpacity,
      smallGap,
      gap,
      fullWidth;
  late final Size buttonSize;
  late final Color background,
      foreground,
      disabled,
      hoverBackground,
      transparent;
  late final BorderRadius radius;
  late final OutlinedBorder buttonShape;
  late final EdgeInsets padding;
  late final TextStyle labelStyle, valueStyle;
  late final TextAlign textAlign;
  late final Alignment center;
  late final CrossAxisAlignment start;
  late final MainAxisAlignment spaceBetween;
  late final int singleLine;
}
