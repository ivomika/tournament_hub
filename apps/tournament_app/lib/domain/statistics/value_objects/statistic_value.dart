import 'package:equatable/equatable.dart';

sealed class StatisticValue extends Equatable {
  const StatisticValue();
}

final class CounterStatisticValue extends StatisticValue {
  CounterStatisticValue(int value) : value = _requireNonNegative(value);

  final int value;

  static int _requireNonNegative(int value) {
    if (value < 0) {
      throw ArgumentError.value(
        value,
        'value',
        'Счётчик не может быть отрицательным.',
      );
    }
    return value;
  }

  @override
  List<Object> get props => [value];
}

final class PlacementStatisticValue extends StatisticValue {
  PlacementStatisticValue(int value) : value = _requirePositive(value);

  final int value;

  static int _requirePositive(int value) {
    if (value < 1) {
      throw ArgumentError.value(
        value,
        'value',
        'Место должно быть не меньше 1.',
      );
    }
    return value;
  }

  @override
  List<Object> get props => [value];
}

final class PointsStatisticValue extends StatisticValue {
  PointsStatisticValue(int value) : value = _requireNonNegative(value);

  final int value;

  static int _requireNonNegative(int value) {
    if (value < 0) {
      throw ArgumentError.value(
        value,
        'value',
        'Points не могут быть отрицательными.',
      );
    }
    return value;
  }

  @override
  List<Object> get props => [value];
}
