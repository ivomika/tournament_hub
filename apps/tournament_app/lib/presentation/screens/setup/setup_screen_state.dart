import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

enum TournamentFormatDisplay {
  doubleElimination,
  singleElimination,
  roundRobin,
}

@immutable
class SetupFtControl {
  const SetupFtControl({
    required this.label,
    required this.valueLabel,
    required this.onDecrease,
    required this.onIncrease,
  });
  final String label, valueLabel;
  final VoidCallback? onDecrease, onIncrease;
}

@immutable
class SetupScreenState {
  SetupScreenState({
    required this.format,
    required this.formatTitle,
    required this.formatHint,
    required Iterable<SetupFtControl> controls,
    this.notice,
  }) : controls = List.unmodifiable(controls);
  final TournamentFormatDisplay format;
  final String formatTitle, formatHint;
  final String? notice;
  final List<SetupFtControl> controls;
}
