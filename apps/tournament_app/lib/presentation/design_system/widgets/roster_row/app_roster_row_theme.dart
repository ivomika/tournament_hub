import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_roster_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_control_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/motion/app_motion.dart';

class AppRosterRowTheme {
  const AppRosterRowTheme({
    required this.desktop,
    required this.minHeight,
    required this.padding,
    required this.actionInset,
    required this.actionWidth,
    required this.radius,
    required this.zero,
    required this.threshold,
    required this.duration,
    required this.reduced,
    required this.curve,
  });
  factory AppRosterRowTheme.of(BuildContext context) {
    final t = Theme.of(context),
        r = t.extension<AppResponsive>()!,
        s = t.extension<AppSpacing>()!,
        m = t.extension<AppRosterMetrics>()!,
        motion = t.extension<AppMotion>()!,
        c = t.extension<AppControlMetrics>()!,
        shape = t.extension<AppShape>()!;
    final desktop = MediaQuery.sizeOf(context).width > r.mobileToDesktopWidth;
    return AppRosterRowTheme(
      desktop: desktop,
      minHeight: desktop ? m.cardHeight : c.removeHeight,
      padding: desktop
          ? EdgeInsets.all(s.space24)
          : EdgeInsets.symmetric(horizontal: s.space16, vertical: s.space8),
      actionInset: s.space24,
      actionWidth: c.removeWidth,
      radius: desktop ? shape.surface : shape.nested,
      zero: s.space0,
      threshold: m.swipeThreshold,
      duration: MediaQuery.disableAnimationsOf(context)
          ? motion.reduced
          : motion.reveal,
      reduced: motion.reduced,
      curve: motion.curve,
    );
  }
  final bool desktop;
  final double minHeight, actionInset, actionWidth, zero, threshold;
  final EdgeInsets padding;
  final BorderRadius radius;
  final Duration duration, reduced;
  final Curve curve;
}
