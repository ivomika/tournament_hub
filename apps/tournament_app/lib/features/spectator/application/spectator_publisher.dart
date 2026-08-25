import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_outcome.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';

abstract interface class SpectatorPublisher {
  Future<void> publishRoundRobin(
    ActiveTournament tournament,
    TournamentOutcome outcome,
  );

  Future<void> publishFinishedRoundRobin(FinishedTournamentSnapshot snapshot);

  Future<void> publishDoubleElimination(DoubleEliminationTournament tournament);

  Future<void> publishFinishedDoubleElimination(
    FinishedDoubleEliminationSnapshot snapshot,
  );
}
