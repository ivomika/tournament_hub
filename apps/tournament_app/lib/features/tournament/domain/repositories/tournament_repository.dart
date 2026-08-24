import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';

abstract interface class TournamentRepository {
  Future<TournamentDraft?> getActiveDraft();

  Future<void> saveActiveDraft(TournamentDraft draft);
}
