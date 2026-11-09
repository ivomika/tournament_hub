import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapErrorUseCase = WidgetbookUseCase(
  name: 'error',
  builder: BootstrapErrorUseCase.build,
);

abstract final class BootstrapErrorUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapErrorUseCase),
    child: BootstrapFixture(phase: BootstrapPhase.error),
  );
}
