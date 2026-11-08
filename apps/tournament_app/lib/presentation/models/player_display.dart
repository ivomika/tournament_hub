import 'package:flutter/foundation.dart';

@immutable
class PlayerDisplay {
  const PlayerDisplay({
    required this.character,
    required this.name,
    required this.initials,
  });
  final String character, name, initials;
}
