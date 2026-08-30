import 'dart:convert';

import 'package:equatable/equatable.dart';

final class PersistedCommandResult extends Equatable {
  PersistedCommandResult({
    required this.commandId,
    required this.tournamentId,
    required this.revision,
    required Map<String, Object?> payload,
  }) : payload = Map.unmodifiable(payload);

  final String commandId;
  final String tournamentId;
  final int revision;
  final Map<String, Object?> payload;

  String encodePayload() => jsonEncode(payload);

  @override
  List<Object?> get props => [commandId, tournamentId, revision, payload];
}
