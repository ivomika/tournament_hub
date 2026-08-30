import 'dart:convert';

import 'package:equatable/equatable.dart';

final class PersistedTournamentSnapshot extends Equatable {
  PersistedTournamentSnapshot({
    required this.schemaVersion,
    required this.tournamentId,
    required this.revision,
    required this.formatId,
    required this.rulesetVersion,
    required this.lifecycle,
    required this.createdAtUtc,
    required this.updatedAtUtc,
    required Map<String, Object?> payload,
  }) : payload = Map.unmodifiable(payload) {
    if (schemaVersion < 1 || revision < 0 || tournamentId.trim().isEmpty) {
      throw const FormatException('Invalid persisted tournament snapshot.');
    }
  }

  final int schemaVersion;
  final String tournamentId;
  final int revision;
  final String formatId;
  final int rulesetVersion;
  final String lifecycle;
  final DateTime createdAtUtc;
  final DateTime updatedAtUtc;
  final Map<String, Object?> payload;

  String encodePayload() => jsonEncode(payload);

  static Map<String, Object?> decodePayload(String source) {
    final decoded = jsonDecode(source);
    if (decoded is! Map<String, Object?>) {
      throw const FormatException('Snapshot payload must be a JSON object.');
    }
    return decoded;
  }

  @override
  List<Object?> get props => [
    schemaVersion,
    tournamentId,
    revision,
    formatId,
    rulesetVersion,
    lifecycle,
    createdAtUtc,
    updatedAtUtc,
    payload,
  ];
}
