import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/tournament/value_objects/participant_id.dart';

final class TournamentPlacement extends Equatable {
  TournamentPlacement({
    required this.participantId,
    required int from,
    required int to,
  }) : from = _requirePositive(from, 'from'),
       to = _requirePositive(to, 'to') {
    if (to < from) {
      throw ArgumentError.value(
        to,
        'to',
        'Конец диапазона не может быть меньше начала.',
      );
    }
  }

  final ParticipantId participantId;
  final int from;
  final int to;

  bool get isExact => from == to;

  static int _requirePositive(int value, String name) {
    if (value < 1) {
      throw ArgumentError.value(value, name, '$name должен быть не меньше 1.');
    }
    return value;
  }

  @override
  List<Object> get props => [participantId, from, to];
}
