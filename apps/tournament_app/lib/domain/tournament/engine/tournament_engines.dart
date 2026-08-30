export 'double_elimination_engine.dart';
export 'format_engine.dart';
export 'round_robin_engine.dart';
export 'single_elimination_engine.dart';

import 'double_elimination_engine.dart';
import 'format_engine.dart';
import 'round_robin_engine.dart';
import 'single_elimination_engine.dart';

TournamentFormatEngineRegistry createTournamentFormatEngineRegistryV1() =>
    TournamentFormatEngineRegistry(const [
      DoubleEliminationEngine(),
      SingleEliminationEngine(),
      RoundRobinEngine(),
    ]);
