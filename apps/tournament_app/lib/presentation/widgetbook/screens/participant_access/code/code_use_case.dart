import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/participant_access/participant_access_fixture.dart';

final participantAccessCodeUseCase = WidgetbookUseCase(
  name: 'code',
  builder: ParticipantAccessCodeUseCase.build,
);

abstract final class ParticipantAccessCodeUseCase {
  static Widget build(BuildContext context) => KeyedSubtree(
    key: const ValueKey<Type>(ParticipantAccessCodeUseCase),
    child: ParticipantAccessFixture(),
  );
}
