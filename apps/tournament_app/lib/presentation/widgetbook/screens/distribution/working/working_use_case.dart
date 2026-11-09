import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/distribution/distribution_fixture.dart';

final distributionWorkingUseCase = WidgetbookUseCase(
  name: 'working',
  builder: DistributionWorkingUseCase.build,
);

abstract final class DistributionWorkingUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(DistributionWorkingUseCase),
    child: DistributionFixture(phase: DistributionPhase.working),
  );
}
