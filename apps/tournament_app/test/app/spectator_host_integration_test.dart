import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tournament_hub_app/app/composition/app_composition.dart';
import 'package:tournament_hub_app/application/spectator/models/spectator_projection.dart';
import 'package:tournament_hub_app/application/spectator/models/spectator_server_state.dart';
import 'package:tournament_hub_app/application/spectator/ports/spectator_server.dart';

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
