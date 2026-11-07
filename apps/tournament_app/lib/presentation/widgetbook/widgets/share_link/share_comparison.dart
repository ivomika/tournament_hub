import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/share_link/share_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class ShareComparison {
  static final spec = ComparisonSpec(
    component: 'share-link',
    title: 'AppShareLink',
    goldenDirectory: 'lib/presentation/design_system/widgets/share_link/golden',
    geometryTolerance: .5,
    baselineTolerance: 1,
    scenarios: [
      for (final long in [false, true])
        ComparisonScenario(
          id: 'state-${long ? 'long' : 'short'}',
          title: long ? 'Long' : 'Short',
          viewport: VisualViewport.mobile,
          webSelector:
              '#c-share .kit-component-states .kit-specimen:nth-child(${long ? 2 : 1}) .spectator-link',
          builder: (context) => ShareFixture(long: long),
          controls: _controls(long),
        ),
      for (final viewport in VisualViewport.values)
        ComparisonScenario(
          id: '${viewport.name}-share',
          title: '${viewport.name} · share',
          viewport: viewport,
          webSelector:
              '#c-share .kit-adaptation .kit-specimen:nth-of-type(${viewport == VisualViewport.desktop ? 2 : 1}) .spectator-link',
          builder: _normal,
          controls: _controls(false),
        ),
    ],
  );
  static Widget _normal(BuildContext context) => const ShareFixture();
  static List<ComparisonControl> _controls(bool long) => [
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
    ComparisonControl.text(
      id: 'address',
      webSelector: '.flow-address',
      value: long
          ? 'Только просмотр\nhttp://host.local/spectator/tournament-with-a-long-session-address'
                .replaceAll('/', '/\u2060')
          : 'Только просмотр\nhttp://host.local/spectator'.replaceAll(
              '/',
              '/\u2060',
            ),
      properties: const [
        ComparisonProperty.rect,
        ComparisonProperty.fontSize,
        ComparisonProperty.fontWeight,
        ComparisonProperty.color,
        ComparisonProperty.baseline,
      ],
    ),
    const ComparisonControl.type(
      id: 'copy',
      webSelector: 'button',
      type: AppButton,
      properties: [ComparisonProperty.rect],
    ),
    const ComparisonControl.type(
      id: 'copy-style',
      webSelector: 'button',
      type: DecoratedBox,
      withinType: AppButton,
      properties: [ComparisonProperty.background, ComparisonProperty.radius],
    ),
    const ComparisonControl.type(
      id: 'glyph',
      webSelector: 'button .icon',
      type: AppIcon,
      properties: [ComparisonProperty.rect],
    ),
  ];
}
