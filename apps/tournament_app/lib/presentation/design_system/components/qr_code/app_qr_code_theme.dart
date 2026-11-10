import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_qr_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_field_metrics.dart';

class AppQrCodeTheme {
  AppQrCodeTheme.of(BuildContext context) {
    final runtimeTheme = Theme.of(context),
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeQrMetrics = runtimeTheme.extension<AppQrMetrics>()!,
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        roles = runtimeTheme.extension<AppTypeRoles>()!;
    moduleRadius = runtimeQrMetrics.moduleRadius;
    finderOuterRadius = runtimeQrMetrics.finderOuterRadius;
    finderGapRadius = runtimeQrMetrics.finderGapRadius;
    finderCenterRadius = runtimeQrMetrics.finderCenterRadius;
    quietZone = runtimeQrMetrics.quietZone;
    extent =
        MediaQuery.sizeOf(context).width >
            runtimeResponsive.mobileToDesktopWidth
        ? runtimeQrMetrics.desktopExtent
        : runtimeQrMetrics.mobileExtent;
    squareRadius = Radius.circular(runtimeSpacing.space0);
    aspectRatio = runtimeQrMetrics.aspectRatio;
    codeFit = runtimeQrMetrics.codeFit;
    blendMode = runtimeQrMetrics.blendMode;
    background = runtimeTheme.colorScheme.onSurface;
    foreground = runtimeTheme.scaffoldBackgroundColor;
    radius = runtimeTheme.extension<AppShape>()!.panel;
    codeStyle = roles.score.copyWith(
      fontSize: runtimeTheme.textTheme.titleLarge!.fontSize,
      height: runtimeQrMetrics.codeLine,
      color: foreground,
    );
    codePadding = EdgeInsets.only(
      left: runtimeSpacing.space16,
      right: runtimeSpacing.space16,
      bottom: runtimeSpacing.space24,
    );
    stretch = runtimeTheme.extension<AppFieldMetrics>()!.stretch;
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
