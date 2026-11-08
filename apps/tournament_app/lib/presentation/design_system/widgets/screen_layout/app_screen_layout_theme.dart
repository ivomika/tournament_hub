import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';

class AppScreenLayoutTheme {
  AppScreenLayoutTheme.of(BuildContext context) {
    final theme = Theme.of(context),
        s = theme.extension<AppSpacing>()!,
        r = theme.extension<AppResponsive>()!,
        m = theme.extension<AppScreenMetrics>()!;
    start = m.start;
    stretch = m.stretch;
    centerCross = m.centerCross;
    centerMain = m.centerMain;
    startMain = m.startMain;
    spaceBetween = m.spaceBetween;
    centerAlign = m.centerAlign;
    rightAlign = m.rightAlign;
    topLeft = m.topLeft;
    min = m.min;
    max = m.max;
    centerText = m.centerText;
    leftText = m.leftText;
    desktop = MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth;
    inset = EdgeInsets.all(desktop ? s.space32 : s.space24);
    brandInset = EdgeInsets.symmetric(horizontal: s.space32);
    tileInset = EdgeInsets.all(desktop ? s.space32 : s.space0);
    gap = desktop ? s.space24 : s.space24;
    small = s.space16;
    zero = s.space0;
    background = theme.scaffoldBackgroundColor;
    surface = theme.colorScheme.surface;
    raised = theme.colorScheme.surfaceContainerHigh;
    radius = theme.extension<AppShape>()!.surface;
    hero = theme.textTheme.displayLarge!.copyWith(
      fontSize: desktop ? m.desktopHero : m.mobileHero,
      height: m.heroLine,
      letterSpacing: (desktop ? m.desktopHero : m.mobileHero) * m.heroTracking,
    );
    accentHero = hero.copyWith(color: theme.colorScheme.primary);
    heading = theme.textTheme.headlineLarge!;
    title = theme.textTheme.titleLarge!;
    body = theme.textTheme.bodyMedium!;
    muted = body.copyWith(color: theme.colorScheme.onSurfaceVariant);
    caption = theme.textTheme.bodySmall!.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    brand = theme.textTheme.headlineSmall!;
    accentBrand = brand.copyWith(color: theme.colorScheme.primary);
    utilityWidth = m.utilityWidth;
    utilityHeight = m.utilityHeight;
    utilityTop = m.utilityTop;
    utilityReserve = m.utilityReserve;
    utilityAction = m.utilityAction;
    primaryFlex = m.primaryFlex;
    secondaryFlex = m.secondaryFlex;
    brandHeight = m.brandHeight;
    formWidth = m.formWidth;
  }
  late final CrossAxisAlignment start;
  late final CrossAxisAlignment stretch;
  late final CrossAxisAlignment centerCross;
  late final MainAxisAlignment centerMain;
  late final MainAxisAlignment startMain;
  late final MainAxisAlignment spaceBetween;
  late final Alignment centerAlign;
  late final Alignment rightAlign;
  late final Alignment topLeft;
  late final MainAxisSize min;
  late final MainAxisSize max;
  late final TextAlign centerText;
  late final TextAlign leftText;
  late final bool desktop;
  late final EdgeInsets inset, tileInset, brandInset;
  late final double utilityWidth,
      utilityHeight,
      utilityTop,
      utilityReserve,
      utilityAction,
      gap,
      small,
      zero,
      brandHeight,
      formWidth;
  late final Color background, surface, raised;
  late final BorderRadius radius;
  late final TextStyle hero,
      accentHero,
      heading,
      title,
      body,
      muted,
      caption,
      brand,
      accentBrand;
  late final int primaryFlex, secondaryFlex;
}
