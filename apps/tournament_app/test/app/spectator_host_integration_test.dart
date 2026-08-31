import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tournament_hub_app/app/composition/app_composition.dart';
import 'package:tournament_hub_app/application/spectator/models/spectator_projection.dart';
import 'package:tournament_hub_app/application/spectator/models/spectator_server_state.dart';
import 'package:tournament_hub_app/application/spectator/ports/spectator_server.dart';
import 'package:tournament_hub_app/infrastructure/spectator/spectator_lan_server.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'ошибка Spectator server не блокирует committed Host commands',
    () async {
      SharedPreferences.setMockInitialValues({});
      final server = _FailingSpectatorServer();
      final runtime = AppComposition.memory(spectatorServer: server);
      addTearDown(runtime.dispose);

      await runtime.start();
      await runtime.createProfile('Организатор');
      await runtime.createTournament(formatId: 'single-elimination');
      await runtime.openTournament();
      await runtime.addGuest('Гость 1');
      await runtime.addGuest('Гость 2');
      await runtime.addGuest('Гость 3');
      await runtime.startDistribution();

      expect(runtime.hostTournamentProjection!.lifecycle, 'distribution');
      expect(runtime.hostTournamentProjection!.participants, hasLength(4));
      expect(server.startCalls, greaterThan(0));
    },
  );

  test(
    'committed Host projection доступна через реальный LAN adapter',
    () async {
      SharedPreferences.setMockInitialValues({});
      final bundle = await Directory.systemTemp.createTemp(
        'spectator-host-bundle-',
      );
      await File('${bundle.path}${Platform.pathSeparator}index.html')
          .writeAsString('<!doctype html><title>Spectator</title>');
      final server = SpectatorLanServer(
        preferredPort: 0,
        staticDirectory: bundle.path,
        addressResolver: () async => InternetAddress.loopbackIPv4,
      );
      final runtime = AppComposition.memory(spectatorServer: server);
      addTearDown(() async {
        runtime.dispose();
        await server.stop();
        await bundle.delete(recursive: true);
      });

      await runtime.start();
      await runtime.createProfile('Организатор');
      await runtime.createTournament(formatId: 'single-elimination');
      await runtime.openTournament();
      await runtime.addGuest('Гость 1');
      await runtime.startDistribution();
      await runtime.resumeSpectatorServer();

      final endpoint = server.state.endpoint!;
      final socket = await Socket.connect(
        InternetAddress.loopbackIPv4,
        endpoint.port,
      );
      socket.write(
        'GET /api/spectator/v1/snapshot HTTP/1.1\r\n'
        'Host: ${endpoint.host}:${endpoint.port}\r\n'
        'Connection: close\r\n\r\n',
      );
      await socket.flush();
      final rawResponse = await utf8.decoder
          .bind(socket.cast<List<int>>())
          .join();
      final separator = rawResponse.indexOf('\r\n\r\n');
      final statusLine = rawResponse.substring(0, rawResponse.indexOf('\r\n'));
      final payload = jsonDecode(
        rawResponse.substring(separator + 4),
      ) as Map<String, Object?>;

      expect(statusLine, contains(' ${HttpStatus.ok} '));
      expect(
        (payload['tournament']! as Map<String, Object?>)['lifecycle'],
        'distribution',
      );
      expect(payload['participants'], hasLength(2));
      expect(payload.toString(), isNot(contains('profileId')));
      expect(payload.toString(), isNot(contains('localProfileId')));
    },
  );
}

final class _FailingSpectatorServer implements SpectatorServer {
  int startCalls = 0;

  @override
  SpectatorServerState get state => const SpectatorServerState(
    status: SpectatorServerStatus.failed,
    safeErrorCode: 'TEST_FAILURE',
  );

  @override
  Stream<SpectatorServerState> get stateChanges => const Stream.empty();

  @override
  Future<void> start() async {
    startCalls++;
    throw StateError('synthetic server failure');
  }

  @override
  Future<void> publish(SpectatorTournamentProjection projection) async =>
      throw StateError('synthetic publish failure');

  @override
  Future<void> clear() async {}

  @override
  Future<void> stop() async {}
}
