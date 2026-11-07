import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/avatar_fixture.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/theme_extensions.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/foundation_scenario_host.dart';

class AvatarPreview extends StatelessWidget {
  const AvatarPreview({required this.size, super.key});
  final AppAvatarSize size;
  @override
  Widget build(BuildContext context) =>
      FoundationScenarioHost(child: _AvatarPair(size: size));
}

class _AvatarPair extends StatelessWidget {
  const _AvatarPair({required this.size});
  final AppAvatarSize size;
  @override
  Widget build(BuildContext context) {
    final spacing = ThemeExtensions.require<AppSpacing>(Theme.of(context));
    return Padding(
      padding: EdgeInsets.all(spacing.space24),
      child: Wrap(
        spacing: spacing.space24,
        runSpacing: spacing.space24,
        children: [
          for (final shape in AppAvatarShape.values)
            AvatarFixture(size: size, shape: shape),
        ],
      ),
    );
  }
}
