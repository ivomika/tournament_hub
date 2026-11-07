import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/button_fixture.dart';
import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';

final contentButtonUseCase = WidgetbookUseCase(
  name: 'Content / long label',
  builder: ContentButtonUseCase.build,
);

abstract final class ContentButtonUseCase {
  static Widget build(BuildContext context) => const ContentButtonFixture();
}

class ContentButtonFixture extends StatelessWidget {
  const ContentButtonFixture({super.key});
  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      const ButtonFixture(fill: false),
      SizedBox(height: Theme.of(context).extension<AppSpacing>()!.space24),
      const ButtonFixture(long: true),
    ],
  );
}
