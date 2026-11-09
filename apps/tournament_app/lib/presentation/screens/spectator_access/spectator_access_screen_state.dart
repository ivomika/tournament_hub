import 'package:flutter/foundation.dart';

@immutable
class SpectatorAccessScreenState {
  const SpectatorAccessScreenState({
    required this.qrPayload,
    required this.note,
    required this.noteBelowCode,
    this.scanHint,
    this.address,
  });
  final String qrPayload, note;
  final bool noteBelowCode;
  final String? scanHint, address;
}
