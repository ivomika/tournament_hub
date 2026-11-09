import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/guest_add/guest_add_fixture.dart';

final guestAddNameUseCase = WidgetbookUseCase(
  name: 'name',
  builder: GuestAddNameUseCase.build,
);

abstract final class GuestAddNameUseCase {
  static Widget build(BuildContext context) => GuestAddFixture();
}
