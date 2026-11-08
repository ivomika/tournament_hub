import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';
import 'package:tournament_app/presentation/widgetbook/components/field/field_fixture.dart';

final fieldMultilineUseCase = WidgetbookUseCase(
  name: 'multiline',
  builder: FieldMultilineUseCase.build,
);

abstract final class FieldMultilineUseCase {
  static Widget build(BuildContext context) => SingleChildScrollView(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final sample in FieldSample.values)
          FieldFixture(kind: AppFieldKind.multiline, sample: sample),
      ],
    ),
  );
}
