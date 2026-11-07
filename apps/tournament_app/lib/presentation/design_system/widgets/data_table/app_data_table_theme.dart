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
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        c = t.extension<AppControlMetrics>()!,
        r = t.extension<AppResponsive>()!,
        m = t.extension<AppIdentityMetrics>()!,
        f = t.extension<AppFieldMetrics>()!,
        roles = t.extension<AppTypeRoles>()!,
        styles = AppTextStyles(t);
    desktop = MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth;
    captionStyle = styles.caption.copyWith(
      color: t.colorScheme.onSurfaceVariant,
    );
    headerStyle = captionStyle;
    cellStyle = styles.label.copyWith(color: t.colorScheme.onSurface);
    padding = EdgeInsets.symmetric(
      vertical: desktop ? s.space16 : s.space8,
      horizontal: desktop ? s.space8 : s.space0,
    );
    captionGap = s.space16;
    minNumericWidth = s.space32;
    identityGap = s.space8;
    zero = c.zero;
    fullWidth = t.extension<FoundationLayout>()!.fullWidth;
    start = f.start;
    stretch = f.stretch;
    leading = m.textLeading;
    trailing = t.extension<AppTableMetrics>()!.trailing;
    verticalAlignment = t.extension<AppTableMetrics>()!.verticalAlignment;
    final primary = roles.interfaceStyle(
      t.textTheme.labelLarge!.copyWith(
        height: t.extension<AppSelectMetrics>()!.sheetTitleLine,
        color: t.colorScheme.onSurface,
      ),
    );
    final secondary = roles.interfaceStyle(
      t.textTheme.bodySmall!.copyWith(
        fontWeight: t.extension<AppSelectMetrics>()!.selectedWeight,
        color: t.colorScheme.onSurfaceVariant,
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
      gap: s.space8,
      textGap: s.space4,
      leading: m.leading,
      stretch: m.stretch,
      center: c.centerCross,
      textAlign: m.textLeading,
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
