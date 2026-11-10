import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';

class AppShareLinkTheme {
  AppShareLinkTheme.of(BuildContext context) {
    final theme = Theme.of(context),
        spacing = theme.extension<AppSpacing>()!,
        responsive = theme.extension<AppResponsive>()!;
    background =
        MediaQuery.sizeOf(context).width > responsive.mobileToDesktopWidth
        ? theme.scaffoldBackgroundColor
        : theme.colorScheme.surface;
    radius = theme.extension<AppShape>()!.surface;
    padding = EdgeInsets.all(spacing.space16);
    gap = spacing.space8;
    style = AppTextStyles(theme).caption
        .copyWith(color: theme.colorScheme.onSurface);
  }
  late final Color background;
  late final BorderRadius radius;
  late final EdgeInsets padding;
  late final double gap;
  late final TextStyle style;
}
