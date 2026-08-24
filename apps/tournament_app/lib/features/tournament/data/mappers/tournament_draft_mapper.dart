import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/tournament/data/mappers/tournament_participant_mapper.dart';
import 'package:tournament_app/features/tournament/data/models/tournament_draft_data.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_status.dart';

final class TournamentDraftMapper {
  const TournamentDraftMapper();

  static const _participantMapper = TournamentParticipantMapper();

  TournamentDraftData fromDomain(TournamentDraft draft) {
    return TournamentDraftData(
      id: draft.id.value,
      name: draft.name.value,
      status: draft.status.name,
      participants: [
        for (final (position, participant) in draft.participants.indexed)
          _participantMapper.fromDomain(participant, position),
      ],
    );
  }

  TournamentDraftData fromRows(
    TournamentDraftRow draft,
    List<TournamentParticipantRow> participants,
  ) {
    return TournamentDraftData(
      id: draft.id,
      name: draft.name,
      status: draft.status,
      participants: participants.map(_participantMapper.fromRow).toList(),
    );
  }

  TournamentDraft toDomain(TournamentDraftData data) {
    if (TournamentStatus.values.byName(data.status) != TournamentStatus.draft) {
      throw FormatException('Неподдерживаемый статус турнира: ${data.status}.');
    }
    return TournamentDraft(
      id: TournamentId(data.id),
      name: TournamentName(data.name),
      participants: data.participants.map(_participantMapper.toDomain),
    );
  }

  TournamentDraftsCompanion toCompanion(TournamentDraftData data) {
    return TournamentDraftsCompanion.insert(
      id: data.id,
      name: data.name,
      status: data.status,
    );
  }

  List<TournamentParticipantsCompanion> participantsToCompanions(
    TournamentDraftData data,
  ) {
    return data.participants
        .map(
          (participant) => _participantMapper.toCompanion(data.id, participant),
        )
        .toList(growable: false);
  }
}
