import 'package:flutter/material.dart';

import '../ds_section/ds_section.dart';
import '../ds_surface/ds_surface.dart';
import '../ds_text/ds_text.dart';
import 'token_showcase_theme.dart';

class TokenShowcase extends StatelessWidget {
  const TokenShowcase({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<TokenShowcaseTheme>()!;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DsSection(
            title: 'Colors',
            child: Wrap(
              spacing: theme.gap,
              runSpacing: theme.gap,
              children: [
                for (final sample in theme.colors)
                  DsSurface(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: sample.value,
                            borderRadius: BorderRadius.circular(
                              theme.swatchRadius,
                            ),
                          ),
                          child: SizedBox.square(dimension: theme.swatchSize),
                        ),
                        SizedBox(height: theme.gap),
                        DsText(sample.name, variant: DsTextVariant.label),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: theme.gap),
          _MetricGroup(
            title: 'Spacing',
            samples: theme.spacing,
            gap: theme.gap,
          ),
          SizedBox(height: theme.gap),
          _MetricGroup(title: 'Radii', samples: theme.radii, gap: theme.gap),
          SizedBox(height: theme.gap),
          _MetricGroup(
            title: 'Typography',
            samples: theme.typography,
            gap: theme.gap,
          ),
          SizedBox(height: theme.gap),
          _MetricGroup(
            title: 'Breakpoints',
            samples: theme.breakpoints,
            gap: theme.gap,
          ),
          SizedBox(height: theme.gap),
          _MetricGroup(title: 'Layout', samples: theme.layout, gap: theme.gap),
          SizedBox(height: theme.gap),
          _MetricGroup(
            title: 'Controls',
            samples: theme.controls,
            gap: theme.gap,
          ),
          SizedBox(height: theme.gap),
          _MetricGroup(
            title: 'Artwork',
            samples: theme.artwork,
            gap: theme.gap,
          ),
          SizedBox(height: theme.gap),
          _MetricGroup(
            title: 'Borders',
            samples: theme.borders,
            gap: theme.gap,
          ),
          SizedBox(height: theme.gap),
          _MetricGroup(title: 'Motion', samples: theme.motion, gap: theme.gap),
        ],
      ),
    );
  }
}

class _MetricGroup extends StatelessWidget {
  const _MetricGroup({
    required this.title,
    required this.samples,
    required this.gap,
  });

  final String title;
  final List<TokenMetricSample> samples;
  final double gap;

  @override
  Widget build(BuildContext context) => DsSection(
    title: title,
    child: LayoutBuilder(
      builder: (context, constraints) => Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [
          for (final sample in samples)
            ConstrainedBox(
              constraints: BoxConstraints(maxWidth: constraints.maxWidth),
              child: DsSurface(
                child: DsText(
                  '${sample.name}: ${_format(sample.value)}${sample.unit}',
                  variant: DsTextVariant.label,
                ),
              ),
            ),
        ],
      ),
    ),
  );

  String _format(Object value) =>
      value is Duration ? value.inMilliseconds.toString() : value.toString();
}
