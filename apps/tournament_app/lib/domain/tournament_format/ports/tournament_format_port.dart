import 'package:tournament_app/domain/tournament/entities/participant.dart';
import 'package:tournament_app/domain/tournament/value_objects/match_result.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_outcome.dart';
import 'package:tournament_app/domain/tournament_format/models/tournament_format_state.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/tournament_format_key.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/tournament_format_settings.dart';

abstract interface class TournamentFormatPort {
  TournamentFormatKey get key;

  TournamentFormatState createInitialState({
    required Iterable<Participant> participants,
    required TournamentFormatSettings settings,
    required Iterable<ParticipantId> seed,
  });

  TournamentFormatState applyResult({
    required TournamentFormatState state,
    required MatchResult result,
  });

  TournamentFormatState withdraw({
    required TournamentFormatState state,
    required ParticipantId participantId,
  });

  TournamentFormatState correctResult({
    required TournamentFormatState state,
    required MatchResult replacement,
  });

  TournamentOutcome outcomeFor(TournamentFormatState state);
}
