import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';

class AppSegmentedChoiceTheme {
  AppSegmentedChoiceTheme.of(BuildContext context, {bool nested = false}) {
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        c = t.extension<AppControlMetrics>()!,
        b = t.extension<AppBorderMetrics>()!;
    background = nested ? t.scaffoldBackgroundColor : t.colorScheme.surface;
    selectedBackground = t.colorScheme.surfaceContainerHigh;
    transparent = c.transparent;
    foreground = t.colorScheme.onSurface;
    secondary = t.colorScheme.onSurfaceVariant;
    disabled = t.disabledColor;
    height = s.space64;
    gap = s.space8;
    padding = EdgeInsets.symmetric(horizontal: s.space8);
    selectedInset = EdgeInsets.symmetric(vertical: s.space8);
    radius = t.extension<AppShape>()!.pill;
    selectedStyle = t.extension<AppTypeRoles>()!.interfaceStyle(
      t.textTheme.labelLarge!,
    );
    normalStyle = t.extension<AppTypeRoles>()!.interfaceStyle(
      t.textTheme.labelLarge!.copyWith(fontWeight: c.regularWeight),
    );
    stretch = t.extension<AppFieldMetrics>()!.stretch;
    focusWidth = b.highContrastFocus;
    focusOffset = b.focusOffset;
    focusColor = t.focusColor;
    half = c.half;
    contentHeightFactor = c.half + c.half;
    zero = c.zero;
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
