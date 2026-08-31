import '../models/spectator_projection.dart';
import '../models/spectator_server_state.dart';

abstract interface class SpectatorServer {
  SpectatorServerState get state;
  Stream<SpectatorServerState> get stateChanges;

  Future<void> start();
  Future<void> publish(SpectatorTournamentProjection projection);
  Future<void> clear();
  Future<void> stop();
}
