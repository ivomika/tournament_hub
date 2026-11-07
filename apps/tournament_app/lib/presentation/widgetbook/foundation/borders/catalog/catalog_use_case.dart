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
    final t = Theme.of(context),
        b = t.extension<AppBorderMetrics>()!,
        m = t.extension<FoundationSampleMetrics>()!;
    final width = switch (sample) {
      BorderSample.selected => b.emphasis,
      BorderSample.focus => b.highContrastFocus,
      _ => b.hairline,
    };
    final color = switch (sample) {
      BorderSample.selected => t.colorScheme.primary,
      BorderSample.error => t.colorScheme.error,
      BorderSample.focus => t.focusColor,
      _ => t.colorScheme.outlineVariant,
    };
    return SizedBox.square(
      dimension: m.shapeExtent,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: t.colorScheme.surface,
          borderRadius: t.extension<AppShape>()!.control,
          border: Border.all(color: color, width: width),
        ),
        child: Align(
          alignment: m.center,
          child: Text(
            FoundationLocalizations.of(context).foundationMetricValue(width),
            style: AppTextStyles(t).caption,
          ),
        ),
      ),
    );
  }
}
