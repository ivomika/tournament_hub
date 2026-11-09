import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/distribution/distribution_fixture.dart';

final distributionReadyUseCase = WidgetbookUseCase(
  name: 'ready',
  builder: DistributionReadyUseCase.build,
);

abstract final class DistributionReadyUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(DistributionReadyUseCase),
    child: DistributionFixture(phase: DistributionPhase.ready),
  );
}
