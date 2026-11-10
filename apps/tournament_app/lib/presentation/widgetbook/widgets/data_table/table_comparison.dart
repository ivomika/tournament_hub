import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/data_table/table_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class TableComparison {
  static final spec = ComparisonSpec(
    component: 'data-table',
    title: 'AppDataTable',
    goldenDirectory: 'lib/presentation/design_system/widgets/data_table/golden',
    geometryTolerance: .75,
    baselineTolerance: 1,
    scenarios: [
      for (final viewport in VisualViewport.values)
        ComparisonScenario(
          id: '${viewport.name}-standings',
          title: '${viewport.name} · standings',
          note: 'CSS45.796px/native46px на3 строках дают0.609px разницы; явный геометрический допуск0.75px.',
          viewport: viewport,
          webSelector:
              '#c-table .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) .flow-table-wrap',
          builder: _standings,
          controls: [
            for (final row in [0, 1, 2])
              for (final column in [1, 2])
                ComparisonControl.type(
                  id: 'cell-$row-$column',
                  webSelector:
                      'tbody tr:nth-child(${row + 1}) td:nth-of-type($column)',
                  type: Padding,
                  withinType: Table,
                  index: 3 + row * 3 + column,
                  properties: const [
                    ComparisonProperty.width,
                    ComparisonProperty.center,
                  ],
                ),

            const ComparisonControl.text(
              id: 'caption',
              webSelector: 'caption',
              value: 'Основной этап · итоговые очки',
              properties: [
                ComparisonProperty.fontSize,
                ComparisonProperty.fontWeight,
                ComparisonProperty.color,
                ComparisonProperty.baseline,
              ],
            ),
            for (final (participantIndex, label) in [
              'Участник',
              'Очки',
              'М',
            ].indexed)
              ComparisonControl.text(
                id: 'header-$participantIndex',
                webSelector: 'thead th:nth-child(${participantIndex + 1})',
                textRange: true,
                value: label,
                properties: const [
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
            for (final (participantIndex, primary) in [
              'Sub-Zero',
              'Scorpion',
              'Kitana',
            ].indexed) ...[
              ComparisonControl.type(
                id: 'avatar-$participantIndex',
                webSelector:
                    'tbody tr:nth-child(${participantIndex + 1}) .flow-avatar',
                type: AppAvatar,
                index: participantIndex,
                properties: const [ComparisonProperty.rect],
              ),
              ComparisonControl.text(
                id: 'primary-$participantIndex',
                webSelector:
                    'tbody tr:nth-child(${participantIndex + 1}) strong',
                value: primary,
                properties: const [
                  ComparisonProperty.rect,
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
              ComparisonControl.text(
                id: 'points-$participantIndex',
                webSelector:
                    'tbody tr:nth-child(${participantIndex + 1}) td:first-of-type',
                textRange: true,
                value: '3',
                index: participantIndex,
                properties: const [
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
            ],
          ],
        ),
    ],
  );
  static Widget _standings(BuildContext context) => const TableFixture();
}
