import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/application/spectator/models/spectator_projection.dart';
import 'package:tournament_hub_app/application/spectator/models/spectator_server_state.dart';
import 'package:tournament_hub_app/infrastructure/spectator/spectator_lan_server.dart';

void main() {
  late Directory bundle;
  late SpectatorLanServer server;

  setUp(() async {
    bundle = await Directory.systemTemp.createTemp('spectator-bundle-');
    await File('${bundle.path}${Platform.pathSeparator}index.html')
        .writeAsString('<!doctype html><title>Spectator</title>');
    await Directory('${bundle.path}${Platform.pathSeparator}assets').create();
    await File(
      '${bundle.path}${Platform.pathSeparator}assets${Platform.pathSeparator}app.js',
    ).writeAsString('console.log("spectator");');
    server = SpectatorLanServer(
      preferredPort: 0,
      staticDirectory: bundle.path,
      addressResolver: () async => InternetAddress.loopbackIPv4,
      nowUtc: () => DateTime.utc(2026, 8, 30, 12),
    );
    await server.start();
  });

  tearDown(() async {
    await server.stop();
    await bundle.delete(recursive: true);
  });

  test(
    'отдаёт static и committed snapshot, запрещает mutation/origin',
    () async {
      expect(server.state.status, SpectatorServerStatus.serving);
      final endpoint = server.state.endpoint!;
      await server.publish(_projection(sequence: 7));

      final root = await _request(endpoint, 'GET', '/');
      expect(root.statusCode, 200);
      expect(root.body, contains('Spectator'));
      expect((await _request(endpoint, 'HEAD', '/')).statusCode, 200);
      expect((await _request(endpoint, 'GET', '/spectator')).statusCode, 200);
      expect(endpoint.path, '/');

      final js = await _request(endpoint, 'GET', '/assets/index.js');
      expect(js.statusCode, 404);
      expect(js.body, isNot(contains('<!doctype html>')));
      final existingJs = await _request(endpoint, 'GET', '/assets/app.js');
      expect(existingJs.statusCode, 200);
      expect(existingJs.body, contains('console.log'));
      expect(existingJs.contentType, contains('javascript'));

      final snapshot = await _request(
        endpoint,
        'GET',
        '/api/spectator/v1/snapshot',
      );
      final json = jsonDecode(snapshot.body) as Map;
      expect(snapshot.statusCode, 200);
      expect(json['sequence'], 7);
      expect(json.toString(), isNot(contains('profileId')));

      final mutation = await _request(
        endpoint,
        'POST',
        '/api/spectator/v1/snapshot',
      );
      expect(mutation.statusCode, 405);

      final forbidden = await _request(
        endpoint,
        'GET',
        '/api/spectator/v1/snapshot',
        origin: 'http://evil.invalid',
      );
      expect(forbidden.statusCode, 403);
    },
  );

  test('синхронизирует WebSocket snapshot и следующие события', () async {
    await server.publish(_projection(sequence: 7));
    final endpoint = server.state.endpoint!;
    final socket = await WebSocket.connect(
      'ws://${endpoint.host}:${endpoint.port}/ws',
    );
    final messages = StreamIterator<Object?>(socket);
    socket.add(
      jsonEncode({
        'category': 'handshake',
        'type': 'handshake.client',
        'protocolVersion': 1,
        'payload': {
          'clientType': 'spectator',
          'tournamentId': 't-1',
          'lastSequence': 0,
        },
      }),
    );

    final receivedTypes = <String>[];
    for (var index = 0; index < 4; index++) {
      expect(await messages.moveNext(), isTrue);
      final value = jsonDecode(messages.current! as String) as Map;
      receivedTypes.add(value['type']! as String);
    }
    expect(receivedTypes, [
      'handshake.accepted',
      'sync.started',
      'sync.snapshot',
      'sync.completed',
    ]);
    expect(server.state.connectedSpectators, 1);

    await server.publish(_projection(sequence: 8));
    expect(await messages.moveNext(), isTrue);
    final event = jsonDecode(messages.current! as String) as Map;
    expect(event['type'], 'spectator.projection.replaced');
    expect(event['sequence'], 8);
    await socket.close();
  });

  test('отклоняет malformed и неизвестные handshake fields', () async {
    await server.publish(_projection(sequence: 1));
    final endpoint = server.state.endpoint!;
    final socket = await WebSocket.connect(
      'ws://${endpoint.host}:${endpoint.port}/ws',
    );
    final messages = StreamIterator<Object?>(socket);
    socket.add(
      jsonEncode({
        'category': 'handshake',
        'type': 'handshake.client',
        'protocolVersion': 1,
        'payload': {
          'clientType': 'spectator',
          'tournamentId': 't-1',
          'lastSequence': 0,
          'unexpected': true,
        },
      }),
    );
    expect(await messages.moveNext(), isTrue);
    final error = jsonDecode(messages.current! as String) as Map;
    expect(error['code'], 'INVALID_HANDSHAKE');
    expect(server.state.connectedSpectators, 0);
    await socket.close();

    final oversized = await WebSocket.connect(
      'ws://${endpoint.host}:${endpoint.port}/ws',
    );
    final oversizedMessages = StreamIterator<Object?>(oversized);
    oversized.add('x' * (SpectatorLanServer.maxInboundBytes + 1));
    expect(await oversizedMessages.moveNext(), isTrue);
    final oversizedError =
        jsonDecode(oversizedMessages.current! as String) as Map;
    expect(oversizedError['code'], 'INVALID_HANDSHAKE');
    await oversized.close();
  });

  test('при конфликте preferred port использует ephemeral port', () async {
    final occupied = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    final fallback = SpectatorLanServer(
      preferredPort: occupied.port,
      staticDirectory: bundle.path,
      addressResolver: () async => InternetAddress.loopbackIPv4,
    );
    addTearDown(() async {
      await fallback.stop();
      await occupied.close(force: true);
    });

    await fallback.start();

    expect(fallback.state.status, SpectatorServerStatus.serving);
    expect(fallback.state.endpoint!.port, isNot(occupied.port));
  });

  test('stop и restart создают новый обслуживающий instance', () async {
    final firstPort = server.state.endpoint!.port;

    await server.stop();
    expect(server.state.status, SpectatorServerStatus.stopped);
    await server.start();

    expect(server.state.status, SpectatorServerStatus.serving);
    expect(server.state.endpoint!.port, isPositive);
    expect(firstPort, isPositive);
  });

  test('предпочитает физический LAN interface виртуальному VPN', () {
    final selected = selectSpectatorLanAddress([
      SpectatorLanAddressCandidate('utun4', InternetAddress('10.8.0.2')),
      SpectatorLanAddressCandidate(
        'bridge100',
        InternetAddress('192.168.64.1'),
      ),
      SpectatorLanAddressCandidate('en0', InternetAddress('192.168.1.42')),
    ]);

    expect(selected?.address, '192.168.1.42');
  });

  test(
    'использует подготовленный bundle вместо несуществующего пути',
    () async {
      final resolved = SpectatorLanServer(
        preferredPort: 0,
        staticDirectory: '${bundle.path}-missing',
        bundleResolver: () async => bundle,
        addressResolver: () async => InternetAddress.loopbackIPv4,
      );
      addTearDown(resolved.stop);

      await resolved.start();
      final response = await _request(resolved.state.endpoint!, 'GET', '/');

      expect(resolved.state.status, SpectatorServerStatus.serving);
      expect(response.statusCode, 200);
      expect(response.body, contains('Spectator'));
    },
  );
}

