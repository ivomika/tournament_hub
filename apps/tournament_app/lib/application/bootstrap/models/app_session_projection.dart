import 'package:equatable/equatable.dart';

import 'active_tournament_projection.dart';
import 'local_profile_projection.dart';

final class AppSessionProjection extends Equatable {
  const AppSessionProjection({required this.profile, this.activeTournament});

  final LocalProfileProjection profile;
  final ActiveTournamentProjection? activeTournament;

  @override
  List<Object?> get props => [profile, activeTournament];
}
