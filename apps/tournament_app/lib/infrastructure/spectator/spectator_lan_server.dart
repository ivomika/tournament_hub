import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_static/shelf_static.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../application/spectator/models/spectator_projection.dart';
import '../../application/spectator/models/spectator_server_state.dart';
import '../../application/spectator/ports/spectator_server.dart';
import 'spectator_projection_codec.dart';

typedef SpectatorAddressResolver = Future<InternetAddress?> Function();

final class SpectatorLanServer implements SpectatorServer {
  SpectatorLanServer({
    this.preferredPort = 8080,
    required this.staticDirectory,
    SpectatorAddressResolver? addressResolver,
    DateTime Function()? nowUtc,
  }) : _addressResolver = addressResolver ?? _resolvePrivateIpv4,
       _nowUtc = nowUtc ?? (() => DateTime.now().toUtc());

  static const maxInboundBytes = 16 * 1024;
  static const maxOutboundBytes = 2 * 1024 * 1024;
  static const replayCapacity = 4096;

  final int preferredPort;
  final String staticDirectory;
  final SpectatorAddressResolver _addressResolver;
  final DateTime Function() _nowUtc;
  final StreamController<SpectatorServerState> _stateController =
      StreamController.broadcast(sync: true);
  final Set<WebSocketChannel> _clients = {};
  final List<_PublicEvent> _events = [];

  SpectatorServerState _state = const SpectatorServerState.stopped();
  HttpServer? _server;
  Map<String, Object?>? _snapshot;
  String? _snapshotJson;
  String? _tournamentId;
  int _connectionCounter = 0;

  @override
  SpectatorServerState get state => _state;

  @override
  Stream<SpectatorServerState> get stateChanges => _stateController.stream;

  @override
  Future<void> start() async {
    if (_server != null || _state.status == SpectatorServerStatus.starting) {
      return;
    }
    _setState(
      const SpectatorServerState(status: SpectatorServerStatus.starting),
    );
    try {
      HttpServer server;
      try {
        server = await HttpServer.bind(InternetAddress.anyIPv4, preferredPort);
      } on SocketException {
        if (preferredPort == 0) rethrow;
        server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
      }
      _server = server;
      final address = await _addressResolver();
      final endpoint = address == null
          ? null
          : Uri(scheme: 'http', host: address.address, port: server.port);
      final hasBundle =
          Directory(staticDirectory).existsSync() &&
          File('$staticDirectory${Platform.pathSeparator}index.html')
              .existsSync();
      _setState(
        SpectatorServerState(
          status: endpoint == null || !hasBundle
              ? SpectatorServerStatus.degraded
              : SpectatorServerStatus.serving,
          endpoint: endpoint,
          connectedSpectators: _clients.length,
          safeErrorCode: endpoint == null
              ? 'LAN_ADDRESS_UNAVAILABLE'
              : !hasBundle
              ? 'STATIC_BUNDLE_MISSING'
              : null,
        ),
      );
      shelf_io.serveRequests(server, _createHandler(hasBundle));
    } catch (_) {
      _server = null;
      _setState(
        const SpectatorServerState(
          status: SpectatorServerStatus.failed,
          safeErrorCode: 'SERVER_BIND_FAILED',
        ),
      );
    }
  }

  Handler _createHandler(bool hasBundle) {
    final staticHandler = hasBundle
        ? createStaticHandler(staticDirectory, defaultDocument: 'index.html')
        : null;
    final socketHandler = webSocketHandler(
      _onConnection,
      pingInterval: const Duration(seconds: 15),
    );
    FutureOr<Response> staticFallback(Request request) {
      if (request.method != 'GET' && request.method != 'HEAD') {
        return Response.notFound('Not Found');
      }
      return staticHandler == null
          ? Response.notFound('Not Found')
          : staticHandler(request);
    }

    final router = Router(notFoundHandler: staticFallback)
      ..add('HEAD', '/api/spectator/v1/snapshot', (_) {
        return Response(405, headers: {'allow': 'GET'});
      })
      ..get('/api/spectator/v1/snapshot', (_) {
        final snapshotJson = _snapshotJson;
        return snapshotJson == null
            ? _jsonResponse(503, {'code': 'SNAPSHOT_UNAVAILABLE'})
            : Response.ok(
                snapshotJson,
                headers: {'content-type': 'application/json; charset=utf-8'},
              );
      })
      ..all('/api/spectator/v1/snapshot', (_) {
        return Response(405, headers: {'allow': 'GET'});
      })
      ..get('/ws', socketHandler)
      ..all('/ws', (_) {
        return Response(405, headers: {'allow': 'GET'});
      });
    return (request) async {
      if (!_isAllowedOrigin(request)) {
        return _jsonResponse(403, {'code': 'ORIGIN_FORBIDDEN'});
      }
      return router(request);
    };
  }

