import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/identity_fixture.dart';

final longIdentityUseCase = WidgetbookUseCase(
  name: 'long',
  builder: LongIdentityUseCase.build,
);

abstract final class LongIdentityUseCase {
  static Widget build(BuildContext context) =>
      const IdentityFixture(participant: true, long: true);
}
