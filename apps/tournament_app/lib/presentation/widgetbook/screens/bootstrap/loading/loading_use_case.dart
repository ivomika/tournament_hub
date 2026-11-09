import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/bootstrap_fixture.dart';

final bootstrapLoadingUseCase = WidgetbookUseCase(
  name: 'loading',
  builder: BootstrapLoadingUseCase.build,
);

abstract final class BootstrapLoadingUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(BootstrapLoadingUseCase),
    child: BootstrapFixture(phase: BootstrapPhase.loading),
  );
}
