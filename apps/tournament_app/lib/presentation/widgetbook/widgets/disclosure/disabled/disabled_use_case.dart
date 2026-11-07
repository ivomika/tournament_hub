import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/disclosure/disclosure_fixture.dart';

final disclosureDisabledUseCase = WidgetbookUseCase(
  name: 'disabled',
  builder: DisclosureDisabledUseCase.build,
);

abstract final class DisclosureDisabledUseCase {
  static Widget build(BuildContext context) =>
      const DisclosureFixture(disabled: true);
}
