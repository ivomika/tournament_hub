import 'package:freezed_annotation/freezed_annotation.dart';

part 'tournament_participant_data.freezed.dart';

@freezed
abstract class TournamentParticipantData with _$TournamentParticipantData {
  const factory TournamentParticipantData({
    required String id,
    required String nickname,
    required String source,
    required int position,
  }) = _TournamentParticipantData;
}
