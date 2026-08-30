import '../persistence/ports/tournament_history_store.dart';
import '../tournament/mappers/host_tournament_snapshot_mapper.dart';
import '../tournament/models/host_tournament_projection.dart';
import '../../domain/tournament/engine/tournament_engines.dart';
import 'models/history_projection.dart';

final class HistoryService {
  const HistoryService(this._store, this._engines);

  final TournamentHistoryStore _store;
  final TournamentFormatEngineRegistry _engines;

  Future<HistoryProjection> read({required String localProfileId}) async {
    final records = await _store.readAll();
    final sessions = [
      for (final record in records)
        HostTournamentSnapshotMapper.fromSnapshot(record.snapshot, _engines),
    ];
    final entries = List<HistoryTournamentProjection>.unmodifiable([
      for (var index = 0; index < records.length; index++)
        HistoryTournamentProjection(
          tournament: HostTournamentProjectionMapper.fromSession(
            sessions[index],
          ),
          finishedAtUtc: records[index].finishedAtUtc,
        ),
    ]);

    var tournamentCount = 0;
    var tournamentWins = 0;
    var normalMatchCount = 0;
    var normalMatchWins = 0;
    int? bestPlace;
    final recent = <String>[];
    for (var index = 0; index < sessions.length; index++) {
      final session = sessions[index];
      final participant = session.tournament.participants
          .where((value) => value.profileId == localProfileId)
          .firstOrNull;
      if (participant == null) continue;
      recent.add(session.tournament.id);
      final outcome = session.engineState?.outcome;
      if (session.tournament.lifecycle.name == 'finished') {
        tournamentCount++;
        if (outcome?.championId == participant.id) tournamentWins++;
        final placement = outcome?.ranking
            .where((value) => value.participantId == participant.id)
            .firstOrNull;
        if (placement != null &&
            (bestPlace == null || placement.from < bestPlace)) {
          bestPlace = placement.from;
        }
      }
      for (final match in session.engineState?.matches ?? const []) {
        final result = match.result;
        if (result is! NormalMatchResult ||
            (result.winnerId != participant.id &&
                result.loserId != participant.id)) {
          continue;
        }
        normalMatchCount++;
        if (result.winnerId == participant.id) normalMatchWins++;
      }
    }
    return HistoryProjection(
      entries: entries,
      statistics: HostProfileStatisticsProjection(
        tournamentCount: tournamentCount,
        tournamentWins: tournamentWins,
        normalMatchCount: normalMatchCount,
        normalMatchWins: normalMatchWins,
        bestPlace: bestPlace,
        recentTournamentIds: List.unmodifiable(recent.take(3)),
      ),
    );
  }

  Future<void> clear() => _store.clearHistory();
}
