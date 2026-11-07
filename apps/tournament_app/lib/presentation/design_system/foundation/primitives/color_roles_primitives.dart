import 'package:tournament_app/presentation/design_system/foundation/primitives/color_primitives.dart';

/// Semantic palette: const-ссылки на primitive токены, без lookup/discriminators.
abstract final class ColorRolesPrimitives {
  static const background = ColorPrimitives.graphite900;
  static const surface = ColorPrimitives.graphite800;
  static const surfaceRaised = ColorPrimitives.graphite700;
  static const border = ColorPrimitives.graphite600;
  static const borderStrong = ColorPrimitives.graphite500;
  static const textPrimary = ColorPrimitives.graphite50;
  static const textSecondary = ColorPrimitives.graphite300;
  static const textMuted = ColorPrimitives.graphite400;
  static const disabledSurface = ColorPrimitives.graphite700;
  static const disabledContent = ColorPrimitives.graphite400;
  static const accent = ColorPrimitives.gold400;
  static const accentHovered = ColorPrimitives.gold200;
  static const accentPressed = ColorPrimitives.gold500;
  static const focus = ColorPrimitives.gold200;
  static const onAccent = ColorPrimitives.gold950;
  static const accentContainer = ColorPrimitives.gold900;
  static const onAccentContainer = ColorPrimitives.gold100;
  static const success = ColorPrimitives.green300;
  static const successContainer = ColorPrimitives.green900;
  static const onSuccessContainer = ColorPrimitives.green100;
  static const warning = ColorPrimitives.amber300;
  static const warningContainer = ColorPrimitives.amber900;
  static const onWarningContainer = ColorPrimitives.amber100;
  static const danger = ColorPrimitives.red300;
  static const dangerContainer = ColorPrimitives.red900;
  static const onDangerContainer = ColorPrimitives.red100;
  static const information = ColorPrimitives.blue300;
  static const informationContainer = ColorPrimitives.blue900;
  static const onInformationContainer = ColorPrimitives.blue100;
}
