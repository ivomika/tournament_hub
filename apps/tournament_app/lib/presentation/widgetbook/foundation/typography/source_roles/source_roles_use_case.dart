import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/typography/typography_comparison.dart';

final sourceTypographyUseCase = WidgetbookUseCase(
  name: 'Source roles / comparison',
  builder: SourceTypographyUseCase.build,
);

abstract final class SourceTypographyUseCase {
  static Widget build(BuildContext context) => ListView(
    children: [
      for (final role in SourceTextRole.values) SourceTextFixture(role: role),
    ],
  );
}
