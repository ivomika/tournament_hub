import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

abstract interface class TournamentFormatStrategy<TState> {
  TournamentFormat get format;

  TState create(Iterable<TournamentParticipantId> participantIds);
}
