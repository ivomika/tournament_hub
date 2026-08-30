import '../models/persisted_history_snapshot.dart';
import '../models/persisted_tournament_event.dart';

final class TerminalCommitResult {
  const TerminalCommitResult({required this.inserted, required this.event});
  final bool inserted;
  final PersistedTournamentEvent event;
}

abstract interface class TournamentHistoryStore {
  Future<List<PersistedHistorySnapshot>> readAll();

  Future<TerminalCommitResult> commitTerminal({
    required PersistedHistorySnapshot history,
    required PersistedTournamentEvent terminalEvent,
  });

  Future<void> clearHistory();
}
