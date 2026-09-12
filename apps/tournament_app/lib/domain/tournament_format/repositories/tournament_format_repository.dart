import 'package:tournament_app/domain/tournament_format/ports/tournament_format_port.dart';
import 'package:tournament_app/domain/tournament_format/value_objects/tournament_format_key.dart';

abstract interface class TournamentFormatRepository {
  TournamentFormatPort resolve(TournamentFormatKey key);
}
