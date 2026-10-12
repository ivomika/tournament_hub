import 'package:flutter/widgets.dart';
import 'package:tournament_app/presentation/design_system/foundation/app_foundation.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/catalog/typography_catalog.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/catalog/typography_catalog_theme.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/foundation_scenario_host.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_typography.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:widgetbook/widgetbook.dart';

final typographyUseCase = WidgetbookUseCase(
  name: 'Text styles',
  builder: buildTypographyUseCase,
);

Widget buildTypographyUseCase(BuildContext context) {
  return const FoundationScenarioHost(child: Builder(builder: buildTextStyles));
}

Widget buildTextStyles(BuildContext context) {
  final strings = FoundationLocalizations.of(context);
  return TypographyCatalog(
    theme: const TypographyCatalogTheme(AppFoundation.dark()),
    samples: List.unmodifiable([
      (
        label: strings.display,
        text: strings.headlineSample,
        style: AppTypography.display,
      ),
      (
        label: strings.heading,
        text: strings.headlineSample,
        style: AppTypography.heading,
      ),
      (
        label: strings.title,
        text: strings.headlineSample,
        style: AppTypography.title,
      ),
      (
        label: strings.bodyLarge,
        text: strings.bodySample,
        style: AppTypography.bodyLarge,
      ),
      (
        label: strings.body,
        text: strings.bodySample,
        style: AppTypography.body,
      ),
      (
        label: strings.label,
        text: strings.compactSample,
        style: AppTypography.label,
      ),
      (
        label: strings.caption,
        text: strings.compactSample,
        style: AppTypography.caption,
      ),
      (
        label: strings.score,
        text: strings.scoreSample,
        style: AppTypography.score,
      ),
    ]),
  );
}
