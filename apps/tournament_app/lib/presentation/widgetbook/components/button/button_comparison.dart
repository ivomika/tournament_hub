import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/button_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class ButtonComparison {
  static final spec = ComparisonSpec(
    component: 'button',
    title: 'AppButton',
    baselineTolerance: 1,
    scenarios: [
      ComparisonScenario(
        capturePadding: 12,
        id: 'primary-default',
        title: 'primary · default',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(1) .kit-component-states .kit-specimen:nth-child(1) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.primary, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Продолжить',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'primary-hovered',
        title: 'primary · hovered',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(1) .kit-component-states .kit-specimen:nth-child(2) button',
        builder: (context) => const ButtonFixture(
          kind: AppButtonKind.primary,
          state: WidgetState.hovered,
        ),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Продолжить',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'primary-pressed',
        title: 'primary · pressed',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(1) .kit-component-states .kit-specimen:nth-child(3) button',
        builder: (context) => const ButtonFixture(
          kind: AppButtonKind.primary,
          state: WidgetState.pressed,
        ),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Продолжить',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'primary-focused',
        title: 'primary · focused',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(1) .kit-component-states .kit-specimen:nth-child(4) button',
        builder: (context) => const ButtonFixture(
          kind: AppButtonKind.primary,
          state: WidgetState.focused,
        ),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Продолжить',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'primary-disabled',
        title: 'primary · disabled',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(1) .kit-component-states .kit-specimen:nth-child(5) button',
        builder: (context) => const ButtonFixture(
          kind: AppButtonKind.primary,
          state: WidgetState.disabled,
        ),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Продолжить',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'primary-mobile',
        title: 'primary · mobile',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(1) .kit-adaptation .kit-specimen:nth-of-type(1) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.primary, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Продолжить',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'primary-desktop',
        title: 'primary · desktop',
        viewport: VisualViewport.desktop,
        webSelector: '#c-button .kit-component:nth-child(1) .kit-adaptation .kit-specimen:nth-of-type(2) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.primary, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Продолжить',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'secondary-default',
        title: 'secondary · default',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(2) .kit-component-states .kit-specimen:nth-child(1) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.secondary, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Отмена',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'secondary-hovered',
        title: 'secondary · hovered',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(2) .kit-component-states .kit-specimen:nth-child(2) button',
        builder: (context) => const ButtonFixture(
          kind: AppButtonKind.secondary,
          state: WidgetState.hovered,
        ),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Отмена',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'secondary-focused',
        title: 'secondary · focused',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(2) .kit-component-states .kit-specimen:nth-child(3) button',
        builder: (context) => const ButtonFixture(
          kind: AppButtonKind.secondary,
          state: WidgetState.focused,
        ),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Отмена',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'secondary-mobile',
        title: 'secondary · mobile',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(2) .kit-adaptation .kit-specimen:nth-of-type(1) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.secondary, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Отмена',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'secondary-desktop',
        title: 'secondary · desktop',
        viewport: VisualViewport.desktop,
        webSelector: '#c-button .kit-component:nth-child(2) .kit-adaptation .kit-specimen:nth-of-type(2) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.secondary, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Отмена',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'destructive-default',
        title: 'destructive · default',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(3) .kit-component-states .kit-specimen:nth-child(1) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.destructive, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Снять участника',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'destructive-focused',
        title: 'destructive · focused',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(3) .kit-component-states .kit-specimen:nth-child(2) button',
        builder: (context) => const ButtonFixture(
          kind: AppButtonKind.destructive,
          state: WidgetState.focused,
        ),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Снять участника',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'destructive-mobile',
        title: 'destructive · mobile',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(3) .kit-adaptation .kit-specimen:nth-of-type(1) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.destructive, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Снять участника',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'destructive-desktop',
        title: 'destructive · desktop',
        viewport: VisualViewport.desktop,
        webSelector: '#c-button .kit-component:nth-child(3) .kit-adaptation .kit-specimen:nth-of-type(2) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.destructive, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.text(
            id: 'label',
            webSelector: ':scope',
            textRange: true,
            value: 'Снять участника',
            properties: [
              ComparisonProperty.width,
              ComparisonProperty.fontSize,
              ComparisonProperty.fontWeight,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'icon-default',
        title: 'icon · default',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(4) .kit-component-states .kit-specimen:nth-child(1) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.icon, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'icon-hovered',
        title: 'icon · hovered',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(4) .kit-component-states .kit-specimen:nth-child(2) button',
        builder: (context) => const ButtonFixture(
          kind: AppButtonKind.icon,
          state: WidgetState.hovered,
        ),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'icon-focused',
        title: 'icon · focused',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(4) .kit-component-states .kit-specimen:nth-child(3) button',
        builder: (context) => const ButtonFixture(
          kind: AppButtonKind.icon,
          state: WidgetState.focused,
        ),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'icon-mobile',
        title: 'icon · mobile',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(4) .kit-adaptation .kit-specimen:nth-of-type(1) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.icon, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'icon-desktop',
        title: 'icon · desktop',
        viewport: VisualViewport.desktop,
        webSelector: '#c-button .kit-component:nth-child(4) .kit-adaptation .kit-specimen:nth-of-type(2) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.icon, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'accenticon-default',
        title: 'accentIcon · default',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(5) .kit-component-states .kit-specimen:nth-child(1) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.accentIcon, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'accenticon-focused',
        title: 'accentIcon · focused',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(5) .kit-component-states .kit-specimen:nth-child(2) button',
        builder: (context) => const ButtonFixture(
          kind: AppButtonKind.accentIcon,
          state: WidgetState.focused,
        ),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'accenticon-mobile',
        title: 'accentIcon · mobile',
        viewport: VisualViewport.mobile,
        webSelector: '#c-button .kit-component:nth-child(5) .kit-adaptation .kit-specimen:nth-of-type(1) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.accentIcon, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
      ComparisonScenario(
        capturePadding: 12,
        id: 'accenticon-desktop',
        title: 'accentIcon · desktop',
        viewport: VisualViewport.desktop,
        webSelector: '#c-button .kit-component:nth-child(5) .kit-adaptation .kit-specimen:nth-of-type(2) button',
        builder: (context) =>
            const ButtonFixture(kind: AppButtonKind.accentIcon, state: null),
        controls: [
          const ComparisonControl.type(
            id: 'shell',
            webSelector: ':scope',
            type: DecoratedBox,
            properties: [
              ComparisonProperty.rect,
              ComparisonProperty.background,
              ComparisonProperty.radius,
            ],
          ),
          const ComparisonControl.type(
            id: 'icon',
            webSelector: '.icon',
            type: CustomPaint,
            index: 1,
            properties: [ComparisonProperty.rect],
          ),
        ],
      ),
    ],
  );
}
