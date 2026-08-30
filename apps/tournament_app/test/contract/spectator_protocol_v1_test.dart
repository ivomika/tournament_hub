import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  final root = Directory.current.parent.parent;
  final fixtureFile = File(
    '${root.path}/docs/data/fixtures/spectator-protocol-v1.json',
  );
  final schemaFile = File(
    '${root.path}/docs/data/schemas/spectator-projection-v1.schema.json',
  );

  test('synthetic fixture соответствует closed public allowlist', () {
    final fixture = _object(jsonDecode(fixtureFile.readAsStringSync()));
    final schema = _object(jsonDecode(schemaFile.readAsStringSync()));
    final snapshot = _object(fixture['snapshot']);
    final allowed = _object(schema['properties']).keys.toSet();

    expect(snapshot.keys.toSet().difference(allowed), isEmpty);
    expect(jsonDecode(jsonEncode(snapshot)), snapshot);
    expect(snapshot['snapshotVersion'], 1);
    expect(_forbiddenKeys(snapshot), isEmpty);
    expect(_object(snapshot['tournament'])['lifecycle'], isNot('cancelled'));
    expect(_forbiddenKeys({...snapshot, 'profileId': 'private'}), {
      'profileId',
    });
    final event = _object(fixture['event']);
    expect(event['type'], 'spectator.projection.replaced');
    expect(_object(_object(event['payload'])['projection'])['sequence'], 7);
  });

  test(
    'handshake strict validation rejects mutation malformed and oversized',
    () {
      final fixture = _object(jsonDecode(fixtureFile.readAsStringSync()));
      expect(_validateHandshake(jsonEncode(fixture['handshake'])), isTrue);
      expect(
        _validateHandshake(
          jsonEncode({
            'category': 'request',
            'type': 'tournament.finish',
            'protocolVersion': 1,
            'payload': <String, Object?>{},
          }),
        ),
        isFalse,
      );
      expect(
        _validateHandshake(
          jsonEncode({..._object(fixture['handshake']), 'unknown': true}),
        ),
        isFalse,
      );
      expect(
        _validateHandshake(List.filled(16 * 1024 + 1, 'x').join()),
        isFalse,
      );
    },
  );

  test('replace reducer ignores duplicate and requires snapshot on gap', () {
    final reducer = _SpectatorReducer();
    expect(reducer.apply(sequence: 1), _ApplyResult.applied);
    expect(reducer.apply(sequence: 1), _ApplyResult.ignoredDuplicate);
    expect(reducer.apply(sequence: 3), _ApplyResult.gap);
    expect(reducer.lastSequence, 1);
    reducer.replaceFromSnapshot(sequence: 7);
    expect(reducer.lastSequence, 7);
    expect(reducer.apply(sequence: 8), _ApplyResult.applied);
  });
}

bool _validateHandshake(String source) {
  if (utf8.encode(source).length > 16 * 1024) return false;
  try {
    final decoded = jsonDecode(source);
    if (_depth(decoded) > 8) return false;
    final value = _object(decoded);
    if (value.keys.toSet().difference({
      'category',
      'type',
      'protocolVersion',
      'payload',
    }).isNotEmpty) {
      return false;
    }
    final payload = _object(value['payload']);
    return value['category'] == 'handshake' &&
        value['type'] == 'handshake.client' &&
        value['protocolVersion'] == 1 &&
        payload.keys.toSet().difference({
          'clientType',
          'tournamentId',
          'lastSequence',
        }).isEmpty &&
        payload['clientType'] == 'spectator' &&
        payload['tournamentId'] is String &&
        payload['lastSequence'] is int;
  } on Object {
    return false;
  }
}

Set<String> _forbiddenKeys(Object? value) {
  const forbidden = {
    'profileId',
    'localProfileId',
    'settings',
    'history',
    'endpoint',
    'address',
    'diagnostics',
    'stackTrace',
    'commandId',
  };
  final found = <String>{};
  if (value is Map<String, Object?>) {
    for (final entry in value.entries) {
      if (forbidden.contains(entry.key)) found.add(entry.key);
      found.addAll(_forbiddenKeys(entry.value));
    }
  } else if (value is List<Object?>) {
    for (final item in value) {
      found.addAll(_forbiddenKeys(item));
    }
  }
  return found;
}

Map<String, Object?> _object(Object? value) =>
    Map<String, Object?>.from(value! as Map);

int _depth(Object? value) {
  if (value is Map) {
    return 1 +
        value.values.fold<int>(0, (max, item) {
          final depth = _depth(item);
          return depth > max ? depth : max;
        });
  }
  if (value is List) {
    return 1 +
        value.fold<int>(0, (max, item) {
          final depth = _depth(item);
          return depth > max ? depth : max;
        });
  }
  return 0;
}

enum _ApplyResult { applied, ignoredDuplicate, gap }

final class _SpectatorReducer {
  int lastSequence = 0;

  _ApplyResult apply({required int sequence}) {
    if (sequence <= lastSequence) return _ApplyResult.ignoredDuplicate;
    if (sequence != lastSequence + 1) return _ApplyResult.gap;
    lastSequence = sequence;
    return _ApplyResult.applied;
  }

  void replaceFromSnapshot({required int sequence}) {
    lastSequence = sequence;
  }
}
