import 'package:tournament_app/features/standings/domain/services/mvp_tournament_scoring_policy.dart';
import 'package:tournament_app/features/standings/domain/services/standard_standings_tie_break_policy.dart';
import 'package:tournament_app/features/standings/domain/services/tournament_ruleset.dart';
import 'package:tournament_app/features/standings/domain/services/tournament_standings_calculator.dart';
import 'package:tournament_app/features/standings/domain/services/unique_first_place_champion_policy.dart';

final class MvpTournamentRuleset {
  const MvpTournamentRuleset._();

  static const id = 'mvp-round-robin';
  static const version = 1;

  static const instance = TournamentRuleset(
    id,
    version,
    TournamentStandingsCalculator(
      MvpTournamentScoringPolicy(),
      StandardStandingsTieBreakPolicy(),
    ),
    UniqueFirstPlaceChampionPolicy(),
  );
}
