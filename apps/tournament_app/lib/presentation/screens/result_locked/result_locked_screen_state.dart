import 'package:flutter/foundation.dart';

@immutable
class ResultLockedScreenState {
  const ResultLockedScreenState({
    required this.title,
    required this.matchLabel,
    required this.pairingLabel,
    required this.reason,
  });
  final String title, matchLabel, pairingLabel, reason;
}
