import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/bracket_node/app_bracket_node.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/bracket_node/bracket_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class BracketComparison {
  static final spec = ComparisonSpec(
    component: 'bracket-node',
    title: 'AppBracketNode',
    goldenDirectory:
        'lib/presentation/design_system/widgets/bracket_node/golden',
    geometryTolerance: .5,
    baselineTolerance: 1.25,
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final state in AppBracketState.values)
          ComparisonScenario(
            id: '${viewport.name}-${state.name}',
            title: '${viewport.name} · ${state.name}',
            note: 'Compact line boxes сохраняют CSS дробные15.6/16.5px через runtime style×textScaler; без ручных offsets. Baseline estimate допускает1.25px.',
            viewport: viewport,
            webSelector:
                '#c-bracket .kit-component-states .kit-specimen:nth-child(${state.index + 1}) button',
            builder: (context) => BracketFixture(state: state),
            controls: [
              const ComparisonControl.type(
                id: 'surface',
                webSelector: ':scope',
                type: DecoratedBox,
                properties: [
                  ComparisonProperty.rect,
                  ComparisonProperty.background,
                  ComparisonProperty.radius,
                  ComparisonProperty.borderColor,
                  ComparisonProperty.borderWidth,
                ],
              ),
              ComparisonControl.text(
                id: 'label',
                webSelector: '.bracket-map-match-label',
                value: switch (state) {
                  AppBracketState.ready => 'W1 · Раунд 1',
                  AppBracketState.current => 'W5 · Сейчас',
                  AppBracketState.pending => 'W6 · Полуфинал',
                },
                properties: const [
                  ComparisonProperty.rect,
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
              if (state != AppBracketState.pending)
                for (final (i, name) in ['Sub-Zero', 'Scorpion'].indexed) ...[
                  ComparisonControl.type(
                    id: 'avatar-$i',
                    webSelector:
                        '.bracket-map-player:nth-of-type(${i + 2}) .bracket-map-avatar',
                    type: AppAvatar,
                    index: i,
                    properties: const [ComparisonProperty.rect],
                  ),
                  ComparisonControl.text(
                    id: 'initials-$i',
                    webSelector:
                        '.bracket-map-player:nth-of-type(${i + 2}) .bracket-map-avatar',
                    value: i == 0 ? 'SZ' : 'SC',
                    properties: const [
                      ComparisonProperty.fontSize,
                      ComparisonProperty.fontWeight,
                      ComparisonProperty.color,
                      ComparisonProperty.baseline,
                    ],
                  ),
                  ComparisonControl.text(
                    id: 'secondary-$i',
                    webSelector:
                        '.bracket-map-player:nth-of-type(${i + 2}) small',
                    value: i == 0 ? 'Иван' : 'Алексей',
                    properties: const [
                      ComparisonProperty.rect,
                      ComparisonProperty.fontSize,
                      ComparisonProperty.fontWeight,
                      ComparisonProperty.color,
                      ComparisonProperty.baseline,
                    ],
                  ),
                  ComparisonControl.text(
                    id: 'name-$i',
                    webSelector:
                        '.bracket-map-player:nth-of-type(${i + 2}) strong',
                    value: name,
                    properties: const [
                      ComparisonProperty.rect,
                      ComparisonProperty.fontSize,
                      ComparisonProperty.fontWeight,
                      ComparisonProperty.color,
                      ComparisonProperty.baseline,
                    ],
                  ),
                ],
              if (state == AppBracketState.pending)
                for (final (i, text) in [
                  'Победитель W3',
                  'Победитель W4',
                ].indexed)
                  ComparisonControl.text(
                    id: 'pending-$i',
                    webSelector: '.bracket-map-unknown:nth-of-type(${i + 2})',
                    textRange: true,
                    value: text,
                    properties: const [
                      ComparisonProperty.width,
                      ComparisonProperty.fontSize,
                      ComparisonProperty.fontWeight,
                      ComparisonProperty.color,
                      ComparisonProperty.baseline,
                    ],
                  ),
            ],
          ),
    ],
  );
}
