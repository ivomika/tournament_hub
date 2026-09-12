import 'package:equatable/equatable.dart';

final class RulesetVersion extends Equatable {
  RulesetVersion(String value) : value = _requireValue(value);

  final String value;

  static String _requireValue(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(
        value,
        'value',
        'RulesetVersion не может быть пустым.',
      );
    }
    return normalized;
  }

  @override
  List<Object> get props => [value];
}
