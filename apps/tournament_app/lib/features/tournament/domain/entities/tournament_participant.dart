import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/guest_profile/domain/entities/guest_profile.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_nickname.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_source.dart';

final class TournamentParticipant extends Equatable {
  const TournamentParticipant({
    required this.id,
    required this.nickname,
    required this.source,
  });

  factory TournamentParticipant.fromLocalProfile(LocalProfile profile) {
    return TournamentParticipant(
      id: TournamentParticipantId(profile.id.value),
      nickname: TournamentParticipantNickname(profile.nickname.value),
      source: TournamentParticipantSource.localProfile,
    );
  }

  factory TournamentParticipant.fromGuestProfile(GuestProfile profile) {
    return TournamentParticipant(
      id: TournamentParticipantId(profile.id.value),
      nickname: TournamentParticipantNickname(profile.nickname.value),
      source: TournamentParticipantSource.guestProfile,
    );
  }

  final TournamentParticipantId id;
  final TournamentParticipantNickname nickname;
  final TournamentParticipantSource source;

  @override
  List<Object> get props => [id, nickname, source];
}
