import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/scheduled_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class TournamentRound extends Equatable {
  TournamentRound({
    required this.number,
    required Iterable<ScheduledTournamentMatch> matches,
    this.byeParticipantId,
  }) : matches = List.unmodifiable(matches) {
    _validate();
  }

  final int number;
  final List<ScheduledTournamentMatch> matches;
  final TournamentParticipantId? byeParticipantId;

  void _validate() {
    if (number < 1) {
      throw const TournamentValidationException(
        'Номер раунда должен быть положительным.',
      );
    }

    final participantIds = <TournamentParticipantId>{};
    for (final match in matches) {
      if (!participantIds.add(match.firstParticipantId) ||
          !participantIds.add(match.secondParticipantId)) {
        throw const TournamentValidationException(
          'Участник не может играть дважды в одном раунде.',
        );
      }
    }

    final bye = byeParticipantId;
    if (bye != null && participantIds.contains(bye)) {
      throw const TournamentValidationException(
        'Участник с bye не может играть в том же раунде.',
      );
    }
  }

  @override
  List<Object?> get props => [number, matches, byeParticipantId];
}
