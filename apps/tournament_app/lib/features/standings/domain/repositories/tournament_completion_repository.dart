import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';

abstract interface class TournamentCompletionRepository {
  Future<FinishedTournamentSnapshot?> getFinishedTournament();

  Future<void> saveFinishedTournament(FinishedTournamentSnapshot snapshot);
}
