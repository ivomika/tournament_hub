import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/navigation_item/app_navigation_item.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/widgetbook/components/navigation_item/navigation_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class NavigationComparison {
  static final spec = ComparisonSpec(
    component: 'navigation-item',
    title: 'AppNavigationItem',
    goldenDirectory:
        'lib/presentation/design_system/components/navigation_item/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final (sampleIndex, state) in <WidgetState?>[
        null,
        WidgetState.hovered,
        WidgetState.focused,
      ].indexed)
        ComparisonScenario(
          id: 'mobile-${state?.name ?? 'default'}',
          title: 'Mobile · ${state?.name ?? 'default'}',
          viewport: VisualViewport.mobile,
          webSelector:
              '#c-navigation .kit-component-states .kit-specimen:nth-child(${sampleIndex + 1}) .profile-menu',
          builder: (context) => NavigationFixture(state: state),
          capturePadding: 12,
          controls: _controls(false),
        ),
      for (final viewport in VisualViewport.values)
        ComparisonScenario(
          id: '${viewport.name}-adaptation',
          title: '${viewport.name} · adaptation',
          viewport: viewport,
          webSelector:
              '#c-navigation .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) ${viewport == VisualViewport.desktop ? 'a' : '.profile-menu'}',
          builder: _normal,
          capturePadding: 12,
          controls: _controls(viewport == VisualViewport.desktop),
        ),
    ],
  );
  static Widget _normal(BuildContext context) => const NavigationFixture();
  static List<ComparisonControl> _controls(bool desktop) => [
    ComparisonControl.type(
      id: 'frame',
      webSelector: desktop ? ':scope' : 'a',
      type: DecoratedBox,
      withinType: AppNavigationItem,
      properties: const [
        ComparisonProperty.rect,
        ComparisonProperty.background,
        ComparisonProperty.radius,
      ],
    ),
    const ComparisonControl.text(
      id: 'label',
      webSelector: 'span',
      value: 'Настройки',
      properties: [
        ComparisonProperty.rect,
        ComparisonProperty.fontSize,
        ComparisonProperty.fontWeight,
        ComparisonProperty.color,
        ComparisonProperty.baseline,
      ],
    ),
    for (final sampleIndex in [0, 1])
      ComparisonControl.type(
        id: 'icon-$sampleIndex',
        webSelector: sampleIndex == 0
            ? '.icon:first-child'
            : '.icon:last-child',
        type: AppIcon,
        index: sampleIndex,
        properties: const [ComparisonProperty.rect],
      ),
  ];
}
