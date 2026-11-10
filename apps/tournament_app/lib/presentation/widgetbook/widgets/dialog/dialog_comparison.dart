import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/dialog/dialog_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class DialogComparison {
  static final spec = ComparisonSpec(
    component: 'dialog',
    title: 'AppDialog',
    goldenDirectory: 'lib/presentation/design_system/widgets/dialog/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final disabled in [false, true])
        ComparisonScenario(
          id: 'state-${disabled ? 'disabled' : 'default'}',
          title: disabled ? 'Unavailable' : 'Default',
          viewport: VisualViewport.mobile,
          webSelector:
              '#c-dialog .kit-component-states .kit-specimen:nth-child(${disabled ? 2 : 1}) .flow-alert',
          builder: (context) => DialogFixture(disabled: disabled),
          controls: _controls(false),
          capturePadding: 128,
        ),
      for (final viewport in VisualViewport.values)
        ComparisonScenario(
          id: '${viewport.name}-dialog',
          title: '${viewport.name} · dialog',
          viewport: viewport,
          webSelector:
              '#c-dialog .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) .flow-alert',
          builder: _normal,
          controls: _controls(viewport == VisualViewport.desktop),
          capturePadding: 128,
        ),
    ],
  );
  static Widget _normal(BuildContext context) => const DialogFixture();
  static List<ComparisonControl> _controls(bool desktop) => [
    ComparisonControl.type(
      id: 'surface',
      webSelector: ':scope',
      type: DecoratedBox,
      properties: [
        ComparisonProperty.rect,
        ComparisonProperty.background,
        ComparisonProperty.radius,
        ComparisonProperty.borderWidth,
        if (desktop) ComparisonProperty.borderColor,
      ],
    ),
    const ComparisonControl.text(
      id: 'title',
      webSelector: 'h2',
      value: 'Снять Алексея с турнира?',
      properties: [
        ComparisonProperty.rect,
        ComparisonProperty.fontSize,
        ComparisonProperty.fontWeight,
        ComparisonProperty.color,
        ComparisonProperty.baseline,
      ],
    ),
    const ComparisonControl.text(
      id: 'body',
      webSelector: 'p',
      value: 'Прошлые результаты сохранятся. Вернуть игрока в турнир нельзя.',
      properties: [
        ComparisonProperty.rect,
        ComparisonProperty.fontSize,
        ComparisonProperty.fontWeight,
        ComparisonProperty.color,
        ComparisonProperty.baseline,
      ],
    ),
    for (final (participantIndex, text) in [
      'Снять участника',
      'Отмена',
    ].indexed) ...[
      ComparisonControl.type(
        id: 'button-$participantIndex',
        webSelector:
            '.flow-alert-actions button:nth-child(${participantIndex + 1})',
        type: AppButton,
        index: participantIndex,
        properties: const [ComparisonProperty.rect],
      ),
      ComparisonControl.type(
        id: 'button-style-$participantIndex',
        webSelector:
            '.flow-alert-actions button:nth-child(${participantIndex + 1})',
        type: DecoratedBox,
        withinType: AppButton,
        index: participantIndex,
        properties: const [
          ComparisonProperty.background,
          ComparisonProperty.radius,
        ],
      ),
      ComparisonControl.text(
        id: 'button-label-$participantIndex',
        webSelector:
            '.flow-alert-actions button:nth-child(${participantIndex + 1})',
        textRange: true,
        value: text,
        properties: const [
          ComparisonProperty.fontSize,
          ComparisonProperty.fontWeight,
          ComparisonProperty.color,
          ComparisonProperty.baseline,
        ],
      ),
    ],
  ];
}
