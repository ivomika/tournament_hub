import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/identity_fixture.dart';

final participantIdentityUseCase = WidgetbookUseCase(
  name: 'participant',
  builder: ParticipantIdentityUseCase.build,
);

abstract final class ParticipantIdentityUseCase {
  static Widget build(BuildContext context) =>
      const IdentityFixture(participant: true);
}
