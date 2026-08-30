import '../../application/bootstrap/models/active_tournament_projection.dart';
import '../../application/bootstrap/models/app_actor.dart';
import '../../application/bootstrap/models/tournament_lifecycle_projection.dart';
import '../lifecycle/app_state.dart';
import 'models/app_route_id.dart';
import 'models/app_route_projection.dart';
import 'models/navigation_intent.dart';
import 'models/navigation_target.dart';
import 'models/route_guard_failure.dart';

final class AppRoutePolicy {
  const AppRoutePolicy();

  AppRouteProjection project(AppState state, NavigationIntent intent) {
    return switch (state) {
      AppBootstrapping() => const AppRouteProjection(
        route: AppRouteId.bootstrap,
      ),
      AppProfileRequired() => const AppRouteProjection(
        route: AppRouteId.registration,
        guardFailure: RouteGuardFailure.profileRequired,
      ),
      AppRecoverableFailure(:final problem) => AppRouteProjection(
        route: AppRouteId.recoverableError,
        problem: problem,
      ),
      AppFatalFailure(:final problem) => AppRouteProjection(
        route: AppRouteId.fatalError,
        problem: problem,
      ),
      AppOperational(:final session) => _projectOperational(
        session.activeTournament,
        intent,
      ),
    };
  }

  AppRouteProjection _projectOperational(
    ActiveTournamentProjection? activeTournament,
    NavigationIntent intent,
  ) {
    return switch (intent.target) {
      NavigationTarget.main => const AppRouteProjection(route: AppRouteId.main),
      NavigationTarget.profile => const AppRouteProjection(
        route: AppRouteId.profile,
      ),
      NavigationTarget.history => const AppRouteProjection(
        route: AppRouteId.history,
      ),
      NavigationTarget.historyDetail => _historyDetail(intent),
      NavigationTarget.settings => const AppRouteProjection(
        route: AppRouteId.settings,
      ),
      NavigationTarget.joinTournament =>
        activeTournament == null
            ? const AppRouteProjection(route: AppRouteId.joinTournament)
            : const AppRouteProjection(
                route: AppRouteId.main,
                guardFailure: RouteGuardFailure.activeTournamentConflict,
              ),
      NavigationTarget.hostTournament => _hostTournament(
        activeTournament,
        intent,
      ),
      NavigationTarget.hostResultEntry => _hostResultEntry(
        activeTournament,
        intent,
      ),
      NavigationTarget.participantTournament => _participantTournament(
        activeTournament,
        intent,
      ),
    };
  }

  AppRouteProjection _historyDetail(NavigationIntent intent) {
    final snapshotId = intent.snapshotId;
    if (snapshotId == null || snapshotId.trim().isEmpty) {
      return const AppRouteProjection(
        route: AppRouteId.history,
        guardFailure: RouteGuardFailure.historySnapshotRequired,
      );
    }
    return AppRouteProjection(
      route: AppRouteId.historyDetail,
      snapshotId: snapshotId,
    );
  }

  AppRouteProjection _hostTournament(
    ActiveTournamentProjection? activeTournament,
    NavigationIntent intent,
  ) {
    final guard = _activeGuard(activeTournament, intent, AppActor.host);
    if (guard != null) return guard;

    final route = switch (activeTournament!.lifecycle) {
      TournamentLifecycleProjection.draft => AppRouteId.hostDraft,
      TournamentLifecycleProjection.open => AppRouteId.hostOpen,
      TournamentLifecycleProjection.distribution => AppRouteId.hostDistribution,
      TournamentLifecycleProjection.running => AppRouteId.hostRunning,
      TournamentLifecycleProjection.finished => AppRouteId.hostFinished,
      TournamentLifecycleProjection.cancelled => AppRouteId.hostCancelled,
    };
    return AppRouteProjection(route: route, tournamentId: activeTournament.id);
  }

  AppRouteProjection _hostResultEntry(
    ActiveTournamentProjection? activeTournament,
    NavigationIntent intent,
  ) {
    final guard = _activeGuard(activeTournament, intent, AppActor.host);
    if (guard != null) return guard;
    if (activeTournament!.lifecycle != TournamentLifecycleProjection.running) {
      return const AppRouteProjection(
        route: AppRouteId.main,
        guardFailure: RouteGuardFailure.lifecycleMismatch,
      );
    }
    return AppRouteProjection(
      route: AppRouteId.hostResultEntry,
      tournamentId: activeTournament.id,
    );
  }

  AppRouteProjection _participantTournament(
    ActiveTournamentProjection? activeTournament,
    NavigationIntent intent,
  ) {
    final guard = _activeGuard(activeTournament, intent, AppActor.participant);
    if (guard != null) return guard;

    final route = switch (activeTournament!.lifecycle) {
      TournamentLifecycleProjection.draft ||
      TournamentLifecycleProjection.open => AppRouteId.participantLobby,
      TournamentLifecycleProjection.distribution =>
        AppRouteId.participantDistribution,
      TournamentLifecycleProjection.running => AppRouteId.participantRunning,
      TournamentLifecycleProjection.finished => AppRouteId.participantFinished,
      TournamentLifecycleProjection.cancelled => AppRouteId.main,
    };
    return AppRouteProjection(
      route: route,
      tournamentId: activeTournament.id,
      guardFailure:
          activeTournament.lifecycle == TournamentLifecycleProjection.cancelled
          ? RouteGuardFailure.lifecycleMismatch
          : null,
    );
  }

  AppRouteProjection? _activeGuard(
    ActiveTournamentProjection? activeTournament,
    NavigationIntent intent,
    AppActor requiredActor,
  ) {
    if (activeTournament == null) {
      return const AppRouteProjection(
        route: AppRouteId.main,
        guardFailure: RouteGuardFailure.activeTournamentRequired,
      );
    }
    if (activeTournament.id != intent.tournamentId) {
      return const AppRouteProjection(
        route: AppRouteId.main,
        guardFailure: RouteGuardFailure.tournamentMismatch,
      );
    }
    if (activeTournament.actor != requiredActor) {
      return const AppRouteProjection(
        route: AppRouteId.main,
        guardFailure: RouteGuardFailure.actorMismatch,
      );
    }
    return null;
  }
}
