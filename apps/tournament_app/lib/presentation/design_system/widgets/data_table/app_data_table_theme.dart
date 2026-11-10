import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_table_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_identity_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_select_metrics.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_theme.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';

class AppDataTableTheme {
  AppDataTableTheme.of(BuildContext context) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        runtimeIdentityMetrics = runtimeTheme.extension<AppIdentityMetrics>()!,
        runtimeFieldMetrics = runtimeTheme.extension<AppFieldMetrics>()!,
        roles = runtimeTheme.extension<AppTypeRoles>()!,
        styles = AppTextStyles(runtimeTheme);
    desktop =
        MediaQuery.sizeOf(context).width >
        runtimeResponsive.mobileToDesktopWidth;
    captionStyle = styles.caption.copyWith(
      color: runtimeTheme.colorScheme.onSurfaceVariant,
    );
    headerStyle = captionStyle;
    cellStyle = styles.label.copyWith(
      color: runtimeTheme.colorScheme.onSurface,
    );
    padding = EdgeInsets.symmetric(
      vertical: desktop ? runtimeSpacing.space16 : runtimeSpacing.space8,
      horizontal: desktop ? runtimeSpacing.space8 : runtimeSpacing.space0,
    );
    captionGap = runtimeSpacing.space16;
    minNumericWidth = runtimeSpacing.space32;
    identityGap = runtimeSpacing.space8;
    zero = runtimeControlMetrics.zero;
    fullWidth = runtimeTheme.extension<FoundationLayout>()!.fullWidth;
    start = runtimeFieldMetrics.start;
    stretch = runtimeFieldMetrics.stretch;
    leading = runtimeIdentityMetrics.textLeading;
    trailing = runtimeTheme.extension<AppTableMetrics>()!.trailing;
    verticalAlignment = runtimeTheme
        .extension<AppTableMetrics>()!
        .verticalAlignment;
    final primary = roles.interfaceStyle(
      runtimeTheme.textTheme.labelLarge!.copyWith(
        height: runtimeTheme.extension<AppSelectMetrics>()!.sheetTitleLine,
        color: runtimeTheme.colorScheme.onSurface,
      ),
    );
    final secondary = roles.interfaceStyle(
      runtimeTheme.textTheme.bodySmall!.copyWith(
        fontWeight: runtimeTheme.extension<AppSelectMetrics>()!.selectedWeight,
        color: runtimeTheme.colorScheme.onSurfaceVariant,
      ),
    );
    final avatar = AppAvatarTheme.of(
      context,
      AppAvatarSize.small,
      AppAvatarShape.tile,
    );
    identity = AppIdentityTheme(
      avatar: avatar,
      size: AppAvatarSize.small,
      shape: AppAvatarShape.tile,
      primary: primary,
      secondary: secondary,
      gap: runtimeSpacing.space8,
      textGap: runtimeSpacing.space4,
      leading: runtimeIdentityMetrics.leading,
      stretch: runtimeIdentityMetrics.stretch,
      center: runtimeControlMetrics.centerCross,
      textAlign: runtimeIdentityMetrics.textLeading,
    );
  }
  late final bool desktop;
  late final TableCellVerticalAlignment verticalAlignment;
  late final TextStyle captionStyle, headerStyle, cellStyle;
  late final EdgeInsets padding;
  late final double captionGap, minNumericWidth, identityGap, zero, fullWidth;
  late final CrossAxisAlignment start, stretch;
  late final TextAlign leading, trailing;
  late final AppIdentityTheme identity;
}
