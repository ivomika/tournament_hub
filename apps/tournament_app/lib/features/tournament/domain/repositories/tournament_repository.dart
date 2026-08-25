import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';

abstract interface class TournamentRepository {
  Future<TournamentDraft?> getActiveDraft();

  Future<void> saveActiveDraft(TournamentDraft draft);

  Future<ActiveTournament?> getActiveTournament();

  Future<void> saveActiveTournament(ActiveTournament tournament);
}
