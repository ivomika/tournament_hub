import 'dart:convert';

import 'package:equatable/equatable.dart';

final class PersistedTournamentEvent extends Equatable {
  PersistedTournamentEvent({
    required this.eventId,
    required this.tournamentId,
    required this.sequence,
    required this.revision,
    required this.eventVersion,
    required this.type,
    required this.timestampUtc,
    required Map<String, Object?> payload,
  }) : payload = Map.unmodifiable(payload) {
    if (eventId.trim().isEmpty || sequence < 1 || revision < 0) {
      throw const FormatException('Invalid persisted tournament event.');
    }
  }

  final String eventId;
  final String tournamentId;
  final int sequence;
  final int revision;
  final int eventVersion;
  final String type;
  final DateTime timestampUtc;
  final Map<String, Object?> payload;

  String encodePayload() => jsonEncode(payload);

  @override
  List<Object?> get props => [
    eventId,
    tournamentId,
    sequence,
    revision,
    eventVersion,
    type,
    timestampUtc,
    payload,
  ];
}
