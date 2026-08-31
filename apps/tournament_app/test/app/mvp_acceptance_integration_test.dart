import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tournament_hub_app/app/composition/app_composition.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state.dart';
import 'package:tournament_hub_app/application/spectator/models/spectator_projection.dart';
import 'package:tournament_hub_app/application/spectator/models/spectator_server_state.dart';
import 'package:tournament_hub_app/application/spectator/ports/spectator_server.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final formatId in const [
    'double-elimination',
    'single-elimination',
    'round-robin',
  ]) {
    test('$formatId проходит Host+Guests Draft → Finished → history', () async {
      SharedPreferences.setMockInitialValues({});
      final server = _RecordingSpectatorServer();
      final runtime = AppComposition.memory(spectatorServer: server);
      addTearDown(runtime.dispose);

      await runtime.start();
      await runtime.createProfile('Организатор');
      await runtime.createTournament(formatId: formatId);
      await runtime.openTournament();
      for (var index = 1; index <= 3; index++) {
        await runtime.addGuest('Гость $index');
      }
      await runtime.startDistribution();
      await runtime.resumeSpectatorServer();

      final distribution = runtime.hostTournamentProjection!;
      expect(distribution.lifecycle, 'distribution');
      expect(distribution.participants, hasLength(4));
      expect(
        distribution.participants.every(
          (participant) =>
              participant.fighterName != null &&
              participant.fighterAssetPath != null,
        ),
        isTrue,
      );
      expect(server.projection?.lifecycle, 'distribution');

      await runtime.startTournament();
      var completedMatches = 0;
      while (true) {
        final match = runtime.hostTournamentProjection!.currentMatch;
        if (match == null) break;
        final participants = runtime.hostTournamentProjection!.participants;
        final firstRank = participants.indexWhere(
          (participant) => participant.id == match.firstParticipantId,
        );
        final secondRank = participants.indexWhere(
          (participant) => participant.id == match.secondParticipantId,
        );
        await runtime.selectWinner(
          firstRank < secondRank
              ? match.firstParticipantId
              : match.secondParticipantId,
        );
        completedMatches++;
        expect(completedMatches, lessThan(100));
      }

      expect(runtime.hostTournamentProjection!.isReadyToFinish, isTrue);
      await runtime.finishTournament();
      await runtime.resumeSpectatorServer();

      final finished = runtime.hostTournamentProjection!;
      expect(finished.lifecycle, 'finished');
      expect(finished.championId, finished.participants.first.id);
      expect(server.projection?.lifecycle, 'finished');
      expect(server.projection?.championParticipantId, 'participant-1');
      expect(
        server.projection!.participants.every(
          (participant) =>
              participant.id.startsWith('participant-') &&
              participant.fighter != null,
        ),
        isTrue,
      );

      await runtime.loadHistory();
      expect(runtime.historyProjection!.entries, hasLength(1));
      expect(runtime.historyProjection!.statistics.tournamentCount, 1);
      expect(runtime.historyProjection!.statistics.tournamentWins, 1);

      await runtime.leaveTerminalTournament();
      expect(
        (runtime.appStateSource.current as AppOperational)
            .session
            .activeTournament,
        isNull,
      );

      final clearsBeforeNewDraft = server.clearCalls;
      await runtime.createTournament(formatId: formatId);
      await runtime.resumeSpectatorServer();
      expect(runtime.hostTournamentProjection!.lifecycle, 'draft');
      expect(server.projection, isNull);
      expect(server.clearCalls, greaterThan(clearsBeforeNewDraft));
    });
  }

  test(
    'mobile suspend/resume восстанавливает full spectator projection',
    () async {
      SharedPreferences.setMockInitialValues({});
      final server = _RecordingSpectatorServer();
      final runtime = AppComposition.memory(spectatorServer: server);
      addTearDown(runtime.dispose);

      await runtime.start();
      await runtime.createProfile('Организатор');
      await runtime.createTournament(formatId: 'single-elimination');
      await runtime.openTournament();
      await runtime.addGuest('Гость 1');
      await runtime.startDistribution();
      await runtime.resumeSpectatorServer();
      final publishedBeforeSuspend = server.publishCalls;

      await runtime.suspendSpectatorServer();
      expect(server.state.status, SpectatorServerStatus.stopped);

      await runtime.resumeSpectatorServer();
      expect(server.state.status, SpectatorServerStatus.serving);
      expect(server.publishCalls, greaterThan(publishedBeforeSuspend));
      expect(server.projection?.lifecycle, 'distribution');
    },
  );

  test(
    'account reset закрывает spectator и очищает in-memory session',
    () async {
      SharedPreferences.setMockInitialValues({
        'confirm_tournament_start': false,
      });
      final server = _RecordingSpectatorServer();
      final runtime = AppComposition.memory(spectatorServer: server);
      addTearDown(runtime.dispose);

      await runtime.start();
      await runtime.createProfile('Организатор');
      await runtime.createTournament(formatId: 'single-elimination');
      await runtime.openTournament();
      await runtime.addGuest('Гость 1');
      await runtime.startDistribution();
      await runtime.resumeSpectatorServer();

      await runtime.resetAccount();

      expect(runtime.appStateSource.current, isA<AppProfileRequired>());
      expect(runtime.hostTournamentProjection, isNull);
      expect(runtime.historyProjection, isNull);
      expect(server.projection, isNull);
      expect(server.state.status, SpectatorServerStatus.stopped);
      expect(server.stopCalls, greaterThan(0));
      expect(server.clearCalls, greaterThan(0));
      expect((await SharedPreferences.getInstance()).getKeys(), isEmpty);
    },
  );
}

final class _RecordingSpectatorServer implements SpectatorServer {
  SpectatorServerState _state = const SpectatorServerState.stopped();
  SpectatorTournamentProjection? projection;
  int publishCalls = 0;
  int clearCalls = 0;
  int stopCalls = 0;

  @override
  SpectatorServerState get state => _state;

  @override
  Stream<SpectatorServerState> get stateChanges => const Stream.empty();

  @override
  Future<void> start() async {
    _state = SpectatorServerState(
      status: SpectatorServerStatus.serving,
      endpoint: Uri.parse('http://192.168.1.20:8080'),
    );
  }

  @override
  Future<void> publish(SpectatorTournamentProjection projection) async {
    publishCalls++;
    this.projection = projection;
  }

  @override
  Future<void> clear() async {
    clearCalls++;
    projection = null;
  }

  @override
  Future<void> stop() async {
    stopCalls++;
    _state = const SpectatorServerState.stopped();
  }
}
