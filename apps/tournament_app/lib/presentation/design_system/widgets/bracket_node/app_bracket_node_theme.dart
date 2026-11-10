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
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeBracketMetrics = runtimeTheme.extension<AppBracketMetrics>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!,
        runtimeBorderMetrics = runtimeTheme.extension<AppBorderMetrics>()!,
        roles = runtimeTheme.extension<AppTypeRoles>()!,
        styles = AppTextStyles(runtimeTheme),
        im = runtimeTheme.extension<AppIdentityMetrics>()!,
        sm = runtimeTheme.extension<AppSelectMetrics>()!;
    width = runtimeBracketMetrics.width;
    minHeight = runtimeBracketMetrics.minHeight;
    gap = runtimeSpacing.space8;
    zero = runtimeControlMetrics.zero;
    borderWidth = state == AppBracketState.current
        ? runtimeBorderMetrics.emphasis
        : runtimeBorderMetrics.hairline;
    borderColor = state == AppBracketState.current
        ? runtimeTheme.colorScheme.primary
        : runtimeTheme.colorScheme.outlineVariant;
    background = runtimeTheme.colorScheme.surface;
    radius = runtimeTheme.extension<AppShape>()!.nested;
    padding = EdgeInsets.all(runtimeSpacing.space12 + borderWidth);
    buttonPadding = EdgeInsets.all(zero);
    start = runtimeTheme.extension<AppFieldMetrics>()!.stretch;
    labelStyle = roles.interfaceStyle(
      styles.caption.copyWith(
        fontSize: runtimeBracketMetrics.labelSize,
        height: sm.sheetTitleLine,
        fontWeight: sm.optionWeight,
        color: state == AppBracketState.current
            ? runtimeTheme.colorScheme.primary
            : runtimeTheme.disabledColor,
      ),
    );
    unknownStyle = roles.interfaceStyle(
      styles.caption.copyWith(
        fontSize: runtimeBracketMetrics.unknownSize,
        color: runtimeTheme.colorScheme.onSurfaceVariant,
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
      foreground: runtimeTheme.colorScheme.primary,
      typography: roles.interfaceStyle(
        runtimeTheme.textTheme.labelLarge!.copyWith(
          fontSize: runtimeBracketMetrics.smallSize,
          height: roles.score.height,
          fontWeight: sm.selectedWeight,
          color: runtimeTheme.colorScheme.primary,
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
          color: runtimeTheme.colorScheme.onSurface,
        ),
      ),
      secondary: roles.interfaceStyle(
        styles.caption.copyWith(
          fontSize: runtimeBracketMetrics.smallSize,
          color: runtimeTheme.colorScheme.onSurfaceVariant,
        ),
      ),
      gap: runtimeSpacing.space8,
      textGap: runtimeSpacing.space0,
      leading: im.leading,
      stretch: im.stretch,
      center: runtimeControlMetrics.centerCross,
      textAlign: im.textLeading,
    );
    placeholderHeight = source.extent;
    shape = RoundedRectangleBorder(borderRadius: radius);
    transparent = runtimeControlMetrics.transparent;
    minimumSize = Size(zero, zero);
    center = runtimeControlMetrics.centerCross;
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
