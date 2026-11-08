import 'package:flutter/foundation.dart';

enum BootstrapPhase { loading, error, retrying }

@immutable
class BootstrapScreenState {
  const BootstrapScreenState({required this.phase});
  final BootstrapPhase phase;
}
