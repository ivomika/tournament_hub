import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_identity_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_metric_metrics.dart';

class AppSectionHeaderTheme {
  AppSectionHeaderTheme.of(BuildContext context) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        desktop =
            MediaQuery.sizeOf(context).width >
            runtimeResponsive.mobileToDesktopWidth;
    slot = desktop
        ? runtimeResponsive.compactControlHeight
        : runtimeResponsive.touchControlHeight;
    gap = runtimeSpacing.space8;
    style =
        (desktop
                ? AppTextStyles(runtimeTheme).comfortableHeader
                : AppTextStyles(runtimeTheme).compactHeader)
            .copyWith(color: runtimeTheme.colorScheme.onSurface);
    textAlign = desktop
        ? runtimeTheme.extension<AppIdentityMetrics>()!.textLeading
        : runtimeTheme.extension<AppMetricMetrics>()!.centerText;
  }
  late final double slot, gap;
  late final TextStyle style;
  late final TextAlign textAlign;
}
