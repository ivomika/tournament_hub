import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';

class BootstrapScreenTheme extends AppScreenLayoutTheme {
  BootstrapScreenTheme.of(BuildContext context) : super.of(context) {
    final runtimeScreenMetrics = Theme.of(context)
        .extension<AppScreenMetrics>()!;
    centerLeft = Alignment(topLeft.x, centerAlign.y);
    top = runtimeScreenMetrics.bootTop - inset.top;
    final runtimeSpacing = Theme.of(context).extension<AppSpacing>()!;
    error = Theme.of(context).colorScheme.error;
    errorSize = runtimeSpacing.space32;
    markWidth = runtimeSpacing.space48;
    markHeight = runtimeSpacing.space4;
    blockHeight = runtimeScreenMetrics.bootBrandHeight;
    cueHeight = runtimeScreenMetrics.bootCueHeight;
    blockGap = runtimeScreenMetrics.bootGap;
    logo = hero.copyWith(fontSize: runtimeScreenMetrics.bootFont);
    accentLogo = logo.copyWith(color: accentHero.color);
  }
  late final Alignment centerLeft;
  late final Color error;
  late final double errorSize,
      markWidth,
      markHeight,
      top,
      cueHeight,
      blockHeight,
      blockGap;
  late final TextStyle logo, accentLogo;
}
