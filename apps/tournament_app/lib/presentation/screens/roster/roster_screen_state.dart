import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class RosterGuest {
  const RosterGuest({
    required this.name,
    required this.initials,
    required this.onRemove,
  });
  final String name, initials;
  final VoidCallback? onRemove;
}

@immutable
class RosterScreenState {
  RosterScreenState({
    required this.contextLabel,
    required Iterable<RosterGuest> guests,
  }) : guests = List.unmodifiable(guests);
  final String contextLabel;
  final List<RosterGuest> guests;
}
