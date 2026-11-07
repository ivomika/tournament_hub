import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';

class AppShareLinkTheme {
  AppShareLinkTheme.of(BuildContext context) {
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        r = t.extension<AppResponsive>()!;
    background = MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth
        ? t.scaffoldBackgroundColor
        : t.colorScheme.surface;
    radius = t.extension<AppShape>()!.surface;
    padding = EdgeInsets.all(s.space16);
    gap = s.space8;
    style = AppTextStyles(t).caption.copyWith(color: t.colorScheme.onSurface);
  }
  late final Color background;
  late final BorderRadius radius;
  late final EdgeInsets padding;
  late final double gap;
  late final TextStyle style;
}
