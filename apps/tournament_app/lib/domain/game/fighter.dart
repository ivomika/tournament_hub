import 'package:equatable/equatable.dart';

final class FighterId extends Equatable implements Comparable<FighterId> {
  FighterId(String value) : value = value.trim() {
    if (!RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$').hasMatch(this.value)) {
      throw const FormatException('Fighter ID must be a stable slug.');
    }
  }

  final String value;

  @override
  int compareTo(FighterId other) => value.compareTo(other.value);

  @override
  List<Object?> get props => [value];
}

final class Fighter extends Equatable {
  Fighter({
    required this.id,
    required String displayName,
    required String assetPath,
  }) : displayName = displayName.trim(),
       assetPath = assetPath.trim() {
    if (this.displayName.isEmpty || this.assetPath.isEmpty) {
      throw const FormatException('Fighter metadata must be complete.');
    }
  }

  final FighterId id;
  final String displayName;
  final String assetPath;

  @override
  List<Object?> get props => [id, displayName, assetPath];
}
