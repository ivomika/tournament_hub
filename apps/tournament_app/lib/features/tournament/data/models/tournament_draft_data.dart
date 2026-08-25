import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:tournament_app/features/tournament/data/models/tournament_participant_data.dart';

part 'tournament_draft_data.freezed.dart';

@freezed
abstract class TournamentDraftData with _$TournamentDraftData {
  const factory TournamentDraftData({
    required String id,
    required String name,
    required String status,
    required String format,
    required List<TournamentParticipantData> participants,
  }) = _TournamentDraftData;
}
