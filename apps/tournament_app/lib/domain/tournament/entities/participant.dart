import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/profile/value_objects/nickname.dart';
import 'package:tournament_app/domain/profile/value_objects/profile_id.dart';
import 'package:tournament_app/domain/statistics/entities/participant_tournament_statistic.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_status.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_type.dart';

final class Participant extends Equatable {
  Participant.profile({
    required this.id,
    required this.tournamentNickname,
    required this.profileId,
    this.status = ParticipantStatus.active,
    ParticipantTournamentStatistic? statistic,
  }) : type = ParticipantType.profile,
       statistic =
           statistic ??
           ParticipantTournamentStatistic(
             tournamentId: id.tournamentId,
             participantId: id,
           );

  Participant.guest({
    required this.id,
    required this.tournamentNickname,
    this.status = ParticipantStatus.active,
    ParticipantTournamentStatistic? statistic,
  }) : type = ParticipantType.guest,
       profileId = null,
       statistic =
           statistic ??
           ParticipantTournamentStatistic(
             tournamentId: id.tournamentId,
             participantId: id,
           );

  final ParticipantId id;
  final Nickname tournamentNickname;
  final ParticipantType type;
  final ProfileId? profileId;
  final ParticipantStatus status;
  final ParticipantTournamentStatistic statistic;

  Participant withStatus(ParticipantStatus nextStatus) {
    if (status != ParticipantStatus.active &&
        nextStatus == ParticipantStatus.active) {
      throw StateError(
        'Eliminated и Withdrawn Participant не возвращаются в Active.',
      );
    }
    return Participant._copy(this, status: nextStatus);
  }

  Participant._copy(Participant source, {required this.status})
    : id = source.id,
      tournamentNickname = source.tournamentNickname,
      type = source.type,
      profileId = source.profileId,
      statistic = source.statistic;

  @override
  List<Object?> get props => [
    id,
    tournamentNickname,
    type,
    profileId,
    status,
    statistic,
  ];
}
