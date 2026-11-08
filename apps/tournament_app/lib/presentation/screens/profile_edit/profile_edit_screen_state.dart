import 'package:flutter/foundation.dart';

enum ProfileEditPhase { editing, saveError }

@immutable
class ProfileEditScreenState {
  const ProfileEditScreenState({required this.phase});
  final ProfileEditPhase phase;
}
