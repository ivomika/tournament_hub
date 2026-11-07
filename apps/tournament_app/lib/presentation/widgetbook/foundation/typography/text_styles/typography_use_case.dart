import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/catalog/typography_catalog.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/foundation_scenario_host.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/require_theme_extension.dart';
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
  final theme = Theme.of(context);
  final text = theme.textTheme;
  return TypographyCatalog(
    samples: List.unmodifiable([
      (
        label: strings.display,
        text: strings.headlineSample,
        style: text.displayLarge!,
      ),
      (
        label: strings.heading,
        text: strings.headlineSample,
        style: text.headlineLarge!,
      ),
      (
        label: strings.title,
        text: strings.headlineSample,
        style: text.titleLarge!,
      ),
      (
        label: strings.bodyLarge,
        text: strings.bodySample,
        style: text.bodyLarge!,
      ),
      (label: strings.body, text: strings.bodySample, style: text.bodyMedium!),
      (
        label: strings.label,
        text: strings.compactSample,
        style: text.labelLarge!,
      ),
      (
        label: strings.caption,
        text: strings.compactSample,
        style: text.bodySmall!,
      ),
      (
        label: strings.score,
        text: strings.scoreSample,
        style: requireThemeExtension<AppTypeRoles>(theme).score,
      ),
    ]),
  );
}
