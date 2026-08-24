import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/tournament/data/models/tournament_participant_data.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_nickname.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_source.dart';

final class TournamentParticipantMapper {
  const TournamentParticipantMapper();

  TournamentParticipantData fromDomain(
    TournamentParticipant participant,
    int position,
  ) {
    return TournamentParticipantData(
      id: participant.id.value,
      nickname: participant.nickname.value,
      source: participant.source.name,
      position: position,
    );
  }

  TournamentParticipantData fromRow(TournamentParticipantRow row) {
    return TournamentParticipantData(
      id: row.participantId,
      nickname: row.nickname,
      source: row.source,
      position: row.position,
    );
  }

  TournamentParticipant toDomain(TournamentParticipantData data) {
    return TournamentParticipant(
      id: TournamentParticipantId(data.id),
      nickname: TournamentParticipantNickname(data.nickname),
      source: TournamentParticipantSource.values.byName(data.source),
    );
  }

  TournamentParticipantsCompanion toCompanion(
    String tournamentId,
    TournamentParticipantData data,
  ) {
    return TournamentParticipantsCompanion.insert(
      tournamentId: tournamentId,
      participantId: data.id,
      nickname: data.nickname,
      source: data.source,
      position: data.position,
    );
  }
}
