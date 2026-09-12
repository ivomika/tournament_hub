import 'package:equatable/equatable.dart';

final class FirstTo extends Equatable {
  FirstTo(int winsRequired) : winsRequired = _requirePositive(winsRequired);

  final int winsRequired;

  static int _requirePositive(int value) {
    if (value < 1) {
      throw ArgumentError.value(
        value,
        'winsRequired',
        'FirstTo должен быть больше 0.',
      );
    }
    return value;
  }

  @override
  List<Object> get props => [winsRequired];
}
