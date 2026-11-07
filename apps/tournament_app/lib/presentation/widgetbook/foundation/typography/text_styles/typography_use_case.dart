import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/catalog/typography_catalog.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/foundation_scenario_host.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/theme_extensions.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:widgetbook/widgetbook.dart';

final typographyUseCase = WidgetbookUseCase(
  name: 'Text styles',
  builder: TypographyPreview.build,
);

abstract final class TypographyPreview {
  static Widget build(BuildContext context) {
    return const FoundationScenarioHost(child: Builder(builder: buildSamples));
  }

  static Widget buildSamples(BuildContext context) {
    final strings = FoundationLocalizations.of(context);
    final theme = Theme.of(context);
    final text = AppTextStyles(theme);
    return TypographyCatalog(
      samples: List.unmodifiable([
        (
          label: strings.display,
          text: strings.headlineSample,
          style: text.display,
        ),
        (
          label: strings.heading,
          text: strings.headlineSample,
          style: text.heading,
        ),
        (label: strings.title, text: strings.headlineSample, style: text.title),
        (
          label: strings.bodyLarge,
          text: strings.bodySample,
          style: text.bodyLarge,
        ),
        (label: strings.body, text: strings.bodySample, style: text.body),
        (label: strings.label, text: strings.compactSample, style: text.label),
        (
          label: strings.caption,
          text: strings.compactSample,
          style: text.caption,
        ),
        (
          label: strings.score,
          text: strings.scoreSample,
          style: ThemeExtensions.require<AppTypeRoles>(theme).score,
        ),
      ]),
    );
  }
}