  void _onConnection(WebSocketChannel channel, String? _) {
    var handshaken = false;
    late final StreamSubscription<Object?> subscription;
    subscription = channel.stream.listen(
      (message) {
        if (handshaken) {
          unawaited(_reject(channel, 'INVALID_HANDSHAKE'));
          return;
        }
        final handshake = _parseHandshake(message);
        if (handshake == null) {
          unawaited(_reject(channel, 'INVALID_HANDSHAKE'));
          return;
        }
        if (handshake.protocolVersion != 1) {
          unawaited(_reject(channel, 'PROTOCOL_UNSUPPORTED'));
          return;
        }
        if (_snapshot == null || handshake.tournamentId != _tournamentId) {
          unawaited(_reject(channel, 'TOURNAMENT_NOT_FOUND'));
          return;
        }
        handshaken = true;
        _clients.add(channel);
        _publishClientCount();
        _synchronize(channel, handshake);
      },
      onDone: () {
        unawaited(subscription.cancel());
        if (_clients.remove(channel)) _publishClientCount();
      },
      onError: (_) {
        if (_clients.remove(channel)) _publishClientCount();
      },
      cancelOnError: true,
    );
  }

  _Handshake? _parseHandshake(Object? message) {
    if (message is! String || utf8.encode(message).length > maxInboundBytes) {
      return null;
    }
    Object? decoded;
    try {
      decoded = jsonDecode(message);
    } on FormatException {
      return null;
    }
    if (decoded is! Map<String, Object?> || _jsonDepth(decoded) > 8) {
      return null;
    }
    if (!_hasOnly(decoded, const {
      'category',
      'type',
      'protocolVersion',
      'payload',
    })) {
      return null;
    }
    final payload = decoded['payload'];
    if (payload is! Map<String, Object?> ||
        !_hasOnly(payload, const {
          'clientType',
          'tournamentId',
          'lastSequence',
        })) {
      return null;
    }
    final protocolVersion = decoded['protocolVersion'];
    final tournamentId = payload['tournamentId'];
    final lastSequence = payload['lastSequence'];
    if (decoded['category'] != 'handshake' ||
        decoded['type'] != 'handshake.client' ||
        payload['clientType'] != 'spectator' ||
        protocolVersion is! int ||
        tournamentId is! String ||
        tournamentId.isEmpty ||
        lastSequence is! int ||
        lastSequence < 0) {
      return null;
    }
    return _Handshake(protocolVersion, tournamentId, lastSequence);
  }

  void _synchronize(WebSocketChannel channel, _Handshake handshake) {
    final currentSequence = (_snapshot!['sequence']! as int);
    final connectionId = 'spectator-${++_connectionCounter}';
    _send(channel, {
      'category': 'handshake',
      'type': 'handshake.accepted',
      'protocolVersion': 1,
      'payload': {
        'connectionId': connectionId,
        'clientType': 'spectator',
        'tournamentId': handshake.tournamentId,
        'currentSequence': currentSequence,
      },
    });
    final replay = _replayAfter(handshake.lastSequence, currentSequence);
    final mode = replay == null ? 'snapshot' : 'events';
    _sendControl(channel, 'sync.started', {'mode': mode});
    if (replay == null) {
      _sendControl(channel, 'sync.snapshot', {
        'tournamentId': handshake.tournamentId,
        'sequence': currentSequence,
        'snapshotVersion': SpectatorTournamentProjection.snapshotVersion,
        'snapshot': _snapshot,
      });
    } else {
      for (final event in replay) {
        channel.sink.add(event.json);
      }
    }
    _sendControl(channel, 'sync.completed', {
      'mode': mode,
      'sequence': currentSequence,
    });
  }

  List<_PublicEvent>? _replayAfter(int lastSequence, int currentSequence) {
    if (lastSequence == currentSequence) return const [];
    final replay = _events
        .where((event) => event.sequence > lastSequence)
        .toList(growable: false);
    if (replay.isEmpty || replay.first.sequence != lastSequence + 1) {
      return null;
    }
    for (var index = 1; index < replay.length; index++) {
      if (replay[index].sequence != replay[index - 1].sequence + 1) return null;
    }
    return replay.last.sequence == currentSequence ? replay : null;
  }

