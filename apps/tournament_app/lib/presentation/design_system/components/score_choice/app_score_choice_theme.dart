import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';

class AppScoreChoiceTheme {
  AppScoreChoiceTheme.of(BuildContext context) {
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        b = t.extension<AppBorderMetrics>()!,
        c = t.extension<AppControlMetrics>()!;
    background = t.colorScheme.surfaceContainerHigh;
    selected = t.colorScheme.primary;
    foreground = t.colorScheme.onSurface;
    disabled = t.disabledColor;
    transparent = c.transparent;
    border = t.colorScheme.outlineVariant;
    radius = t.extension<AppShape>()!.nested;
    height = t.extension<AppResponsive>()!.touchControlHeight;
    gap = s.space16;
    borderWidth = b.hairline;
    focusWidth = b.highContrastFocus;
    focusOffset = b.focusOffset;
    focusColor = t.focusColor;
    half = c.half;
    zero = c.zero;
    style = t.extension<AppTypeRoles>()!.score.copyWith(
      fontSize: t.textTheme.headlineLarge!.fontSize,
    );
    padding = EdgeInsets.all(s.space8);
    shape = RoundedRectangleBorder(borderRadius: radius);
    minimumSize = Size(c.zero, height);
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
