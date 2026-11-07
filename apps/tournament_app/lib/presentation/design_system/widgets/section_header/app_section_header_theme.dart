import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_identity_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_metric_metrics.dart';

class AppSectionHeaderTheme {
  AppSectionHeaderTheme.of(BuildContext context) {
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        r = t.extension<AppResponsive>()!,
        desktop = MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth;
    slot = desktop ? r.compactControlHeight : r.touchControlHeight;
    gap = s.space8;
    style =
        (desktop
                ? AppTextStyles(t).comfortableHeader
                : AppTextStyles(t).compactHeader)
            .copyWith(color: t.colorScheme.onSurface);
    textAlign = desktop
        ? t.extension<AppIdentityMetrics>()!.textLeading
        : t.extension<AppMetricMetrics>()!.centerText;
  }
  late final double slot, gap;
  late final TextStyle style;
  late final TextAlign textAlign;
}
