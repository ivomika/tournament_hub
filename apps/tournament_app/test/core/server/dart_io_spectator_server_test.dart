import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/core/server/dart_io_spectator_server.dart';

void main() {
  test(
    'раздаёт web bundle и отправляет последний snapshot при connect',
    () async {
      final server = DartIoSpectatorServer(
        port: 0,
        bindAddress: InternetAddress.loopbackIPv4,
        advertisedHost: InternetAddress.loopbackIPv4.address,
        assetBundle: _MemoryAssetBundle(),
      );
      addTearDown(server.stop);
      final uri = await server.start();
      await server.publish('{"revision":1}');

      final response = await HttpClient()
          .getUrl(uri)
          .then((request) => request.close());
      final html = await utf8.decodeStream(response);
      final socket = await WebSocket.connect(
        uri.replace(scheme: 'ws', path: '/ws').toString(),
      );
      addTearDown(socket.close);

      expect(response.statusCode, HttpStatus.ok);
      expect(html, contains('Tournament HUB'));
      expect(await socket.first, '{"revision":1}');
      expect(server.clientCount, 1);
    },
  );

  test('повторяет актуальный snapshot по sync', () async {
    final server = DartIoSpectatorServer(
      port: 0,
      bindAddress: InternetAddress.loopbackIPv4,
      advertisedHost: InternetAddress.loopbackIPv4.address,
      assetBundle: _MemoryAssetBundle(),
    );
    addTearDown(server.stop);
    final uri = await server.start();
    final socket = await WebSocket.connect(
      uri.replace(scheme: 'ws', path: '/ws').toString(),
    );
    addTearDown(socket.close);
    final iterator = StreamIterator<dynamic>(socket);
    await server.publish('{"revision":2}');
    expect(await iterator.moveNext(), isTrue);
    expect(iterator.current, '{"revision":2}');

    socket.add('{"messageType":"sync"}');

    expect(await iterator.moveNext(), isTrue);
    expect(iterator.current, '{"revision":2}');
    await iterator.cancel();
  });
}

final class _MemoryAssetBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final value = switch (key) {
      'assets/spectator/index.html' =>
        '<html><body>Tournament HUB</body></html>',
      _ => throw FlutterError('Нет тестового asset: $key'),
    };
    final bytes = Uint8List.fromList(utf8.encode(value));
    return ByteData.view(bytes.buffer);
  }
}
