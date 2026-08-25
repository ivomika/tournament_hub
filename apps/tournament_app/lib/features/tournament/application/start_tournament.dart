import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';

final class StartTournament {
  const StartTournament(this._repository);

  final TournamentRepository _repository;

  Future<ActiveTournament> execute({
    required TournamentDraft draft,
    required TournamentSetup setup,
    required String rulesetId,
    required int rulesetVersion,
  }) async {
    final existing = await _repository.getActiveTournament();
    if (existing?.draft.id == draft.id) {
      if (existing!.rulesetId != rulesetId ||
          existing.rulesetVersion != rulesetVersion) {
        throw const TournamentValidationException(
          'Нельзя изменить ruleset после старта турнира.',
        );
      }
      return existing;
    }
    final tournament = ActiveTournament.fromSetup(
      draft: draft,
      setup: setup,
      rulesetId: rulesetId,
      rulesetVersion: rulesetVersion,
    );
    await _repository.saveActiveTournament(tournament);
    return tournament;
  }
}
