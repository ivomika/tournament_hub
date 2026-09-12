import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/ruleset_version.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/tournament_format_id.dart';

final class TournamentFormatKey extends Equatable {
  const TournamentFormatKey({required this.id, required this.rulesetVersion});

  final TournamentFormatId id;
  final RulesetVersion rulesetVersion;

  @override
  List<Object> get props => [id, rulesetVersion];
}
