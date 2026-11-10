import 'dart:math' as math;

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
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeStepperMetrics = runtimeTheme.extension<AppStepperMetrics>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!;
    final runtimeBorderMetrics = runtimeTheme.extension<AppBorderMetrics>()!;
    focusWidth = runtimeBorderMetrics.highContrastFocus;
    focusOffset = runtimeBorderMetrics.focusOffset;
    focusColor = runtimeTheme.focusColor;
    half = runtimeControlMetrics.half;
    contentHeightFactor =
        runtimeControlMetrics.half + runtimeControlMetrics.half;
    height = runtimeTheme.extension<AppResponsive>()!.touchControlHeight;
    buttonSize = Size.square(height);
    outputWidth = runtimeSpacing.space48;
    inputWidth = runtimeSpacing.space32;
    labelStackWidth = runtimeStepperMetrics.labelStackWidth;
    disabledOpacity = runtimeStepperMetrics.disabledOpacity;
    enabledOpacity = runtimeControlMetrics.half + runtimeControlMetrics.half;
    background = runtimeTheme.colorScheme.surfaceContainerHigh;
    foreground = runtimeTheme.colorScheme.onSurface;
    disabled = runtimeTheme.disabledColor;
    hoverBackground = runtimeTheme.colorScheme.outlineVariant;
    transparent = runtimeControlMetrics.transparent;
    radius = runtimeTheme.extension<AppShape>()!.pill;
    buttonShape = RoundedRectangleBorder(borderRadius: radius);
    padding = EdgeInsets.all(runtimeSpacing.space0);
    smallGap = runtimeSpacing.space8;
    gap = runtimeSpacing.space16;
    fullWidth = runtimeTheme.extension<FoundationLayout>()!.fullWidth;
    labelStyle = AppTextStyles(runtimeTheme).caption
        .copyWith(color: runtimeTheme.colorScheme.onSurfaceVariant);
    valueStyle = AppTextStyles(runtimeTheme).label.copyWith(
      color: foreground,
      fontFeatures: runtimeStepperMetrics.numericFeatures,
    );
    textAlign = runtimeStepperMetrics.valueAlignment;
    center = runtimeStepperMetrics.center;
    start = runtimeTheme.extension<AppFieldMetrics>()!.start;
    spaceBetween = runtimeControlMetrics.spaceBetween;
    singleLine = runtimeTheme.extension<AppFieldMetrics>()!.singleLine;
  }
  double outputExtent(BuildContext context, String value) {
    final painter = TextPainter(
      text: TextSpan(text: value, style: valueStyle),
      textDirection: Directionality.of(context),
      textScaler: MediaQuery.textScalerOf(context),
    )..layout();
    final width = math.max(outputWidth, painter.width.ceilToDouble());
    painter.dispose();
    return width;
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
