import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/disclosure/disclosure_fixture.dart';

final disclosureClosedUseCase = WidgetbookUseCase(
  name: 'closed',
  builder: DisclosureClosedUseCase.build,
);

abstract final class DisclosureClosedUseCase {
  static Widget build(BuildContext context) => const DisclosureFixture();
}
