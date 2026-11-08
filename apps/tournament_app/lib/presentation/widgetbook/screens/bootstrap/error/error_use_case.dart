import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapErrorUseCase = WidgetbookUseCase(
  name: 'error',
  builder: BootstrapErrorUseCase.build,
);

abstract final class BootstrapErrorUseCase {
  static Widget build(BuildContext context) =>
      BootstrapFixture(phase: BootstrapPhase.error);
}
