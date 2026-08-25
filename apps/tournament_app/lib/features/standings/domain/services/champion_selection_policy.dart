import 'package:tournament_app/features/standings/domain/entities/tournament_standings.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

abstract interface class ChampionSelectionPolicy {
  TournamentParticipantId? select(TournamentStandings standings);
}
