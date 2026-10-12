import 'package:tournament_app/presentation/design_system/foundation/colors/color_primitives.dart';

/// Semantic palette: const-ссылки на primitive токены, без lookup/discriminators.
class AppColors {
  const AppColors.dark();
  final background = ColorPrimitives.graphite900;
  final surface = ColorPrimitives.graphite800;
  final surfaceRaised = ColorPrimitives.graphite700;
  final border = ColorPrimitives.graphite600;
  final borderStrong = ColorPrimitives.graphite500;
  final textPrimary = ColorPrimitives.graphite50;
  final textSecondary = ColorPrimitives.graphite300;
  final textMuted = ColorPrimitives.graphite400;
  final disabledSurface = ColorPrimitives.graphite700;
  final disabledContent = ColorPrimitives.graphite500;
  final accent = ColorPrimitives.gold400;
  final accentHovered = ColorPrimitives.gold300;
  final accentPressed = ColorPrimitives.gold500;
  final focus = ColorPrimitives.gold200;
  final onAccent = ColorPrimitives.gold950;
  final accentContainer = ColorPrimitives.gold900;
  final onAccentContainer = ColorPrimitives.gold100;
  final success = ColorPrimitives.green300;
  final successContainer = ColorPrimitives.green900;
  final onSuccessContainer = ColorPrimitives.green100;
  final warning = ColorPrimitives.amber300;
  final warningContainer = ColorPrimitives.amber900;
  final onWarningContainer = ColorPrimitives.amber100;
  final danger = ColorPrimitives.red300;
  final dangerContainer = ColorPrimitives.red900;
  final onDangerContainer = ColorPrimitives.red100;
  final information = ColorPrimitives.blue300;
  final informationContainer = ColorPrimitives.blue900;
  final onInformationContainer = ColorPrimitives.blue100;
}
