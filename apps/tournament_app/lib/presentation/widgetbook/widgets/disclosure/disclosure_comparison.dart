import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/disclosure/disclosure_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class DisclosureComparison {
  static final spec = ComparisonSpec(
    component: 'disclosure',
    title: 'AppDisclosure',
    goldenDirectory: 'lib/presentation/design_system/widgets/disclosure/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final open in [false, true])
        ComparisonScenario(
          id: 'state-${open ? 'open' : 'closed'}',
          title: open ? 'Open' : 'Closed',
          viewport: VisualViewport.mobile,
          webSelector:
              '#c-disclosure .kit-component-states .kit-specimen:nth-child(${open ? 2 : 1}) details',
          builder: (context) => DisclosureFixture(open: open),
          controls: _controls(open),
        ),
      for (final viewport in VisualViewport.values)
        ComparisonScenario(
          id: '${viewport.name}-open',
          title: '${viewport.name} · open',
          viewport: viewport,
          webSelector:
              '#c-disclosure .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) details',
          builder: _open,
          controls: _controls(true),
        ),
    ],
  );
  static Widget _open(BuildContext context) =>
      const DisclosureFixture(open: true);
  static List<ComparisonControl> _controls(bool open) => [
    const ComparisonControl.type(
      id: 'summary',
      webSelector: 'summary',
      type: TextButton,
      properties: [ComparisonProperty.rect],
    ),
    const ComparisonControl.text(
      id: 'title',
      webSelector: 'summary',
      textRange: true,
      value: 'Управление турниром',
      properties: [
        ComparisonProperty.width,
        ComparisonProperty.fontSize,
        ComparisonProperty.fontWeight,
        ComparisonProperty.color,
        ComparisonProperty.baseline,
      ],
    ),
    const ComparisonControl.type(
      id: 'chevron',
      webSelector: '.icon',
      type: AppIcon,
      properties: [ComparisonProperty.rect],
    ),
    if (open)
      const ComparisonControl.text(
        id: 'body',
        webSelector: '.competition-disclosure-body',
        textRange: true,
        value: 'Дополнительные действия доступны в контексте турнира.',
        properties: [
          ComparisonProperty.fontSize,
          ComparisonProperty.fontWeight,
          ComparisonProperty.color,
          ComparisonProperty.baseline,
        ],
      ),
  ];
}
