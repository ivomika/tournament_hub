import 'package:tournament_app/domain/tournament/entities/participant.dart';
import 'package:tournament_app/domain/tournament/entities/tournament.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_cancellation.dart';
import 'package:tournament_app/domain/tournament/value_objects/tournament_id.dart';

abstract interface class TournamentLifecyclePort {
  Future<Tournament> createDraft(Tournament draft);

  Future<Tournament> updateDraft(
    Tournament tournament, {
    required int expectedRevision,
  });

  Future<Tournament> open(
    TournamentId tournamentId, {
    required int expectedRevision,
  });

  Future<Tournament> addParticipant({
    required TournamentId tournamentId,
    required Participant participant,
    required int expectedRevision,
  });

  Future<Tournament> removeParticipant({
    required TournamentId tournamentId,
    required ParticipantId participantId,
    required int expectedRevision,
  });

  Future<Tournament> cancel({
    required TournamentId tournamentId,
    required TournamentCancellation cancellation,
    required int expectedRevision,
  });
}
