import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';

abstract interface class DoubleEliminationTournamentRepository {
  Future<DoubleEliminationTournament?> getActiveDoubleEliminationTournament();

  Future<void> saveActiveDoubleEliminationTournament(
    DoubleEliminationTournament tournament,
  );

  Future<void> saveFinishedDoubleEliminationTournament(
    FinishedDoubleEliminationSnapshot snapshot,
  );

  Future<FinishedDoubleEliminationSnapshot?>
  getFinishedDoubleEliminationTournamentById(TournamentId id);
}
