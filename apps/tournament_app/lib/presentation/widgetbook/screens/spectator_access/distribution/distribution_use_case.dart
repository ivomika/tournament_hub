import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/spectator_access/spectator_access_fixture.dart';

final spectatorAccessDistributionUseCase = WidgetbookUseCase(
  name: 'distribution',
  builder: SpectatorAccessDistributionUseCase.build,
);

abstract final class SpectatorAccessDistributionUseCase {
  static Widget build(BuildContext context) =>
      SpectatorAccessFixture(address: false);
}
