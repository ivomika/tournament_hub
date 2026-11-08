import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_qr_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';

class AppQrCodeTheme {
  AppQrCodeTheme.of(BuildContext context) {
    final t = Theme.of(context),
        s = t.extension<AppSpacing>()!,
        m = t.extension<AppQrMetrics>()!,
        r = t.extension<AppResponsive>()!,
        roles = t.extension<AppTypeRoles>()!;
    moduleRadius = m.moduleRadius;
    finderOuterRadius = m.finderOuterRadius;
    finderGapRadius = m.finderGapRadius;
    finderCenterRadius = m.finderCenterRadius;
    quietZone = m.quietZone;
    extent = MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth
        ? m.desktopExtent
        : m.mobileExtent;
    squareRadius = Radius.circular(s.space0);
    aspectRatio = m.aspectRatio;
    codeFit = m.codeFit;
    blendMode = m.blendMode;
    background = t.colorScheme.onSurface;
    foreground = t.scaffoldBackgroundColor;
    radius = t.extension<AppShape>()!.panel;
    codeStyle = roles.score.copyWith(
      fontSize: t.textTheme.titleLarge!.fontSize,
      height: m.codeLine,
      color: foreground,
    );
    codePadding = EdgeInsets.only(
      left: s.space16,
      right: s.space16,
      bottom: s.space24,
    );
    stretch = t.extension<AppFieldMetrics>()!.stretch;
  }
  late final double moduleRadius,
      finderOuterRadius,
      finderGapRadius,
      finderCenterRadius,
      quietZone;
  late final double extent, aspectRatio;
  late final BoxFit codeFit;
  late final BlendMode blendMode;
  late final Color background, foreground;
  late final BorderRadius radius;
  late final Radius squareRadius;
  late final TextStyle codeStyle;
  late final EdgeInsets codePadding;
  late final CrossAxisAlignment stretch;
}
