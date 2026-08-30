import '../../../domain/tournament/engine/tournament_engines.dart';
import '../../../domain/tournament/host_tournament.dart';

final class HostTournamentSession {
  const HostTournamentSession({
    required this.tournament,
    required this.localProfileId,
    required this.storageRevision,
    required this.lastSequence,
    this.engineState,
  });

  final HostTournament tournament;
  final String localProfileId;
  final int storageRevision;
  final int lastSequence;
  final FormatEngineState? engineState;

  HostTournamentSession copyWith({
    HostTournament? tournament,
    int? storageRevision,
    int? lastSequence,
    FormatEngineState? engineState,
    bool clearEngineState = false,
  }) => HostTournamentSession(
    tournament: tournament ?? this.tournament,
    localProfileId: localProfileId,
    storageRevision: storageRevision ?? this.storageRevision,
    lastSequence: lastSequence ?? this.lastSequence,
    engineState: clearEngineState ? null : engineState ?? this.engineState,
  );
}