Future<_TestResponse> _request(
  Uri endpoint,
  String method,
  String path, {
  String? origin,
}) async {
  final client = HttpClient();
  final request = await client.openUrl(method, endpoint.replace(path: path));
  if (origin != null) request.headers.set('origin', origin);
  final response = await request.close();
  final body = await utf8.decoder.bind(response).join();
  final result = _TestResponse(
    response.statusCode,
    body,
    response.headers.contentType?.mimeType ?? '',
  );
  client.close(force: true);
  return result;
}

final class _TestResponse {
  const _TestResponse(this.statusCode, this.body, this.contentType);

  final int statusCode;
  final String body;
  final String contentType;
}

SpectatorTournamentProjection _projection({required int sequence}) =>
    SpectatorTournamentProjection(
      tournamentId: 't-1',
      revision: sequence,
      sequence: sequence,
      title: 'Friday Fight',
      formatId: 'single-elimination',
      lifecycle: 'running',
      participants: const [
        SpectatorParticipantProjection(
          id: 'participant-1',
          nickname: 'Иван',
          isGuest: false,
        ),
        SpectatorParticipantProjection(
          id: 'participant-2',
          nickname: 'Гость',
          isGuest: true,
        ),
      ],
      matches: const [
        SpectatorMatchProjection(
          id: 'm-1',
          round: 1,
          order: 0,
          stage: 'main',
          firstTo: 1,
          firstParticipantId: 'participant-1',
          secondParticipantId: 'participant-2',
          status: 'current',
        ),
      ],
      standings: const [],
    );
