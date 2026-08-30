import '../models/persisted_command_result.dart';
import '../models/persisted_tournament_event.dart';
import '../models/persisted_tournament_snapshot.dart';

enum ActiveCommitStatus { committed, duplicateCommand }

final class ActiveCommitResult {
  const ActiveCommitResult({required this.status, required this.commandResult});
  final ActiveCommitStatus status;
  final PersistedCommandResult commandResult;
}

abstract interface class ActiveTournamentStore {
  Future<PersistedTournamentSnapshot?> readActive();

  Future<List<PersistedTournamentEvent>> readEventsAfter({
    required String tournamentId,
    required int sequence,
  });

  Future<ActiveCommitResult> commitMutation({
    required int expectedRevision,
    required PersistedTournamentSnapshot snapshot,
    required List<PersistedTournamentEvent> events,
    required PersistedCommandResult commandResult,
  });
}

final class RevisionConflict implements Exception {
  const RevisionConflict({required this.expected, required this.actual});
  final int expected;
  final int? actual;
}
