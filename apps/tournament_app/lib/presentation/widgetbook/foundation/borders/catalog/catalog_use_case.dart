import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_sample_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/shape/app_shape.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

enum BorderSample { decorative, selected, error, focus }

final bordersCatalogUseCase = WidgetbookUseCase(
  name: 'Border roles / selected / error',
  builder: BordersCatalogUseCase.build,
);

abstract final class BordersCatalogUseCase {
  static Widget build(BuildContext context) => const BorderCatalogFixture();
}

class BorderCatalogFixture extends StatelessWidget {
  const BorderCatalogFixture({super.key});
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: Theme.of(context).extension<AppSpacing>()!.space16,
    runSpacing: Theme.of(context).extension<AppSpacing>()!.space16,
    children: [
      for (final sample in BorderSample.values) _BorderSample(sample: sample),
    ],
  );
}

class _BorderSample extends StatelessWidget {
  const _BorderSample({required this.sample});
  final BorderSample sample;
  @override
  Widget build(BuildContext context) {
    final appearance = Theme.of(context),
        runtimeBorderMetrics = appearance.extension<AppBorderMetrics>()!,
        runtimeFoundationSampleMetrics = appearance
            .extension<FoundationSampleMetrics>()!;
    final width = switch (sample) {
      BorderSample.selected => runtimeBorderMetrics.emphasis,
      BorderSample.focus => runtimeBorderMetrics.highContrastFocus,
      _ => runtimeBorderMetrics.hairline,
    };
    final color = switch (sample) {
      BorderSample.selected => appearance.colorScheme.primary,
      BorderSample.error => appearance.colorScheme.error,
      BorderSample.focus => appearance.focusColor,
      _ => appearance.colorScheme.outlineVariant,
    };
    return SizedBox.square(
      dimension: runtimeFoundationSampleMetrics.shapeExtent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: appearance.colorScheme.surface,
          borderRadius: appearance.extension<AppShape>()!.control,
          border: Border.all(color: color, width: width),
        ),
        child: Align(
          alignment: runtimeFoundationSampleMetrics.center,
          child: Text(
            FoundationLocalizations.of(context).foundationMetricValue(width),
            style: AppTextStyles(appearance).caption,
          ),
        ),
      ),
    );
  }
}
