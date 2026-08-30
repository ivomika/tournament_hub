import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state_store.dart';
import 'package:tournament_hub_app/app/navigation/app_route_policy.dart';
import 'package:tournament_hub_app/app/navigation/app_router.dart';
import 'package:tournament_hub_app/app/navigation/models/app_route_id.dart';
import 'package:tournament_hub_app/app/navigation/models/navigation_intent.dart';
import 'package:tournament_hub_app/app/navigation/models/route_guard_failure.dart';
import 'package:tournament_hub_app/app/navigation/navigation_intent_store.dart';
import 'package:tournament_hub_app/application/bootstrap/models/active_tournament_projection.dart';
import 'package:tournament_hub_app/application/bootstrap/models/app_actor.dart';
import 'package:tournament_hub_app/application/bootstrap/models/app_session_projection.dart';
import 'package:tournament_hub_app/application/bootstrap/models/local_profile_projection.dart';
import 'package:tournament_hub_app/application/bootstrap/models/tournament_lifecycle_projection.dart';

void main() {
  const policy = AppRoutePolicy();
  const profile = LocalProfileProjection(id: 'profile-1', nickname: 'Jade');

  AppOperational operational([ActiveTournamentProjection? active]) =>
      AppOperational(
        AppSessionProjection(profile: profile, activeTournament: active),
      );

  ActiveTournamentProjection tournament(
    TournamentLifecycleProjection lifecycle, {
    AppActor actor = AppActor.host,
  }) => ActiveTournamentProjection(
    id: 'tournament-1',
    localProfileId: profile.id,
    actor: actor,
    lifecycle: lifecycle,
  );

  test('обязательные app states переопределяют navigation intent', () {
    expect(
      policy
          .project(
            const AppBootstrapping(
              stage: AppBootstrapStage.profile,
              generation: 1,
            ),
            const NavigationIntent.profile(),
          )
          .route,
      AppRouteId.bootstrap,
    );
    expect(
      policy
          .project(const AppProfileRequired(), const NavigationIntent.history())
          .route,
      AppRouteId.registration,
    );
    expect(
      policy
          .project(
            const AppRecoverableFailure(
              problem: AppProblemCode.profileReadFailed,
            ),
            const NavigationIntent.main(),
          )
          .route,
      AppRouteId.recoverableError,
    );
    expect(
      policy
          .project(
            const AppFatalFailure(
              problem: AppProblemCode.dependencyUnavailable,
            ),
            const NavigationIntent.main(),
          )
          .route,
      AppRouteId.fatalError,
    );
  });

  test('operational разрешает общие logical routes', () {
    final state = operational();

    expect(
      policy.project(state, const NavigationIntent.main()).route,
      AppRouteId.main,
    );
    expect(
      policy.project(state, const NavigationIntent.profile()).route,
      AppRouteId.profile,
    );
    expect(
      policy.project(state, const NavigationIntent.history()).route,
      AppRouteId.history,
    );
    expect(
      policy.project(state, const NavigationIntent.settings()).route,
      AppRouteId.settings,
    );
    expect(
      policy
          .project(
            state,
            const NavigationIntent.historyDetail(snapshotId: 'history-1'),
          )
          .route,
      AppRouteId.historyDetail,
    );
  });

  test('Host route следует authoritative tournament lifecycle', () {
    const routes = {
      TournamentLifecycleProjection.draft: AppRouteId.hostDraft,
      TournamentLifecycleProjection.open: AppRouteId.hostOpen,
      TournamentLifecycleProjection.distribution: AppRouteId.hostDistribution,
      TournamentLifecycleProjection.running: AppRouteId.hostRunning,
      TournamentLifecycleProjection.finished: AppRouteId.hostFinished,
      TournamentLifecycleProjection.cancelled: AppRouteId.hostCancelled,
    };

    for (final entry in routes.entries) {
      final projection = policy.project(
        operational(tournament(entry.key)),
        const NavigationIntent.hostTournament(tournamentId: 'tournament-1'),
      );
      expect(projection.route, entry.value, reason: entry.key.name);
    }
  });

  test('Participant route следует authoritative tournament lifecycle', () {
    const routes = {
      TournamentLifecycleProjection.draft: AppRouteId.participantLobby,
      TournamentLifecycleProjection.open: AppRouteId.participantLobby,
      TournamentLifecycleProjection.distribution:
          AppRouteId.participantDistribution,
      TournamentLifecycleProjection.running: AppRouteId.participantRunning,
      TournamentLifecycleProjection.finished: AppRouteId.participantFinished,
    };

    for (final entry in routes.entries) {
      final projection = policy.project(
        operational(tournament(entry.key, actor: AppActor.participant)),
        const NavigationIntent.participantTournament(
          tournamentId: 'tournament-1',
        ),
      );
      expect(projection.route, entry.value, reason: entry.key.name);
    }
  });

  test('guard не открывает чужой tournament или actor flow', () {
    final hostState = operational(
      tournament(TournamentLifecycleProjection.running),
    );

    expect(
      policy
          .project(
            hostState,
            const NavigationIntent.hostTournament(tournamentId: 'other'),
          )
          .guardFailure,
      RouteGuardFailure.tournamentMismatch,
    );
    expect(
      policy
          .project(
            hostState,
            const NavigationIntent.participantTournament(
              tournamentId: 'tournament-1',
            ),
          )
          .guardFailure,
      RouteGuardFailure.actorMismatch,
    );
    expect(
      policy
          .project(
            operational(),
            const NavigationIntent.hostTournament(tournamentId: 'tournament-1'),
          )
          .guardFailure,
      RouteGuardFailure.activeTournamentRequired,
    );
  });

  test('join блокируется при существующем active context', () {
    final projection = policy.project(
      operational(tournament(TournamentLifecycleProjection.open)),
      const NavigationIntent.joinTournament(),
    );

    expect(projection.route, AppRouteId.main);
    expect(projection.guardFailure, RouteGuardFailure.activeTournamentConflict);
  });

  test('result entry доступен только Host в Running', () {
    final running = policy.project(
      operational(tournament(TournamentLifecycleProjection.running)),
      const NavigationIntent.hostResultEntry(tournamentId: 'tournament-1'),
    );
    final open = policy.project(
      operational(tournament(TournamentLifecycleProjection.open)),
      const NavigationIntent.hostResultEntry(tournamentId: 'tournament-1'),
    );

    expect(running.route, AppRouteId.hostResultEntry);
    expect(open.route, AppRouteId.main);
    expect(open.guardFailure, RouteGuardFailure.lifecycleMismatch);
  });

  test('history detail требует typed snapshot id', () {
    final projection = policy.project(
      operational(),
      const NavigationIntent.historyDetail(snapshotId: '   '),
    );

    expect(projection.route, AppRouteId.history);
    expect(projection.guardFailure, RouteGuardFailure.historySnapshotRequired);
  });

  test('router реагирует на state и intent, не меняя AppState', () async {
    final stateStore = AppStateStore();
    final intentStore = NavigationIntentStore();
    final router = AppRouter(stateSource: stateStore, intentStore: intentStore);
    addTearDown(() async {
      await router.dispose();
      await intentStore.dispose();
      await stateStore.dispose();
    });
    router.start();

    final state = operational();
    stateStore.publish(state);
    expect(router.current.route, AppRouteId.main);

    router.go(const NavigationIntent.profile());
    expect(router.current.route, AppRouteId.profile);
    expect(stateStore.current, state);

    router.back();
    expect(router.current.route, AppRouteId.main);
    expect(stateStore.current, state);
  });
}
