import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

final spacingApplicationUseCase = WidgetbookUseCase(
  name: 'Inset / identity gap',
  builder: SpacingApplicationUseCase.build,
);

abstract final class SpacingApplicationUseCase {
  static Widget build(BuildContext context) =>
      const SpacingApplicationFixture();
}

class SpacingApplicationFixture extends StatelessWidget {
  const SpacingApplicationFixture({super.key});
  @override
  Widget build(BuildContext context) => AppSurface(
    child: AppIdentity(
      primary: 'Иван',
      initials: 'И',
      secondary: FoundationLocalizations.of(context).participantDescription,
    ),
  );
}
