import 'package:equatable/equatable.dart';

import 'app_actor.dart';
import 'tournament_lifecycle_projection.dart';

final class ActiveTournamentProjection extends Equatable {
  const ActiveTournamentProjection({
    required this.id,
    required this.localProfileId,
    required this.actor,
    required this.lifecycle,
  });

  final String id;
  final String localProfileId;
  final AppActor actor;
  final TournamentLifecycleProjection lifecycle;

  @override
  List<Object?> get props => [id, localProfileId, actor, lifecycle];
}
