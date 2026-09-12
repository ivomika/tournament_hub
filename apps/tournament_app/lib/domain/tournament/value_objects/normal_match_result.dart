import 'package:tournament_app/domain/tournament/value_objects/match_result.dart';

final class NormalMatchResult extends MatchResult {
  NormalMatchResult({
    required super.winnerId,
    required super.loserId,
    required int winnerScore,
    required int loserScore,
  }) : winnerScore = _requireNonNegative(winnerScore, 'winnerScore'),
       loserScore = _requireNonNegative(loserScore, 'loserScore');

  final int winnerScore;
  final int loserScore;

  static int _requireNonNegative(int value, String name) {
    if (value < 0) {
      throw ArgumentError.value(
        value,
        name,
        '$name не может быть отрицательным.',
      );
    }
    return value;
  }

  @override
  List<Object> get props => [winnerId, loserId, winnerScore, loserScore];
}
