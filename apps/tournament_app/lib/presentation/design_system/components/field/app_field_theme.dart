import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';

enum AppFieldKind { singleLine, multiline }

class AppFieldTheme {
  AppFieldTheme.of(
    BuildContext context,
    AppFieldKind kind,
    bool enabled,
    bool invalid,
  ) {
    final theme = Theme.of(context),
        spacing = theme.extension<AppSpacing>()!,
        borders = theme.extension<AppBorderMetrics>()!,
        responsive = theme.extension<AppResponsive>()!,
        fieldMetrics = theme.extension<AppFieldMetrics>()!,
        controlMetrics = theme.extension<AppControlMetrics>()!,
        styles = AppTextStyles(theme);
    final multiline = kind == AppFieldKind.multiline;
    if (!multiline) {
      minHeight = responsive.touchControlHeight;
    } else if (MediaQuery.sizeOf(context).width >
        responsive.mobileToDesktopWidth) {
      minHeight = fieldMetrics.desktopMessageHeight;
    } else {
      minHeight = fieldMetrics.mobileMessageHeight;
    }
    radius = theme.extension<AppShape>()!.surface;
    background = enabled
        ? theme.colorScheme.surface
        : theme.colorScheme.surfaceContainerHigh;
    border = invalid && kind == AppFieldKind.singleLine
        ? theme.colorScheme.error
        : theme.colorScheme.outlineVariant;
    foreground = enabled ? theme.colorScheme.onSurface : theme.disabledColor;
    labelStyle = styles.caption.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    inputStyle = theme.extension<AppTypeRoles>()!.interfaceStyle(
      (multiline ? theme.textTheme.labelLarge! : theme.textTheme.bodyMedium!)
          .copyWith(
            color: foreground,
            fontWeight: multiline
                ? controlMetrics.regularWeight
                : theme.textTheme.bodyMedium!.fontWeight,
          ),
    );
    errorStyle = styles.caption.copyWith(color: theme.colorScheme.error);
    padding = multiline
        ? EdgeInsets.all(spacing.space16 + borders.hairline)
        : EdgeInsets.symmetric(horizontal: spacing.space24 + borders.hairline);
    borderWidth = borders.hairline;
    gap = spacing.space8;
    zero = spacing.space0;
    focusWidth = borders.highContrastFocus;
    focusOffset = borders.focusOffset;
    half = controlMetrics.half;
    focusColor = theme.focusColor;
    errorColor = theme.colorScheme.error;
    align = multiline ? controlMetrics.topLeft : fieldMetrics.centerLeft;
    crossAxis = fieldMetrics.stretch;
    supportingCrossAxis = fieldMetrics.start;
    singleLine = fieldMetrics.singleLine;
  }
  late final double minHeight,
      borderWidth,
      gap,
      zero,
      focusWidth,
      focusOffset,
      half;
  late final BorderRadius radius;
  late final Color background, border, foreground, focusColor, errorColor;
  late final TextStyle labelStyle, inputStyle, errorStyle;
  late final EdgeInsets padding;
  late final Alignment align;
  late final CrossAxisAlignment crossAxis, supportingCrossAxis;
  late final int singleLine;
}
