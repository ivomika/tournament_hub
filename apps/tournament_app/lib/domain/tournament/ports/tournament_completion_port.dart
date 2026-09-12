import 'package:tournament_app/domain/tournament/entities/tournament.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

abstract interface class TournamentCompletionPort {
  Future<Tournament> finish({
    required TournamentId tournamentId,
    required int expectedRevision,
  });
}
