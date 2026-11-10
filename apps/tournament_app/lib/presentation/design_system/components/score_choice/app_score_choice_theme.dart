import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';

class AppScoreChoiceTheme {
  AppScoreChoiceTheme.of(BuildContext context) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeBorderMetrics = runtimeTheme.extension<AppBorderMetrics>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!;
    background = runtimeTheme.colorScheme.surfaceContainerHigh;
    selected = runtimeTheme.colorScheme.primary;
    foreground = runtimeTheme.colorScheme.onSurface;
    disabled = runtimeTheme.disabledColor;
    transparent = runtimeControlMetrics.transparent;
    border = runtimeTheme.colorScheme.outlineVariant;
    radius = runtimeTheme.extension<AppShape>()!.nested;
    height = runtimeTheme.extension<AppResponsive>()!.touchControlHeight;
    gap = runtimeSpacing.space16;
    borderWidth = runtimeBorderMetrics.hairline;
    focusWidth = runtimeBorderMetrics.highContrastFocus;
    focusOffset = runtimeBorderMetrics.focusOffset;
    focusColor = runtimeTheme.focusColor;
    half = runtimeControlMetrics.half;
    zero = runtimeControlMetrics.zero;
    style = runtimeTheme.extension<AppTypeRoles>()!.score.copyWith(
      fontSize: runtimeTheme.textTheme.headlineLarge!.fontSize,
    );
    padding = EdgeInsets.all(runtimeSpacing.space8);
    shape = RoundedRectangleBorder(borderRadius: radius);
    minimumSize = Size(runtimeControlMetrics.zero, height);
  }
  late final Color border;
  late final Color background,
      selected,
      foreground,
      disabled,
      transparent,
      focusColor;
  late final BorderRadius radius;
  late final TextStyle style;
  late final double height,
      gap,
      borderWidth,
      focusWidth,
      focusOffset,
      half,
      zero;
  late final EdgeInsets padding;
  late final OutlinedBorder shape;
  late final Size minimumSize;
}
