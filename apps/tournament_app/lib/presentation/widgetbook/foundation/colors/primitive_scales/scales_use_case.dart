import 'package:flutter/widgets.dart';
import 'package:tournament_app/presentation/design_system/foundation/app_foundation.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/color_primitives.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/palette/color_palette.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/palette/palette_theme.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/foundation_scenario_host.dart';
import 'package:widgetbook/widgetbook.dart';

final scalesUseCase = WidgetbookUseCase(
  name: 'Primitive scales',
  builder: buildScalesUseCase,
);

Widget buildScalesUseCase(BuildContext context) {
  return const FoundationScenarioHost(
    child: Builder(builder: buildPrimitiveScales),
  );
}

Widget buildPrimitiveScales(BuildContext context) {
  final strings = FoundationLocalizations.of(context);
  return ColorPalette(
    theme: const PaletteTheme(AppFoundation.dark()),
    title: strings.colorScalesTitle,
    description: strings.colorScalesDescription,
    // Подписи — технические имена const tokens, не строковый lookup.
    samples: const [
      (label: 'graphite50', value: ColorPrimitives.graphite50),
      (label: 'graphite100', value: ColorPrimitives.graphite100),
      (label: 'graphite200', value: ColorPrimitives.graphite200),
      (label: 'graphite300', value: ColorPrimitives.graphite300),
      (label: 'graphite400', value: ColorPrimitives.graphite400),
      (label: 'graphite500', value: ColorPrimitives.graphite500),
      (label: 'graphite600', value: ColorPrimitives.graphite600),
      (label: 'graphite700', value: ColorPrimitives.graphite700),
      (label: 'graphite800', value: ColorPrimitives.graphite800),
      (label: 'graphite900', value: ColorPrimitives.graphite900),
      (label: 'graphite950', value: ColorPrimitives.graphite950),
      (label: 'gold50', value: ColorPrimitives.gold50),
      (label: 'gold100', value: ColorPrimitives.gold100),
      (label: 'gold200', value: ColorPrimitives.gold200),
      (label: 'gold300', value: ColorPrimitives.gold300),
      (label: 'gold400', value: ColorPrimitives.gold400),
      (label: 'gold500', value: ColorPrimitives.gold500),
      (label: 'gold600', value: ColorPrimitives.gold600),
      (label: 'gold700', value: ColorPrimitives.gold700),
      (label: 'gold800', value: ColorPrimitives.gold800),
      (label: 'gold900', value: ColorPrimitives.gold900),
      (label: 'gold950', value: ColorPrimitives.gold950),
      (label: 'green50', value: ColorPrimitives.green50),
      (label: 'green100', value: ColorPrimitives.green100),
      (label: 'green200', value: ColorPrimitives.green200),
      (label: 'green300', value: ColorPrimitives.green300),
      (label: 'green400', value: ColorPrimitives.green400),
      (label: 'green500', value: ColorPrimitives.green500),
      (label: 'green600', value: ColorPrimitives.green600),
      (label: 'green700', value: ColorPrimitives.green700),
      (label: 'green800', value: ColorPrimitives.green800),
      (label: 'green900', value: ColorPrimitives.green900),
      (label: 'green950', value: ColorPrimitives.green950),
      (label: 'red50', value: ColorPrimitives.red50),
      (label: 'red100', value: ColorPrimitives.red100),
      (label: 'red200', value: ColorPrimitives.red200),
      (label: 'red300', value: ColorPrimitives.red300),
      (label: 'red400', value: ColorPrimitives.red400),
      (label: 'red500', value: ColorPrimitives.red500),
      (label: 'red600', value: ColorPrimitives.red600),
      (label: 'red700', value: ColorPrimitives.red700),
      (label: 'red800', value: ColorPrimitives.red800),
      (label: 'red900', value: ColorPrimitives.red900),
      (label: 'red950', value: ColorPrimitives.red950),
      (label: 'blue50', value: ColorPrimitives.blue50),
      (label: 'blue100', value: ColorPrimitives.blue100),
      (label: 'blue200', value: ColorPrimitives.blue200),
      (label: 'blue300', value: ColorPrimitives.blue300),
      (label: 'blue400', value: ColorPrimitives.blue400),
      (label: 'blue500', value: ColorPrimitives.blue500),
      (label: 'blue600', value: ColorPrimitives.blue600),
      (label: 'blue700', value: ColorPrimitives.blue700),
      (label: 'blue800', value: ColorPrimitives.blue800),
      (label: 'blue900', value: ColorPrimitives.blue900),
      (label: 'blue950', value: ColorPrimitives.blue950),
      (label: 'amber50', value: ColorPrimitives.amber50),
      (label: 'amber100', value: ColorPrimitives.amber100),
      (label: 'amber200', value: ColorPrimitives.amber200),
      (label: 'amber300', value: ColorPrimitives.amber300),
      (label: 'amber400', value: ColorPrimitives.amber400),
      (label: 'amber500', value: ColorPrimitives.amber500),
      (label: 'amber600', value: ColorPrimitives.amber600),
      (label: 'amber700', value: ColorPrimitives.amber700),
      (label: 'amber800', value: ColorPrimitives.amber800),
      (label: 'amber900', value: ColorPrimitives.amber900),
      (label: 'amber950', value: ColorPrimitives.amber950),
    ],
  );
}
