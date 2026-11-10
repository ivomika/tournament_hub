import 'package:flutter/foundation.dart';

enum UtilityPhase { loading, error }

@immutable
class UtilityScreenState {
  const UtilityScreenState({
    required this.phase,
    this.title,
    this.heading,
    this.accent,
    this.note,
    this.progressLabel,
  });
  final UtilityPhase phase;
  final String? title, heading, accent, note, progressLabel;
}
