import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
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
  factory AppRosterRowTheme.of(
    BuildContext context, {
    required String removeLabel,
  }) {
    final runtimeTheme = Theme.of(context),
        runtimeResponsive = runtimeTheme.extension<AppResponsive>()!,
        runtimeSpacing = runtimeTheme.extension<AppSpacing>()!,
        runtimeRosterMetrics = runtimeTheme.extension<AppRosterMetrics>()!,
        motion = runtimeTheme.extension<AppMotion>()!,
        runtimeControlMetrics = runtimeTheme.extension<AppControlMetrics>()!,
        shape = runtimeTheme.extension<AppShape>()!;
    final desktop =
        MediaQuery.sizeOf(context).width >
        runtimeResponsive.mobileToDesktopWidth;
    return AppRosterRowTheme(
      desktop: desktop,
      minHeight: desktop
          ? runtimeRosterMetrics.cardHeight
          : runtimeControlMetrics.removeHeight,
      padding: desktop
          ? EdgeInsets.all(runtimeSpacing.space24)
          : EdgeInsets.symmetric(
              horizontal: runtimeSpacing.space16,
              vertical: runtimeSpacing.space8,
            ),
      actionInset: runtimeSpacing.space24,
      actionWidth: AppButtonTheme.of(
        context,
        AppButtonKind.removeSwipe,
        {},
        label: removeLabel,
      ).width!,
      radius: desktop ? shape.surface : shape.nested,
      zero: runtimeSpacing.space0,
      threshold: runtimeRosterMetrics.swipeThreshold,
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
