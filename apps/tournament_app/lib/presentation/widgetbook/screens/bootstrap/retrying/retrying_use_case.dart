import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapRetryingUseCase = WidgetbookUseCase(
  name: 'retrying',
  builder: BootstrapRetryingUseCase.build,
);

abstract final class BootstrapRetryingUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapRetryingUseCase),
    child: BootstrapFixture(phase: BootstrapPhase.retrying),
  );
}
