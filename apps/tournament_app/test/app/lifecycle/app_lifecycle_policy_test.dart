import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/app/lifecycle/app_lifecycle_policy.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state.dart';
import 'package:tournament_hub_app/application/bootstrap/models/app_session_projection.dart';
import 'package:tournament_hub_app/application/bootstrap/models/local_profile_projection.dart';

void main() {
  const policy = AppLifecyclePolicy();
  const states = <AppStateKind, AppState>{
    AppStateKind.bootstrapping: AppBootstrapping(
      stage: AppBootstrapStage.dependencies,
      generation: 1,
    ),
    AppStateKind.profileRequired: AppProfileRequired(),
    AppStateKind.operational: AppOperational(
      AppSessionProjection(
        profile: LocalProfileProjection(id: 'profile-1', nickname: 'Mileena'),
      ),
    ),
    AppStateKind.recoverableFailure: AppRecoverableFailure(
      problem: AppProblemCode.profileReadFailed,
    ),
    AppStateKind.fatalFailure: AppFatalFailure(
      problem: AppProblemCode.dependencyUnavailable,
    ),
  };
  const allowed = <AppStateKind, Set<AppStateKind>>{
    AppStateKind.bootstrapping: {
      AppStateKind.bootstrapping,
      AppStateKind.profileRequired,
      AppStateKind.operational,
      AppStateKind.recoverableFailure,
      AppStateKind.fatalFailure,
    },
    AppStateKind.profileRequired: {
      AppStateKind.bootstrapping,
      AppStateKind.operational,
      AppStateKind.recoverableFailure,
      AppStateKind.fatalFailure,
    },
    AppStateKind.operational: {
      AppStateKind.bootstrapping,
      AppStateKind.operational,
      AppStateKind.recoverableFailure,
      AppStateKind.fatalFailure,
    },
    AppStateKind.recoverableFailure: {
      AppStateKind.bootstrapping,
      AppStateKind.operational,
      AppStateKind.fatalFailure,
    },
    AppStateKind.fatalFailure: {},
  };

  test('полная transition matrix совпадает с ADR-0011', () {
    for (final from in AppStateKind.values) {
      for (final to in AppStateKind.values) {
        expect(
          policy.canTransition(states[from]!, states[to]!),
          allowed[from]!.contains(to),
          reason: '${from.name} -> ${to.name}',
        );
      }
    }
  });
}
