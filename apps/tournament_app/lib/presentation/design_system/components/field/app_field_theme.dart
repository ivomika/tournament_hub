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
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        b = t.extension<AppBorderMetrics>()!,
        r = t.extension<AppResponsive>()!,
        m = t.extension<AppFieldMetrics>()!,
        c = t.extension<AppControlMetrics>()!,
        styles = AppTextStyles(t);
    final multiline = kind == AppFieldKind.multiline;
    minHeight = multiline
        ? (MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth
              ? m.desktopMessageHeight
              : m.mobileMessageHeight)
        : r.touchControlHeight;
    radius = t.extension<AppShape>()!.surface;
    background = enabled
        ? t.colorScheme.surface
        : t.colorScheme.surfaceContainerHigh;
    border = invalid && kind == AppFieldKind.singleLine
        ? t.colorScheme.error
        : t.colorScheme.outlineVariant;
    foreground = enabled ? t.colorScheme.onSurface : t.disabledColor;
    labelStyle = styles.caption.copyWith(color: t.colorScheme.onSurfaceVariant);
    inputStyle = t.extension<AppTypeRoles>()!.interfaceStyle(
      (multiline ? t.textTheme.labelLarge! : t.textTheme.bodyMedium!).copyWith(
        color: foreground,
        fontWeight: multiline
            ? c.regularWeight
            : t.textTheme.bodyMedium!.fontWeight,
      ),
    );
    errorStyle = styles.caption.copyWith(color: t.colorScheme.error);
    padding = multiline
        ? EdgeInsets.all(s.space16 + b.hairline)
        : EdgeInsets.symmetric(horizontal: s.space24 + b.hairline);
    borderWidth = b.hairline;
    gap = s.space8;
    zero = s.space0;
    focusWidth = b.highContrastFocus;
    focusOffset = b.focusOffset;
    half = c.half;
    focusColor = t.focusColor;
    errorColor = t.colorScheme.error;
    align = multiline ? c.topLeft : m.centerLeft;
    crossAxis = m.stretch;
    supportingCrossAxis = m.start;
    singleLine = m.singleLine;
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
