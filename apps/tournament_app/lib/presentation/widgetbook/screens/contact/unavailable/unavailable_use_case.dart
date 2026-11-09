import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/contact/contact_fixture.dart';

final contactUnavailableUseCase = WidgetbookUseCase(
  name: 'unavailable',
  builder: ContactUnavailableUseCase.build,
);

abstract final class ContactUnavailableUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ContactUnavailableUseCase),
    child: ContactFixture(),
  );
}
