import 'package:flutter/foundation.dart';

enum UtilityPhase { loading, error }

@immutable
class UtilityScreenState {
  const UtilityScreenState({required this.phase});
  final UtilityPhase phase;
}
