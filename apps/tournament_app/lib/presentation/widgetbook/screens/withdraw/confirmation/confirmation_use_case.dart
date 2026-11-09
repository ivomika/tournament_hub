import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/withdraw/withdraw_fixture.dart';

final withdrawConfirmationUseCase = WidgetbookUseCase(
  name: 'confirmation',
  builder: WithdrawConfirmationUseCase.build,
);

abstract final class WithdrawConfirmationUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(WithdrawConfirmationUseCase),
    child: WithdrawFixture(),
  );
}
