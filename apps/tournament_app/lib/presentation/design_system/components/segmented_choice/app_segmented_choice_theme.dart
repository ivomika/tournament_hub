import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';

class AppSegmentedChoiceTheme {
  AppSegmentedChoiceTheme.of(BuildContext context, {bool nested = false}) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!,
        runtimeBorderMetrics = runtimeTheme.extension<AppBorderMetrics>()!;
    background = nested
        ? runtimeTheme.scaffoldBackgroundColor
        : runtimeTheme.colorScheme.surface;
    selectedBackground = runtimeTheme.colorScheme.surfaceContainerHigh;
    transparent = runtimeControlMetrics.transparent;
    foreground = runtimeTheme.colorScheme.onSurface;
    secondary = runtimeTheme.colorScheme.onSurfaceVariant;
    disabled = runtimeTheme.disabledColor;
    height = runtimeSpacing.space64;
    gap = runtimeSpacing.space8;
    padding = EdgeInsets.symmetric(horizontal: runtimeSpacing.space8);
    selectedInset = EdgeInsets.symmetric(vertical: runtimeSpacing.space8);
    radius = runtimeTheme.extension<AppShape>()!.pill;
    selectedStyle = runtimeTheme.extension<AppTypeRoles>()!.interfaceStyle(
      runtimeTheme.textTheme.labelLarge!,
    );
    normalStyle = runtimeTheme.extension<AppTypeRoles>()!.interfaceStyle(
      runtimeTheme.textTheme.labelLarge!.copyWith(
        fontWeight: runtimeControlMetrics.regularWeight,
      ),
    );
    stretch = runtimeTheme.extension<AppFieldMetrics>()!.stretch;
    focusWidth = runtimeBorderMetrics.highContrastFocus;
    focusOffset = runtimeBorderMetrics.focusOffset;
    focusColor = runtimeTheme.focusColor;
    half = runtimeControlMetrics.half;
    contentHeightFactor =
        runtimeControlMetrics.half + runtimeControlMetrics.half;
    zero = runtimeControlMetrics.zero;
  }
  late final Color background,
      selectedBackground,
      transparent,
      foreground,
      secondary,
      disabled,
      focusColor;
  late final double height,
      gap,
      focusWidth,
      focusOffset,
      half,
      zero,
      contentHeightFactor;
  late final EdgeInsets padding, selectedInset;
  late final BorderRadius radius;
  late final TextStyle selectedStyle, normalStyle;
  late final CrossAxisAlignment stretch;
}
