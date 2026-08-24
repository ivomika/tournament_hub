import 'package:tournament_app/features/tournament/domain/entities/tournament_schedule.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

abstract interface class TournamentRules {
  TournamentSchedule createSchedule(
    Iterable<TournamentParticipantId> participantIds,
  );
}
