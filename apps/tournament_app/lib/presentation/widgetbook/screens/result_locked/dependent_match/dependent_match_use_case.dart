import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/result_locked/result_locked_fixture.dart';

final resultLockedDependentMatchUseCase = WidgetbookUseCase(
  name: 'dependent_match',
  builder: ResultLockedDependentMatchUseCase.build,
);

abstract final class ResultLockedDependentMatchUseCase {
  static Widget build(BuildContext context) => ResultLockedFixture();
}
