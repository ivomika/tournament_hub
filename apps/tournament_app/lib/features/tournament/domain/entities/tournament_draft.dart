import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_source.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_status.dart';

final class TournamentDraft extends Equatable {
  TournamentDraft({
    required this.id,
    required this.name,
    required Iterable<TournamentParticipant> participants,
  }) : status = TournamentStatus.draft,
       participants = List.unmodifiable(participants) {
    _validate();
  }

  final TournamentId id;
  final TournamentName name;
  final TournamentStatus status;
  final List<TournamentParticipant> participants;

  void _validate() {
    if (participants.length < 2) {
      throw const TournamentValidationException(
        'Для турнира нужны минимум два игрока.',
      );
    }

    final localProfiles = participants.where(
      (participant) =>
          participant.source == TournamentParticipantSource.localProfile,
    );
    if (localProfiles.length != 1) {
      throw const TournamentValidationException(
        'Турнир должен содержать ровно один локальный профиль.',
      );
    }

    final identities = participants
        .map(
          (participant) => '${participant.source.name}:${participant.id.value}',
        )
        .toSet();
    if (identities.length != participants.length) {
      throw const TournamentValidationException(
        'Один участник не может быть добавлен дважды.',
      );
    }
  }

  @override
  List<Object> get props => [id, name, status, participants];
}
