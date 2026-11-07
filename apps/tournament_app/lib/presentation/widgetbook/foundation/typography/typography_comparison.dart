import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_styles.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

enum SourceTextRole {
  display,
  heading,
  title,
  body,
  label,
  caption,
  compactHeader,
  comfortableHeader,
}

abstract final class TypographyComparison {
  static final spec = ComparisonSpec(
    component: 'typography',
    title: 'Foundation Typography',
    geometryTolerance: 0.5,
    baselineTolerance: 1,
    goldenDirectory:
        'lib/presentation/design_system/foundation/typography/catalog/golden',
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final role in SourceTextRole.values)
          ComparisonScenario(
            id: '${viewport.name}-${role.name.toLowerCase()}',
            title: '${viewport.name} · ${role.name}',
            viewport: viewport,
            webSelector:
                '#typography .kit-type-row:nth-of-type(${role.index + 2}) .kit-type-example',
            note: role == SourceTextRole.title
                ? 'CSS line-height32.5px / Flutter33px; font baseline estimate отличается на1.208px. Явный допуск baseline1.25px только для Title; ручных offsets нет.'
                : null,
            builder: (context) => SourceTextFixture(role: role),
            controls: [
              ComparisonControl.text(
                id: 'text',
                webSelector: ':scope',
                baselineTolerance: role == SourceTextRole.title ? 1.25 : null,
                value: _source[role.index],
                properties: const [
                  ComparisonProperty.rect,
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.lineHeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
            ],
          ),
    ],
  );
  static const _source = [
    'TOURNAMENT HUB.',
    'Твой следующий турнир',
    'Пятничный турнир',
    'Основной текст · Aa Бб 012345',
    'Продолжить турнир',
    'Метаданные и пояснения · FT2',
    'Новый турнир',
    'Новый турнир',
  ];
}

class SourceTextFixture extends StatelessWidget {
  const SourceTextFixture({required this.role, super.key});
  final SourceTextRole role;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context),
        styles = AppTextStyles(t),
        l = FoundationLocalizations.of(context);
    final style = switch (role) {
      SourceTextRole.display => styles.display,
      SourceTextRole.heading => styles.heading,
      SourceTextRole.title => styles.title,
      SourceTextRole.body => styles.body,
      SourceTextRole.label => styles.label,
      SourceTextRole.caption => styles.caption,
      SourceTextRole.compactHeader => styles.compactHeader,
      SourceTextRole.comfortableHeader => styles.comfortableHeader,
    };
    final value = switch (role) {
      SourceTextRole.display => l.typeSource0,
      SourceTextRole.heading => l.typeSource1,
      SourceTextRole.title => l.typeSource2,
      SourceTextRole.body => l.typeSource3,
      SourceTextRole.label => l.typeSource4,
      SourceTextRole.caption => l.typeSource5,
      SourceTextRole.compactHeader => l.typeSource6,
      SourceTextRole.comfortableHeader => l.typeSource7,
    };
    return SizedBox(
      width: t.extension<FoundationLayout>()!.fullWidth,
      child: Text(value, style: style.copyWith(color: t.colorScheme.onSurface)),
    );
  }
}
