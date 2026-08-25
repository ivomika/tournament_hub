import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:tournament_app/core/server/spectator_server.dart';

final class DartIoSpectatorServer implements SpectatorServer {
  DartIoSpectatorServer({
    this.port = 8080,
    InternetAddress? bindAddress,
    this.advertisedHost,
    AssetBundle? assetBundle,
  }) : bindAddress = bindAddress ?? InternetAddress.anyIPv4,
       _assetBundle = assetBundle ?? rootBundle;

  final int port;
  final InternetAddress bindAddress;
  final String? advertisedHost;
  final AssetBundle _assetBundle;

  final _clients = <WebSocket>{};
  final _clientCountController = StreamController<int>.broadcast();
  HttpServer? _server;
  String? _latestMessage;

  @override
  int get clientCount => _clients.length;

  @override
  Stream<int> get clientCountChanges => _clientCountController.stream;

  @override
  Future<Uri> start() async {
    final existing = _server;
    if (existing != null) return _publicUri(existing.port);
    HttpServer server;
    try {
      server = await HttpServer.bind(bindAddress, port);
    } on SocketException {
      server = await HttpServer.bind(bindAddress, 0);
    }
    _server = server;
    unawaited(server.forEach(_handleRequest));
    return _publicUri(server.port);
  }

  @override
  Future<void> publish(String message) async {
    _latestMessage = message;
    for (final client in _clients.toList(growable: false)) {
      try {
        client.add(message);
      } on WebSocketException {
        await _removeClient(client);
      }
    }
  }

  @override
  Future<void> stop() async {
    for (final client in _clients.toList(growable: false)) {
      await client.close(WebSocketStatus.goingAway, 'Host остановлен');
    }
    _clients.clear();
    _emitClientCount();
    await _server?.close(force: true);
    _server = null;
  }

  Future<void> _handleRequest(HttpRequest request) async {
    if (request.uri.path == '/ws' &&
        WebSocketTransformer.isUpgradeRequest(request)) {
      await _upgrade(request);
      return;
    }
    await _serveAsset(request);
  }

  Future<void> _upgrade(HttpRequest request) async {
    final socket = await WebSocketTransformer.upgrade(request);
    socket.pingInterval = const Duration(seconds: 20);
    _clients.add(socket);
    _emitClientCount();
    if (_latestMessage case final latest?) socket.add(latest);
    socket.listen(
      (message) {
        if (message == '{"messageType":"sync"}' && _latestMessage != null) {
          socket.add(_latestMessage!);
        }
      },
      onDone: () => _removeClient(socket),
      onError: (_) => _removeClient(socket),
      cancelOnError: true,
    );
  }

  Future<void> _serveAsset(HttpRequest request) async {
    if (request.method != 'GET' && request.method != 'HEAD') {
      request.response.statusCode = HttpStatus.methodNotAllowed;
      await request.response.close();
      return;
    }
    final path = request.uri.path;
    if (path.contains('..')) {
      request.response.statusCode = HttpStatus.badRequest;
      await request.response.close();
      return;
    }
    final assetPath = path.startsWith('/fighters/')
        ? 'assets$path'
        : path == '/' || path.isEmpty
        ? 'assets/spectator/index.html'
        : 'assets/spectator${Uri.decodeComponent(path)}';
    try {
      final data = await _assetBundle.load(assetPath);
      await _writeAsset(request, data.buffer.asUint8List(), assetPath);
    } on FlutterError {
      if (!path.split('/').last.contains('.')) {
        try {
          final data = await _assetBundle.load('assets/spectator/index.html');
          await _writeAsset(request, data.buffer.asUint8List(), 'index.html');
          return;
        } on FlutterError {
          // Обрабатывается единым 404 ниже.
        }
      }
      request.response.statusCode = HttpStatus.notFound;
      request.response.write('Ресурс spectator не найден.');
      await request.response.close();
    }
  }

  Future<void> _writeAsset(
    HttpRequest request,
    Uint8List bytes,
    String path,
  ) async {
    request.response.headers.set(HttpHeaders.contentTypeHeader, _mime(path));
    request.response.headers.set(HttpHeaders.cacheControlHeader, 'no-cache');
    if (request.method == 'GET') request.response.add(bytes);
    await request.response.close();
  }

  Future<Uri> _publicUri(int actualPort) async {
    final host = advertisedHost ?? await _findLanAddress();
    return Uri(scheme: 'http', host: host, port: actualPort);
  }

  Future<String> _findLanAddress() async {
    final interfaces = await NetworkInterface.list(
      type: InternetAddressType.IPv4,
      includeLoopback: false,
    );
    final addresses = interfaces.expand((item) => item.addresses).toList();
    for (final address in addresses) {
      if (_isPrivate(address.address)) return address.address;
    }
    return addresses.isEmpty
        ? InternetAddress.loopbackIPv4.address
        : addresses.first.address;
  }

  bool _isPrivate(String address) {
    final parts = address.split('.').map(int.tryParse).toList();
    if (parts.length != 4 || parts.any((part) => part == null)) return false;
    return parts[0] == 10 ||
        (parts[0] == 172 && parts[1]! >= 16 && parts[1]! <= 31) ||
        (parts[0] == 192 && parts[1] == 168);
  }

  String _mime(String path) => switch (path.split('.').last.toLowerCase()) {
    'html' => 'text/html; charset=utf-8',
    'js' => 'text/javascript; charset=utf-8',
    'css' => 'text/css; charset=utf-8',
    'json' => 'application/json; charset=utf-8',
    'png' => 'image/png',
    'svg' => 'image/svg+xml',
    'woff2' => 'font/woff2',
    _ => 'application/octet-stream',
  };

  Future<void> _removeClient(WebSocket socket) async {
    if (_clients.remove(socket)) {
      _emitClientCount();
      await socket.close();
    }
  }

  void _emitClientCount() {
    if (!_clientCountController.isClosed) {
      _clientCountController.add(_clients.length);
    }
  }
}
