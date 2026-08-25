import 'package:tournament_app/features/standings/domain/entities/tournament_standings.dart';
import 'package:tournament_app/features/standings/domain/services/champion_selection_policy.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class UniqueFirstPlaceChampionPolicy implements ChampionSelectionPolicy {
  const UniqueFirstPlaceChampionPolicy();

  @override
  TournamentParticipantId? select(TournamentStandings standings) {
    if (!standings.allMatchesCompleted ||
        !standings.hasUniquePositions ||
        standings.rows.isEmpty) {
      return null;
    }
    return standings.rows.first.participantId;
  }
}
