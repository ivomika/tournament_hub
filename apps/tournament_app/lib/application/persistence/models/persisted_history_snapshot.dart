import 'package:equatable/equatable.dart';

import 'persisted_tournament_snapshot.dart';

final class PersistedHistorySnapshot extends Equatable {
  const PersistedHistorySnapshot({
    required this.snapshot,
    required this.finishedAtUtc,
  });

  final PersistedTournamentSnapshot snapshot;
  final DateTime finishedAtUtc;

  @override
  List<Object?> get props => [snapshot, finishedAtUtc];
}
