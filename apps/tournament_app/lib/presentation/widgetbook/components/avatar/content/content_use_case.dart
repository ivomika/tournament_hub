import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/theme_extensions.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/avatar_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/foundation_scenario_host.dart';

final avatarContentUseCase = WidgetbookUseCase(
  name: 'Данные · пусто, SZ, цвет',
  builder: AvatarContentUseCase.build,
);

abstract final class AvatarContentUseCase {
  static Widget build(BuildContext context) =>
      const FoundationScenarioHost(child: _AvatarContent());
}

class _AvatarContent extends StatelessWidget {
  const _AvatarContent();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = ThemeExtensions.require<AppSpacing>(theme);
    return Padding(
      padding: EdgeInsets.all(spacing.space24),
      child: Wrap(
        spacing: spacing.space24,
        runSpacing: spacing.space24,
        children: [
          const AvatarFixture(
            size: AppAvatarSize.large,
            shape: AppAvatarShape.tile,
            initials: '',
          ),
          const AvatarFixture(
            size: AppAvatarSize.large,
            shape: AppAvatarShape.tile,
            initials: 'SZ',
          ),
          AvatarFixture(
            size: AppAvatarSize.large,
            shape: AppAvatarShape.tile,
            initials: 'SZ',
            foreground: theme.colorScheme.secondary,
          ),
        ],
      ),
    );
  }
}
