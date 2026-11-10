import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/select_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class SelectComparison {
  static final spec = ComparisonSpec(
    component: 'select',
    title: 'AppSelect',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final desktop in [false, true])
        for (final sample in [
          SelectSample.normal,
          SelectSample.focused,
          SelectSample.disabled,
        ])
          ComparisonScenario(
            id: '${desktop ? 'desktop' : 'mobile'}-${sample.name}',
            title: '${desktop ? 'Desktop' : 'Mobile'} · ${sample.name}',
            viewport: desktop ? VisualViewport.desktop : VisualViewport.mobile,
            webSelector:
                '#c-select .kit-component-states .kit-specimen:nth-child(${(desktop ? 0 : 3) + sample.index + 1}) .${desktop ? 'field' : 'flow-panel'}',
            builder: (context) => SelectFixture(sample: sample),
            capturePadding: 12,
            controls: [
              ComparisonControl.text(
                id: 'label',
                webSelector: desktop ? 'label' : '.kit-setting-select>span',
                value: 'Оформление',
                properties: const [
                  ComparisonProperty.rect,
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
              ComparisonControl.type(
                id: 'frame',
                webSelector: desktop ? 'select' : '.kit-setting-select',
                type: DecoratedBox,
                withinType: AppSelect<SelectValue>,
                properties: const [
                  ComparisonProperty.rect,
                  ComparisonProperty.background,
                  ComparisonProperty.borderWidth,
                  ComparisonProperty.radius,
                ],
              ),
              ComparisonControl.text(
                id: 'value',
                webSelector: desktop ? 'select' : '.kit-setting-select>strong',
                value: 'Тёмное',
                textRange: desktop,
                properties: const [
                  ComparisonProperty.width,
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
              if (desktop)
                const ComparisonControl.type(
                  id: 'chevron',
                  webSelector: '.settings-select-shell>.icon',
                  type: AppIcon,
                  properties: [ComparisonProperty.rect],
                ),
            ],
          ),
      ComparisonScenario(
        id: 'mobile-sheet',
        title: 'Mobile · open bottom sheet',
        viewport: VisualViewport.mobile,
        webSelector: '.kit-select-sheet[open]',
        webOpenSelector: '#c-select [data-mobile-select]',
        builder: _sheet,
        capturePadding: 0,
        controls: [
          const ComparisonControl.type(
            id: 'surface',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'handle',
            webSelector: '.kit-sheet-handle',
            type: DecoratedBox,
            index: 1,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'close-icon',
            webSelector: '.kit-sheet-close .icon',
            type: AppIcon,
            index: 0,
            properties: [ComparisonProperty.rect],
          ),
          for (final sampleIndex in [0, 1, 2])
            ComparisonControl.type(
              id: 'option-frame-$sampleIndex',
              webSelector: '.kit-sheet-option:nth-child(${sampleIndex + 1})',
              type: DecoratedBox,
              index: sampleIndex + 2,
              properties: const [
                ComparisonProperty.rect,
                ComparisonProperty.background,
                ComparisonProperty.radius,
                ComparisonProperty.borderColor,
                ComparisonProperty.borderWidth,
              ],
            ),
          const ComparisonControl.text(
            id: 'title',
            textRange: true,
            webSelector: 'h2',
            value: 'Оформление',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.baseline,
              ComparisonProperty.color,
            ],
          ),
          const ComparisonControl.text(
            id: 'description',
            webSelector: '.kit-sheet-description',
            value: 'Выбери оформление интерфейса',
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.fontSize,
              ComparisonProperty.baseline,
              ComparisonProperty.color,
            ],
          ),
          for (final (sampleIndex, label) in [
            'Тёмное',
            'Светлое',
            'Как в системе',
          ].indexed)
            ComparisonControl.text(
              id: 'option-$sampleIndex',
              webSelector:
                  '.kit-sheet-option:nth-child(${sampleIndex + 1})>span',
              value: label,
              properties: const [
                ComparisonProperty.fontSize,
                ComparisonProperty.fontWeight,
                ComparisonProperty.baseline,
                ComparisonProperty.color,
              ],
            ),
        ],
      ),
    ],
  );
  static Widget _sheet(BuildContext context) =>
      const SelectFixture(sample: SelectSample.sheet);
}
