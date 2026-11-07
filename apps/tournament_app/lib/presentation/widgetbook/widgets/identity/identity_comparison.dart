import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/identity_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/comparison/comparison_spec.dart';
import 'package:tournament_app/presentation/widgetbook/visual_viewport.dart';

abstract final class IdentityComparison {
  static final spec = ComparisonSpec(
    component: 'identity',
    title: 'AppIdentity',
    geometryTolerance: 0.5,
    goldenDirectory: 'lib/presentation/design_system/widgets/identity/golden',
    baselineTolerance: 1,
    scenarios: [
      for (final viewport in VisualViewport.values)
        for (final layout in AppIdentityLayout.values)
          ComparisonScenario(
            id: '${viewport.name}-${layout.name}',
            title: '${viewport.name} · ${layout.name}',
            viewport: viewport,
            webSelector: layout == AppIdentityLayout.inline
                ? '#c-avatar .kit-avatar-size-64 .flow-person'
                : '#c-avatar .kit-avatar-size-112 .flow-fighter',
            builder: (context) => IdentityFixture(layout: layout),
            controls: [
              const ComparisonControl.type(
                id: 'avatar',
                webSelector: '.flow-avatar',
                type: AppAvatar,
                properties: [ComparisonProperty.rect],
              ),
              const ComparisonControl.text(
                id: 'primary',
                webSelector: 'strong',
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
              ComparisonControl.text(
                id: 'secondary',
                webSelector: layout == AppIdentityLayout.inline
                    ? 'small'
                    : 'span:last-child',
                value: 'Участник турнира',
                properties: const [
                  ComparisonProperty.rect,
                  ComparisonProperty.fontSize,
                  ComparisonProperty.color,
                  ComparisonProperty.baseline,
                ],
              ),
            ],
          ),
    ],
  );
}
