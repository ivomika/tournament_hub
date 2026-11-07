import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/button_fixture.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/roster_fixture.dart';

class ResponsiveFixture extends StatelessWidget {
  const ResponsiveFixture({this.scaled = false, super.key});
  final bool scaled;
  @override
  Widget build(BuildContext context) => MediaQuery(
    data: MediaQuery.of(context).copyWith(
      textScaler: scaled ? const TextScaler.linear(1.6) : TextScaler.noScaling,
    ),
    child: AppSurface(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ButtonFixture(),
          const ButtonFixture(kind: AppButtonKind.icon),
          SizedBox(height: Theme.of(context).extension<AppSpacing>()!.space16),
          RosterFixture(long: scaled),
        ],
      ),
    ),
  );
}
