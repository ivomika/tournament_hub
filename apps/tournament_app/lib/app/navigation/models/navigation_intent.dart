import 'package:equatable/equatable.dart';

import 'navigation_target.dart';

final class NavigationIntent extends Equatable {
  const NavigationIntent._({
    required this.target,
    this.tournamentId,
    this.snapshotId,
  });

  const NavigationIntent.main() : this._(target: NavigationTarget.main);

  const NavigationIntent.profile() : this._(target: NavigationTarget.profile);

  const NavigationIntent.history() : this._(target: NavigationTarget.history);

  const NavigationIntent.historyDetail({required String snapshotId})
    : this._(target: NavigationTarget.historyDetail, snapshotId: snapshotId);

  const NavigationIntent.settings() : this._(target: NavigationTarget.settings);

  const NavigationIntent.hostTournament({required String tournamentId})
    : this._(
        target: NavigationTarget.hostTournament,
        tournamentId: tournamentId,
      );

  const NavigationIntent.hostResultEntry({required String tournamentId})
    : this._(
        target: NavigationTarget.hostResultEntry,
        tournamentId: tournamentId,
      );

  const NavigationIntent.joinTournament()
    : this._(target: NavigationTarget.joinTournament);

  const NavigationIntent.participantTournament({required String tournamentId})
    : this._(
        target: NavigationTarget.participantTournament,
        tournamentId: tournamentId,
      );

  final NavigationTarget target;
  final String? tournamentId;
  final String? snapshotId;

  @override
  List<Object?> get props => [target, tournamentId, snapshotId];
}
