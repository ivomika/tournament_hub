import 'package:flutter/foundation.dart';

enum ProfileEditPhase {
  editing,
  invalidName,
  saving,
  saveError,
  navigationError,
  completed,
}

@immutable
class ProfileEditScreenState {
  const ProfileEditScreenState({required this.phase, this.name = ''});

  final ProfileEditPhase phase;
  final String name;

  bool get busy =>
      phase == ProfileEditPhase.saving || phase == ProfileEditPhase.completed;
}
