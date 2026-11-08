import 'package:flutter/foundation.dart';

@immutable
class ParticipantAccessScreenState {
  const ParticipantAccessScreenState({
    required this.qrPayload,
    required this.code,
  });
  final String qrPayload, code;
}
