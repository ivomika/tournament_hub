import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_models.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_bracket_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_select_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_identity_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_theme.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';

class AppBracketNodeTheme {
  AppBracketNodeTheme.of(BuildContext context, AppBracketState state) {
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        m = t.extension<AppBracketMetrics>()!,
        c = t.extension<AppControlMetrics>()!,
        b = t.extension<AppBorderMetrics>()!,
        roles = t.extension<AppTypeRoles>()!,
        styles = AppTextStyles(t),
        im = t.extension<AppIdentityMetrics>()!,
        sm = t.extension<AppSelectMetrics>()!;
    width = m.width;
    minHeight = m.minHeight;
    gap = s.space8;
    zero = c.zero;
    borderWidth = state == AppBracketState.current ? b.emphasis : b.hairline;
    borderColor = state == AppBracketState.current
        ? t.colorScheme.primary
        : t.colorScheme.outlineVariant;
    background = t.colorScheme.surface;
    radius = t.extension<AppShape>()!.nested;
    padding = EdgeInsets.all(s.space12 + borderWidth);
    buttonPadding = EdgeInsets.all(zero);
    start = t.extension<AppFieldMetrics>()!.stretch;
    labelStyle = roles.interfaceStyle(
      styles.caption.copyWith(
        fontSize: m.labelSize,
        height: sm.sheetTitleLine,
        fontWeight: sm.optionWeight,
        color: state == AppBracketState.current
            ? t.colorScheme.primary
            : t.disabledColor,
      ),
    );
    unknownStyle = roles.interfaceStyle(
      styles.caption.copyWith(
        fontSize: m.unknownSize,
        color: t.colorScheme.onSurfaceVariant,
      ),
    );
    final source = AppAvatarTheme.of(
      context,
      AppAvatarSize.extraSmall,
      AppAvatarShape.tile,
    );
    final avatar = AppAvatarTheme(
      extent: source.extent,
      contentAlignment: source.contentAlignment,
      tileRadius: source.tileRadius,
      background: source.background,
      foreground: t.colorScheme.primary,
      typography: roles.interfaceStyle(
        t.textTheme.labelLarge!.copyWith(
          fontSize: m.smallSize,
          height: roles.score.height,
          fontWeight: sm.selectedWeight,
          color: t.colorScheme.primary,
        ),
      ),
    );
    identity = AppIdentityTheme(
      fillText: true,
      exactLineBoxes: true,
      avatar: avatar,
      size: AppAvatarSize.extraSmall,
      shape: AppAvatarShape.tile,
      primary: roles.interfaceStyle(
        styles.caption.copyWith(
          fontWeight: sm.selectedWeight,
          color: t.colorScheme.onSurface,
        ),
      ),
      secondary: roles.interfaceStyle(
        styles.caption.copyWith(
          fontSize: m.smallSize,
          color: t.colorScheme.onSurfaceVariant,
        ),
      ),
      gap: s.space8,
      textGap: s.space0,
      leading: im.leading,
      stretch: im.stretch,
      center: c.centerCross,
      textAlign: im.textLeading,
    );
    placeholderHeight = source.extent;
    shape = RoundedRectangleBorder(borderRadius: radius);
    transparent = c.transparent;
    minimumSize = Size(zero, zero);
    center = c.centerCross;
  }
  late final double width, minHeight, gap, zero, borderWidth, placeholderHeight;
  late final Color borderColor, background, transparent;
  late final BorderRadius radius;
  late final EdgeInsets padding, buttonPadding;
  late final TextStyle labelStyle, unknownStyle;
  late final AppIdentityTheme identity;
  late final CrossAxisAlignment start, center;
  late final OutlinedBorder shape;
  late final Size minimumSize;
}
