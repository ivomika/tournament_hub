import 'dart:convert';

final class SpectatorEnvelope {
  SpectatorEnvelope({
    required this.tournamentId,
    required this.revision,
    required Map<String, Object?> payload,
  }) : payload = Map.unmodifiable(payload) {
    if (tournamentId.trim().isEmpty || revision < 1) {
      throw const FormatException('Некорректный spectator envelope.');
    }
    _validatePayload(this.payload);
  }

  factory SpectatorEnvelope.fromJson(Map<String, dynamic> json) {
    if (json['protocolVersion'] != protocolVersion ||
        json['messageType'] != messageType ||
        json['tournamentId'] is! String ||
        json['revision'] is! int ||
        json['payload'] is! Map<String, dynamic>) {
      throw const FormatException(
        'Сообщение не соответствует spectator protocol v1.',
      );
    }
    return SpectatorEnvelope(
      tournamentId: json['tournamentId'] as String,
      revision: json['revision'] as int,
      payload: Map<String, Object?>.from(
        json['payload'] as Map<String, dynamic>,
      ),
    );
  }

  factory SpectatorEnvelope.decode(String source) {
    final value = jsonDecode(source);
    if (value is! Map<String, dynamic>) {
      throw const FormatException('Spectator envelope должен быть объектом.');
    }
    return SpectatorEnvelope.fromJson(value);
  }

  static const protocolVersion = 1;
  static const messageType = 'snapshot';

  final String tournamentId;
  final int revision;
  final Map<String, Object?> payload;

  Map<String, Object?> toJson() => {
    'protocolVersion': protocolVersion,
    'messageType': messageType,
    'tournamentId': tournamentId,
    'revision': revision,
    'payload': payload,
  };

  String encode() => jsonEncode(toJson());

  static void _validatePayload(Map<String, Object?> payload) {
    if (!const {'active', 'finished'}.contains(payload['state']) ||
        !const {
          'roundRobin',
          'doubleElimination',
        }.contains(payload['format']) ||
        payload['name'] is! String ||
        payload['participants'] is! List<Object?>) {
      throw const FormatException(
        'Spectator payload не содержит обязательные поля.',
      );
    }
    final format = payload['format'];
    if ((format == 'roundRobin' && payload['roundRobin'] is! Map) ||
        (format == 'doubleElimination' &&
            payload['doubleElimination'] is! Map)) {
      throw const FormatException(
        'Spectator payload не содержит projection выбранного формата.',
      );
    }
  }
}