  @override
  Future<void> publish(SpectatorTournamentProjection projection) async {
    if (_server == null) await start();
    final encoded = SpectatorProjectionCodec.encode(projection);
    final snapshotJson = jsonEncode(encoded);
    if (utf8.encode(snapshotJson).length > maxOutboundBytes) {
      _setDegraded('PROJECTION_TOO_LARGE');
      return;
    }
    if (_tournamentId != projection.tournamentId) _events.clear();
    _tournamentId = projection.tournamentId;
    _snapshot = encoded;
    _snapshotJson = snapshotJson;
    final event = {
      'category': 'event',
      'type': 'spectator.projection.replaced',
      'protocolVersion': 1,
      'eventVersion': 1,
      'eventId': '${projection.tournamentId}:${projection.sequence}',
      'tournamentId': projection.tournamentId,
      'sequence': projection.sequence,
      'timestamp': _nowUtc().toIso8601String(),
      'payload': {'projection': encoded},
    };
    final eventJson = jsonEncode(event);
    _events.removeWhere((value) => value.sequence >= projection.sequence);
    _events.add(_PublicEvent(projection.sequence, eventJson));
    if (_events.length > replayCapacity) {
      _events.removeRange(0, _events.length - replayCapacity);
    }
    for (final client in List<WebSocketChannel>.of(_clients)) {
      client.sink.add(eventJson);
    }
    if (projection.lifecycle == 'finished') {
      for (final client in List<WebSocketChannel>.of(_clients)) {
        await client.sink.close(4000, 'TOURNAMENT_TERMINATED');
      }
      _clients.clear();
      _publishClientCount();
    }
  }

  @override
  Future<void> clear() async {
    _snapshot = null;
    _snapshotJson = null;
    _tournamentId = null;
    _events.clear();
    for (final client in List<WebSocketChannel>.of(_clients)) {
      await client.sink.close(4000, 'TOURNAMENT_TERMINATED');
    }
    _clients.clear();
    _publishClientCount();
  }

  @override
  Future<void> stop() async {
    for (final client in List<WebSocketChannel>.of(_clients)) {
      await client.sink.close(4001, 'HOST_SHUTDOWN');
    }
    _clients.clear();
    await _server?.close(force: true);
    _server = null;
    _setState(const SpectatorServerState.stopped());
  }

  Future<void> _reject(WebSocketChannel channel, String code) async {
    _send(channel, {
      'category': 'error',
      'type': 'protocol.error',
      'protocolVersion': 1,
      'code': code,
      'message': code,
      'payload': <String, Object?>{},
    });
    await channel.sink.close(4008, code);
  }

  void _sendControl(
    WebSocketChannel channel,
    String type,
    Map<String, Object?> payload,
  ) => _send(channel, {
    'category': 'control',
    'type': type,
    'protocolVersion': 1,
    'payload': payload,
  });

  void _send(WebSocketChannel channel, Map<String, Object?> value) {
    channel.sink.add(jsonEncode(value));
  }

  bool _isAllowedOrigin(Request request) {
    final raw = request.headers['origin'];
    if (raw == null) return true;
    final origin = Uri.tryParse(raw);
    final requested = request.requestedUri;
    return origin != null &&
        origin.scheme == requested.scheme &&
        origin.host.toLowerCase() == requested.host.toLowerCase() &&
        origin.port == requested.port;
  }

  void _publishClientCount() {
    _setState(
      SpectatorServerState(
        status: _state.status,
        endpoint: _state.endpoint,
        connectedSpectators: _clients.length,
        safeErrorCode: _state.safeErrorCode,
      ),
    );
  }

  void _setDegraded(String code) {
    _setState(
      SpectatorServerState(
        status: SpectatorServerStatus.degraded,
        endpoint: _state.endpoint,
        connectedSpectators: _clients.length,
        safeErrorCode: code,
      ),
    );
  }

  void _setState(SpectatorServerState value) {
    _state = value;
    if (!_stateController.isClosed) _stateController.add(value);
  }

  static Future<InternetAddress?> _resolvePrivateIpv4() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );
    for (final address in interfaces.expand((value) => value.addresses)) {
      final bytes = address.rawAddress;
      if (bytes[0] == 10 ||
          (bytes[0] == 172 && bytes[1] >= 16 && bytes[1] <= 31) ||
          (bytes[0] == 192 && bytes[1] == 168)) {
        return address;
      }
    }
    return null;
  }
}

Response _jsonResponse(int status, Map<String, Object?> body) => Response(
  status,
  body: jsonEncode(body),
  headers: {'content-type': 'application/json; charset=utf-8'},
);

bool _hasOnly(Map<String, Object?> value, Set<String> expected) =>
    value.keys.toSet().containsAll(expected) &&
    expected.containsAll(value.keys);

int _jsonDepth(Object? value) {
  if (value is Map) {
    if (value.isEmpty) return 1;
    return 1 + value.values.map(_jsonDepth).reduce((a, b) => a > b ? a : b);
  }
  if (value is List) {
    if (value.isEmpty) return 1;
    return 1 + value.map(_jsonDepth).reduce((a, b) => a > b ? a : b);
  }
  return 0;
}

final class _Handshake {
  const _Handshake(this.protocolVersion, this.tournamentId, this.lastSequence);

  final int protocolVersion;
  final String tournamentId;
  final int lastSequence;
}

final class _PublicEvent {
  const _PublicEvent(this.sequence, this.json);

  final int sequence;
  final String json;
}
