import 'package:flutter/widgets.dart';
import 'package:tournament_app/presentation/design_system/foundation/app_foundation.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/palette/color_palette.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/palette/palette_theme.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/foundation_scenario_host.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:widgetbook/widgetbook.dart';

final colorsUseCase = WidgetbookUseCase(
  name: 'Dark palette',
  builder: buildColorsUseCase,
);

Widget buildColorsUseCase(BuildContext context) {
  return const FoundationScenarioHost(
    child: Builder(builder: buildSemanticPalette),
  );
}

Widget buildSemanticPalette(BuildContext context) {
  final strings = FoundationLocalizations.of(context);
  const foundation = AppFoundation.dark();
  final colors = foundation.colors;
  return ColorPalette(
    theme: const PaletteTheme(foundation),
    title: strings.colorsTitle,
    description: strings.colorsDescription,
    samples: List.unmodifiable([
      (label: strings.background, value: colors.background),
      (label: strings.surface, value: colors.surface),
      (label: strings.surfaceRaised, value: colors.surfaceRaised),
      (label: strings.border, value: colors.border),
      (label: strings.borderStrong, value: colors.borderStrong),
      (label: strings.textPrimary, value: colors.textPrimary),
      (label: strings.textSecondary, value: colors.textSecondary),
      (label: strings.textMuted, value: colors.textMuted),
      (label: strings.disabledSurface, value: colors.disabledSurface),
      (label: strings.disabledContent, value: colors.disabledContent),
      (label: strings.accent, value: colors.accent),
      (label: strings.accentHovered, value: colors.accentHovered),
      (label: strings.accentPressed, value: colors.accentPressed),
      (label: strings.focus, value: colors.focus),
      (label: strings.onAccent, value: colors.onAccent),
      (label: strings.accentContainer, value: colors.accentContainer),
      (label: strings.onAccentContainer, value: colors.onAccentContainer),
      (label: strings.success, value: colors.success),
      (label: strings.successContainer, value: colors.successContainer),
      (label: strings.onSuccessContainer, value: colors.onSuccessContainer),
      (label: strings.warning, value: colors.warning),
      (label: strings.warningContainer, value: colors.warningContainer),
      (label: strings.onWarningContainer, value: colors.onWarningContainer),
      (label: strings.danger, value: colors.danger),
      (label: strings.dangerContainer, value: colors.dangerContainer),
      (label: strings.onDangerContainer, value: colors.onDangerContainer),
      (label: strings.information, value: colors.information),
      (label: strings.informationContainer, value: colors.informationContainer),
      (
        label: strings.onInformationContainer,
        value: colors.onInformationContainer,
      ),
    ]),
  );
}
