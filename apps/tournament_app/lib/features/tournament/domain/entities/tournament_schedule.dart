import 'package:equatable/equatable.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_round.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class TournamentSchedule extends Equatable {
  TournamentSchedule({
    required Iterable<TournamentParticipantId> participantIds,
    required Iterable<TournamentRound> rounds,
  }) : participantIds = List.unmodifiable(participantIds),
       rounds = List.unmodifiable(rounds) {
    _validate();
  }

  final List<TournamentParticipantId> participantIds;
  final List<TournamentRound> rounds;

  void _validate() {
    final participants = participantIds.toSet();
    if (participantIds.length < 2 ||
        participants.length != participantIds.length) {
      throw const TournamentValidationException(
        'Расписание требует минимум двух уникальных участников.',
      );
    }

    final isOdd = participantIds.length.isOdd;
    final expectedRoundCount = isOdd
        ? participantIds.length
        : participantIds.length - 1;
    if (rounds.length != expectedRoundCount) {
      throw const TournamentValidationException(
        'Количество раундов не соответствует формату round robin.',
      );
    }

    final expectedMatchesPerRound = participantIds.length ~/ 2;
    final pairs = <(String, String)>{};
    for (var roundIndex = 0; roundIndex < rounds.length; roundIndex++) {
      final round = rounds[roundIndex];
      if (round.number != roundIndex + 1 ||
          round.matches.length != expectedMatchesPerRound) {
        throw const TournamentValidationException(
          'Матрица раундов имеет неверный порядок или размер.',
        );
      }

      final coveredParticipants = <TournamentParticipantId>{};
      for (final match in round.matches) {
        final first = match.firstParticipantId;
        final second = match.secondParticipantId;
        if (!participants.contains(first) || !participants.contains(second)) {
          throw const TournamentValidationException(
            'Расписание содержит неизвестного участника.',
          );
        }
        coveredParticipants
          ..add(first)
          ..add(second);

        final firstValue = first.value;
        final secondValue = second.value;
        final pair = firstValue.compareTo(secondValue) < 0
            ? (firstValue, secondValue)
            : (secondValue, firstValue);
        if (!pairs.add(pair)) {
          throw const TournamentValidationException(
            'Пара участников не может встречаться повторно.',
          );
        }
      }

      final bye = round.byeParticipantId;
      if (isOdd) {
        if (bye == null || !participants.contains(bye)) {
          throw const TournamentValidationException(
            'Нечётный состав требует одного корректного bye в каждом раунде.',
          );
        }
        coveredParticipants.add(bye);
      } else if (bye != null) {
        throw const TournamentValidationException(
          'Чётный состав не должен содержать bye.',
        );
      }

      if (coveredParticipants.length != participantIds.length) {
        throw const TournamentValidationException(
          'Раунд должен охватывать каждого участника ровно один раз.',
        );
      }
    }

    final expectedMatchCount =
        participantIds.length * (participantIds.length - 1) ~/ 2;
    if (pairs.length != expectedMatchCount) {
      throw const TournamentValidationException(
        'Расписание должно содержать каждую пару участников ровно один раз.',
      );
    }
  }

  @override
  List<Object> get props => [participantIds, rounds];
}
