import 'package:equatable/equatable.dart';

import '../../lifecycle/app_state.dart';
import 'app_route_id.dart';
import 'route_guard_failure.dart';

final class AppRouteProjection extends Equatable {
  const AppRouteProjection({
    required this.route,
    this.tournamentId,
    this.snapshotId,
    this.problem,
    this.guardFailure,
  });

  final AppRouteId route;
  final String? tournamentId;
  final String? snapshotId;
  final AppProblemCode? problem;
  final RouteGuardFailure? guardFailure;

  @override
  List<Object?> get props => [
    route,
    tournamentId,
    snapshotId,
    problem,
    guardFailure,
  ];
}
