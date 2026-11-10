import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class RosterComparison {
  static String _resolveStateName(bool desktop, bool state) {
    if (!state) return 'default';
    if (desktop) return 'focus';
    return 'revealed';
  }

  static String _resolveStateTitle(bool desktop, bool state) {
    if (!state) return 'Default';
    if (desktop) return 'Focus';
    return 'Revealed';
  }

  static final spec = ComparisonSpec(
    component: 'roster-row',
    title: 'Строка участников · AppRosterRow',
    goldenDirectory: 'lib/presentation/design_system/widgets/roster_row/golden',
    geometryTolerance: 0.5,
    baselineTolerance: 1,
    scenarios: [
      for (final desktop in [false, true])
        for (final state in [false, true])
          ComparisonScenario(
            note: desktop && state
                ? 'Контур: CSS-демонстрация .kit-focus использует3px; Flutter использует2px из фактического desktop :focus-visible прототипа. Это явно принятое различие оформления, видно в diff.'
                : null,
            id: '${desktop ? 'desktop' : 'mobile'}-${_resolveStateName(desktop, state)}',
            title:
                '${desktop ? 'Desktop' : 'Mobile'} · ${_resolveStateTitle(desktop, state)}',
            viewport: desktop ? VisualViewport.desktop : VisualViewport.mobile,
            webSelector:
                '#c-row .kit-component:nth-child(${desktop ? 2 : 1}) .kit-specimen:nth-child(${state ? 2 : 1}) .flow-player-row',
            builder: (context) => RosterFixture(
              revealed: !desktop && state,
              focused: desktop && state,
            ),
            controls: [
              const ComparisonControl.type(
                id: 'frame',
                webSelector: ':scope',
                type: ClipRRect,
                properties: [
                  ComparisonProperty.rect,
                  ComparisonProperty.radius,
                ],
              ),
              const ComparisonControl.type(
                id: 'avatar',
                webSelector: '.flow-avatar',
                type: AppAvatar,
                properties: [ComparisonProperty.rect],
              ),
              const ComparisonControl.type(
                id: 'avatar-style',
                webSelector: '.flow-avatar',
                type: DecoratedBox,
                withinType: AppAvatar,
                properties: [
                  ComparisonProperty.background,
                  ComparisonProperty.radius,
                  ComparisonProperty.borderWidth,
                ],
              ),
              const ComparisonControl.text(
                id: 'initials',
                webSelector: '.flow-avatar',
                value: 'И',
                properties: [
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
              const ComparisonControl.text(
                id: 'name',
                webSelector: '.flow-person>strong',
                value: 'Иван',
                properties: [
                  ComparisonProperty.rect,
                  ComparisonProperty.fontSize,
                  ComparisonProperty.fontWeight,
                  ComparisonProperty.lineHeight,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
              if (desktop || state)
                const ComparisonControl.type(
                  id: 'remove',
                  webSelector: '.flow-roster-remove',
                  type: AppButton,
                  properties: [ComparisonProperty.rect],
                ),
              if (desktop || state)
                const ComparisonControl.type(
                  id: 'remove-style',
                  webSelector: '.flow-roster-remove',
                  type: DecoratedBox,
                  withinType: AppButton,
                  properties: [
                    ComparisonProperty.background,
                    ComparisonProperty.radius,
                    ComparisonProperty.borderWidth,
                  ],
                ),
              if (!desktop && state)
                const ComparisonControl.text(
                  id: 'remove-label',
                  webSelector: '.flow-roster-remove',
                  textRange: true,
                  value: 'Удалить',
                  properties: [
                    ComparisonProperty.width,
                    ComparisonProperty.fontSize,
                    ComparisonProperty.fontWeight,
                    ComparisonProperty.color,
                    ComparisonProperty.baseline,
                  ],
                ),
              if (desktop)
                const ComparisonControl.type(
                  id: 'trash',
                  webSelector: '.flow-roster-remove .icon',
                  type: CustomPaint,
                  index: 1,
                  properties: [ComparisonProperty.rect],
                ),
            ],
          ),
    ],
  );
}
