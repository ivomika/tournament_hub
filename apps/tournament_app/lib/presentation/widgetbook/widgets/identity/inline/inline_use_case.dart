import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/identity_fixture.dart';

final inlineIdentityUseCase = WidgetbookUseCase(
  name: 'inline',
  builder: InlineIdentityUseCase.build,
);

abstract final class InlineIdentityUseCase {
  static Widget build(BuildContext context) => const IdentityFixture();
}
