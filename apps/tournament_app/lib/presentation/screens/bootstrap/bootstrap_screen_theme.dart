import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_screen_metrics.dart';

class BootstrapScreenTheme extends AppScreenLayoutTheme {
  BootstrapScreenTheme.of(BuildContext context) : super.of(context) {
    final m = Theme.of(context).extension<AppScreenMetrics>()!;
    top = m.bootTop - inset.top;
    final s = Theme.of(context).extension<AppSpacing>()!;
    markWidth = s.space48;
    markHeight = s.space4;
    blockHeight = m.bootBrandHeight;
    cueHeight = m.bootCueHeight;
    blockGap = m.bootGap;
    logo = hero.copyWith(fontSize: m.bootFont);
    accentLogo = logo.copyWith(color: accentHero.color);
  }
  late final double markWidth,
      markHeight,
      top,
      cueHeight,
      blockHeight,
      blockGap;
  late final TextStyle logo, accentLogo;
}
