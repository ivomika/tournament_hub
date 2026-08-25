import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';

final class ActiveTournament extends Equatable {
  ActiveTournament({
    required this.draft,
    required this.setup,
    required Iterable<TournamentMatch> matches,
    this.rulesetId = 'mvp-round-robin',
    this.rulesetVersion = 1,
  }) : matches = List.unmodifiable(matches) {
    if (draft.id != setup.tournamentId) {
      throw const TournamentValidationException(
        'Draft и подготовленное состояние относятся к разным турнирам.',
      );
    }
    final scheduledMatches = setup.schedule.rounds
        .expand((round) => round.matches)
        .toList();
    final scheduledById = {
      for (final match in scheduledMatches) match.id: match,
    };
    final matchIds = this.matches
        .map((match) => match.scheduledMatch.id)
        .toSet();
    final hasChangedPair = this.matches.any(
      (match) => scheduledById[match.scheduledMatch.id] != match.scheduledMatch,
    );
    if (matches.length != scheduledMatches.length ||
        matchIds.length != scheduledMatches.length ||
        hasChangedPair) {
      throw const TournamentValidationException(
        'Активный турнир должен содержать состояние каждого матча.',
      );
    }
  }

  factory ActiveTournament.fromSetup({
    required TournamentDraft draft,
    required TournamentSetup setup,
    String rulesetId = 'mvp-round-robin',
    int rulesetVersion = 1,
  }) {
    return ActiveTournament(
      draft: draft,
      setup: setup,
      rulesetId: rulesetId,
      rulesetVersion: rulesetVersion,
      matches: setup.schedule.rounds
          .expand((round) => round.matches)
          .map(TournamentMatch.planned),
    );
  }

  final TournamentDraft draft;
  final TournamentSetup setup;
  final List<TournamentMatch> matches;
  final String rulesetId;
  final int rulesetVersion;

  ActiveTournament replaceMatch(TournamentMatch match) {
    final index = matches.indexWhere(
      (item) => item.scheduledMatch.id == match.scheduledMatch.id,
    );
    if (index < 0) {
      throw const TournamentValidationException(
        'Матч не принадлежит активному турниру.',
      );
    }
    final updated = [...matches]..[index] = match;
    return ActiveTournament(
      draft: draft,
      setup: setup,
      matches: updated,
      rulesetId: rulesetId,
      rulesetVersion: rulesetVersion,
    );
  }

  @override
  List<Object> get props => [draft, setup, matches, rulesetId, rulesetVersion];
}
