import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/repositories/double_elimination_tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';

final class FakeDoubleEliminationTournamentRepository
    implements DoubleEliminationTournamentRepository {
  DoubleEliminationTournament? activeTournament;
  final Map<TournamentId, FinishedDoubleEliminationSnapshot> finished = {};
  Object? saveError;
  var saveCalls = 0;

  @override
  Future<DoubleEliminationTournament?>
  getActiveDoubleEliminationTournament() async => activeTournament;

  @override
  Future<void> saveActiveDoubleEliminationTournament(
    DoubleEliminationTournament tournament,
  ) async {
    saveCalls += 1;
    if (saveError case final error?) throw error;
    activeTournament = tournament;
  }

  @override
  Future<void> saveFinishedDoubleEliminationTournament(
    FinishedDoubleEliminationSnapshot snapshot,
  ) async {
    saveCalls += 1;
    if (saveError case final error?) throw error;
    finished.putIfAbsent(snapshot.tournament.draft.id, () => snapshot);
    activeTournament = null;
  }

  @override
  Future<FinishedDoubleEliminationSnapshot?>
  getFinishedDoubleEliminationTournamentById(TournamentId id) async =>
      finished[id];
}
