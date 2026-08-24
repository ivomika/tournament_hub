import 'dart:math' as math;

import 'package:tournament_app/features/tournament/domain/services/random_index_generator.dart';

final class DartRandomIndexGenerator implements RandomIndexGenerator {
  DartRandomIndexGenerator([math.Random? random])
    : _random = random ?? math.Random();

  final math.Random _random;

  @override
  int nextInt(int upperBound) => _random.nextInt(upperBound);
}
