import 'package:tournament_app/domain/tournament/value_objects/match_result.dart';
import 'package:tournament_app/domain/tournament/value_objects/technical_result_reason.dart';

final class TechnicalMatchResult extends MatchResult {
  const TechnicalMatchResult({
    required super.winnerId,
    required super.loserId,
    required this.reason,
  });

  final TechnicalResultReason reason;

  @override
  List<Object> get props => [winnerId, loserId, reason];
}
