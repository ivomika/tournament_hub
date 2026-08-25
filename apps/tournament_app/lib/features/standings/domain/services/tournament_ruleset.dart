import 'package:tournament_app/features/standings/domain/entities/tournament_outcome.dart';
import 'package:tournament_app/features/standings/domain/services/champion_selection_policy.dart';
import 'package:tournament_app/features/standings/domain/services/tournament_standings_calculator.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';

final class TournamentRuleset {
  const TournamentRuleset(
    this.id,
    this.version,
    this._standingsCalculator,
    this._championSelection,
  );

  final String id;
  final int version;
  final TournamentStandingsCalculator _standingsCalculator;
  final ChampionSelectionPolicy _championSelection;

  TournamentOutcome calculate(ActiveTournament tournament) {
    final standings = _standingsCalculator.calculate(tournament);
    return TournamentOutcome(
      rulesetId: id,
      rulesetVersion: version,
      standings: standings,
      championId: _championSelection.select(standings),
    );
  }
}
