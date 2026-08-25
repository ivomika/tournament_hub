import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/core/networking/spectator_envelope.dart';

void main() {
  test('читает общую Round Robin fixture protocol v1', () async {
    final source = await File(
      '../../docs/protocol/fixtures/spectator-round-robin-active-v1.json',
    ).readAsString();

    final envelope = SpectatorEnvelope.decode(source);

    expect(envelope.tournamentId, 'fixture-round-robin');
    expect(envelope.revision, 3);
    expect(envelope.payload['format'], 'roundRobin');
    expect(
      SpectatorEnvelope.decode(envelope.encode()).payload,
      envelope.payload,
    );
  });

  test('отклоняет несовместимую версию', () {
    expect(
      () => SpectatorEnvelope.fromJson({
        'protocolVersion': 2,
        'messageType': 'snapshot',
        'tournamentId': 'id',
        'revision': 1,
        'payload': <String, Object?>{},
      }),
      throwsFormatException,
    );
  });
}
