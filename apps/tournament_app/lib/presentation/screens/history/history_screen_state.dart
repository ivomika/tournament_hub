import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

@immutable
class HistoryEntry {
  const HistoryEntry({
    required this.name,
    required this.dateLabel,
    required this.winnerCharacter,
    required this.winnerName,
    required this.initials,
    required this.onOpen,
  });
  final String name, dateLabel, winnerCharacter, winnerName, initials;
  final VoidCallback? onOpen;
}

@immutable
class HistoryScreenState {
  HistoryScreenState({
    required this.periodLabel,
    this.featured,
    required Iterable<HistoryEntry> entries,
  }) : entries = List.unmodifiable(entries);
  final String periodLabel;
  final HistoryEntry? featured;
  final List<HistoryEntry> entries;
}
