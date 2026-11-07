import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/app_theme_colors.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/borders/app_border_metrics.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class ColorsComparison {
  static final spec = ComparisonSpec(
    component: 'colors',
    title: 'Foundation Colors',
    goldenDirectory:
        'lib/presentation/design_system/foundation/colors/palette/golden',
    scenarios: [
      for (final viewport in VisualViewport.values) ...[
        ComparisonScenario(
          id: '${viewport.name}-canvas',
          title: '${viewport.name} · canvas',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--background)"]',
          builder: _background,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-surface',
          title: '${viewport.name} · surface',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--surface)"]',
          builder: _surface,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-raised',
          title: '${viewport.name} · raised',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--raised)"]',
          builder: _surfaceRaised,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-border',
          title: '${viewport.name} · border',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--border)"]',
          builder: _border,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-ink',
          title: '${viewport.name} · ink',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--ink)"]',
          builder: _textPrimary,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-secondary',
          title: '${viewport.name} · secondary',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--secondary)"]',
          builder: _textSecondary,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-muted',
          title: '${viewport.name} · muted',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--muted)"]',
          builder: _textMuted,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-accent',
          title: '${viewport.name} · accent',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--gold)"]',
          builder: _accent,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-on-accent',
          title: '${viewport.name} · on-accent',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--on-gold)"]',
          builder: _onAccent,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-pressed',
          title: '${viewport.name} · pressed',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--pressed)"]',
          builder: _accentPressed,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-focus',
          title: '${viewport.name} · focus',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--focus)"]',
          builder: _focus,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-danger',
          title: '${viewport.name} · danger',
          viewport: viewport,
          webSelector:
              '#colors .kit-color-swatch[style="background:var(--danger)"]',
          builder: _danger,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-danger-surface',
          title: '${viewport.name} · danger-surface',
          viewport: viewport,
          webSelector: '#colors .kit-color-swatch[style="background:var(--danger-surface)"]',
          builder: _dangerContainer,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-ice',
          title: '${viewport.name} · ice',
          viewport: viewport,
          webSelector: '#colors .kit-color-swatch[style="background:var(--character-ice)"]',
          builder: _characterIce,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-fan',
          title: '${viewport.name} · fan',
          viewport: viewport,
          webSelector: '#colors .kit-color-swatch[style="background:var(--character-fan)"]',
          builder: _characterFan,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
        ComparisonScenario(
          id: '${viewport.name}-storm',
          title: '${viewport.name} · storm',
          viewport: viewport,
          webSelector: '#colors .kit-color-swatch[style="background:var(--character-storm)"]',
          builder: _characterStorm,
          controls: const [
            ComparisonControl.type(
              id: 'swatch',
              webSelector: ':scope',
              type: DecoratedBox,
              properties: [
                ComparisonProperty.rect,
                ComparisonProperty.background,
              ],
            ),
          ],
        ),
      ],
    ],
  );
  static Widget _background(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).background);
  static Widget _surface(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).surface);
  static Widget _surfaceRaised(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).surfaceRaised);
  static Widget _border(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).border);
  static Widget _textPrimary(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).textPrimary);
  static Widget _textSecondary(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).textSecondary);
  static Widget _textMuted(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).textMuted);
  static Widget _accent(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).accent);
  static Widget _onAccent(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).onAccent);
  static Widget _accentPressed(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).accentPressed);
  static Widget _focus(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).focus);
  static Widget _danger(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).danger);
  static Widget _dangerContainer(BuildContext context) => ColorRoleFixture(
    value: AppThemeColors(Theme.of(context)).dangerContainer,
  );
  static Widget _characterIce(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).characterIce);
  static Widget _characterFan(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).characterFan);
  static Widget _characterStorm(BuildContext context) =>
      ColorRoleFixture(value: AppThemeColors(Theme.of(context)).characterStorm);
}

class ColorRoleFixture extends StatelessWidget {
  const ColorRoleFixture({required this.value, super.key});
  final Color value;
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context), s = t.extension<AppSpacing>()!;
    return SizedBox(
      width: t.extension<FoundationLayout>()!.fullWidth,
      height: s.space64 + s.space24,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: value,
          border: Border(
            bottom: BorderSide(
              color: t.colorScheme.outlineVariant,
              width: t.extension<AppBorderMetrics>()!.hairline,
            ),
          ),
        ),
      ),
    );
  }
}
