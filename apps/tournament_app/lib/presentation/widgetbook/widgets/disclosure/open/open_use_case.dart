import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/disclosure/disclosure_fixture.dart';

final disclosureOpenUseCase = WidgetbookUseCase(
  name: 'open',
  builder: DisclosureOpenUseCase.build,
);

abstract final class DisclosureOpenUseCase {
  static Widget build(BuildContext context) =>
      const DisclosureFixture(open: true);
}
