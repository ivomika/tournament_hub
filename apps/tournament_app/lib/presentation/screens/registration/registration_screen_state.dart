import 'package:flutter/foundation.dart';

enum RegistrationPhase { editing, invalidName, saving, saveError, completed }

@immutable
final class RegistrationScreenState {
  const RegistrationScreenState({
    this.name = '',
    this.phase = RegistrationPhase.editing,
  });

  final String name;
  final RegistrationPhase phase;

  bool get busy =>
      phase == RegistrationPhase.saving || phase == RegistrationPhase.completed;
}
