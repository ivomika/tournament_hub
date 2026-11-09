import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/forfeit/forfeit_fixture.dart';

final forfeitConfirmationUseCase = WidgetbookUseCase(
  name: 'confirmation',
  builder: ForfeitConfirmationUseCase.build,
);

abstract final class ForfeitConfirmationUseCase {
  static Widget build(BuildContext context) => ForfeitFixture();
}
