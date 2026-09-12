import 'package:equatable/equatable.dart';

final class ProfileId extends Equatable {
  ProfileId(String value) : value = _requireValue(value, 'ProfileId');

  final String value;

  static String _requireValue(String value, String type) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw ArgumentError.value(value, 'value', '$type не может быть пустым.');
    }
    return normalized;
  }

  @override
  List<Object> get props => [value];
}
