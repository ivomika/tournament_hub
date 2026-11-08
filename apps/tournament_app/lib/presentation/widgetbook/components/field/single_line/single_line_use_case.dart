import 'package:tournament_app/presentation/design_system/foundation/spacing/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';
import 'package:tournament_app/presentation/widgetbook/components/field/field_fixture.dart';

final fieldSingleLineUseCase = WidgetbookUseCase(
  name: 'single_line',
  builder: FieldSingleLineUseCase.build,
);

abstract final class FieldSingleLineUseCase {
  static Widget build(BuildContext context) => SingleChildScrollView(
    padding: EdgeInsets.all(Theme.of(context).extension<AppSpacing>()!.space16),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final sample in FieldSample.values)
          FieldFixture(kind: AppFieldKind.singleLine, sample: sample),
      ],
    ),
  );
}
