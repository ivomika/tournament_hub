import 'package:equatable/equatable.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/tournament_format_id.dart';

abstract base class TournamentFormatSettings extends Equatable {
  const TournamentFormatSettings(this.formatId);

  final TournamentFormatId formatId;

  @override
  List<Object> get props => [formatId];
}
