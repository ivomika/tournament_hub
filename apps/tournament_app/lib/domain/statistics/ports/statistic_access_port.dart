import 'package:tournament_app/domain/statistics/entities/statistic.dart';
import 'package:tournament_app/domain/statistics/models/shared_statistic.dart';

abstract interface class StatisticAccessPort {
  Iterable<SharedStatistic> project(Statistic statistic);
}
