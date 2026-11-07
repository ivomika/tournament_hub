import 'package:tournament_app/presentation/design_system/foundation/responsive/app_avatar_metrics.dart';
import 'package:tournament_app/presentation/design_system/foundation/responsive/app_responsive.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/avatar_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class AvatarComparison {
  static final spec = ComparisonSpec(
    component: 'avatar',
    title: 'Avatar',
    baselineTolerance: 1,
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final (size, extent) in [
          (AppAvatarSize.extraSmall, 28),
          (AppAvatarSize.small, 40),
          (AppAvatarSize.medium, 48),
          (AppAvatarSize.large, 64),
          (AppAvatarSize.profile, 96),
          (AppAvatarSize.portrait, 112),
          (AppAvatarSize.hero, 128),
        ])
          for (final shape in AppAvatarShape.values)
            ComparisonScenario(
              id: '${viewport.name}-$extent-${shape.name}',
              title: '${viewport.name} · $extent · ${shape.name}',
              viewport: viewport,
              goldenId: '${extent}_${shape.name}',
              webSelector:
                  '#c-avatar .kit-avatar-size-$extent ${shape == AppAvatarShape.round ? '.profile-monogram' : '.flow-avatar'}',
              builder: (context) => AvatarFixture(size: size, shape: shape),
              controls: const [
                ComparisonControl.type(
                  id: 'frame',
                  webSelector: ':scope',
                  type: DecoratedBox,
                  properties: [
                    ComparisonProperty.rect,
                    ComparisonProperty.background,
                    ComparisonProperty.radius,
                    ComparisonProperty.borderWidth,
                  ],
                ),
                ComparisonControl.text(
                  id: 'initials',
                  webSelector: ':scope',
                  value: 'И',
                  properties: [
                    ComparisonProperty.center,
                    ComparisonProperty.fontSize,
                    ComparisonProperty.fontWeight,
                    ComparisonProperty.color,
                    ComparisonProperty.baseline,
                  ],
                ),
              ],
            ),
      ComparisonScenario(
        id: 'control-text-shift',
        title: 'Контроль · намеренно смещены инициалы',
        viewport: VisualViewport.mobile,
        webSelector: '#c-avatar .kit-avatar-size-64 .flow-avatar',
        builder: _control,
        theme: _shiftedTheme,
        expectedFailure: const ComparisonExpectedFailure(
          controlId: 'initials',
          property: 'center.y',
        ),
        controls: const [
          ComparisonControl.text(
            id: 'initials',
            webSelector: ':scope',
            value: 'И',
            properties: [
              ComparisonProperty.center,
              ComparisonProperty.fontSize,
              ComparisonProperty.color,
              ComparisonProperty.baseline,
            ],
          ),
        ],
      ),
    ],
  );
  static Widget _control(BuildContext context) => const AvatarFixture(
    size: AppAvatarSize.large,
    shape: AppAvatarShape.tile,
  );
  static ThemeData _shiftedTheme(ThemeData theme) {
    final metrics = theme.extension<AppAvatarMetrics>()!;
    final spacing = theme.extension<AppSpacing>()!;
    final responsive = theme.extension<AppResponsive>()!;
    return theme.copyWith(
      extensions: [
        ...theme.extensions.values.where((e) => e is! AppAvatarMetrics),
        metrics.copyWith(
          contentAlignment: Alignment(
            metrics.contentAlignment.x,
            metrics.contentAlignment.y +
                spacing.space16 / responsive.avatarLarge,
          ),
        ),
      ],
    );
  }
}
