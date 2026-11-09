import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/guest_remove/guest_remove_fixture.dart';

final guestRemoveConfirmationUseCase = WidgetbookUseCase(
  name: 'confirmation',
  builder: GuestRemoveConfirmationUseCase.build,
);

abstract final class GuestRemoveConfirmationUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(GuestRemoveConfirmationUseCase),
    child: GuestRemoveFixture(),
  );
}
