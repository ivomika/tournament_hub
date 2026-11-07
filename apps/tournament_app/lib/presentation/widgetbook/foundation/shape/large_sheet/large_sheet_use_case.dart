import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/shape/sheet/sheet_use_case.dart';

final shapeLargeSheetUseCase = WidgetbookUseCase(
  name: 'Sheet / upper corners32',
  builder: ShapeLargeSheetUseCase.build,
);

abstract final class ShapeLargeSheetUseCase {
  static Widget build(BuildContext context) =>
      const ShapeSheetFixture(large: true);
}
