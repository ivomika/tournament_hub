import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/app/bootstrap/app_bootstrap.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state.dart';
import 'package:tournament_hub_app/app/lifecycle/app_state_store.dart';
import 'package:tournament_hub_app/application/bootstrap/errors/app_session_read_failure.dart';
import 'package:tournament_hub_app/application/bootstrap/models/active_tournament_projection.dart';
import 'package:tournament_hub_app/application/bootstrap/models/app_actor.dart';
import 'package:tournament_hub_app/application/bootstrap/models/local_profile_projection.dart';
import 'package:tournament_hub_app/application/bootstrap/models/tournament_lifecycle_projection.dart';
import 'package:tournament_hub_app/application/bootstrap/ports/app_session_reader.dart';

void main() {
  const profile = LocalProfileProjection(id: 'profile-1', nickname: 'Kitana');
  const activeTournament = ActiveTournamentProjection(
    id: 'tournament-1',
    localProfileId: 'profile-1',
    actor: AppActor.host,
    lifecycle: TournamentLifecycleProjection.open,
  );

  group('AppBootstrap', () {
    late AppStateStore store;

    setUp(() => store = AppStateStore());
    tearDown(() => store.dispose());

    test('публикует profileRequired при отсутствии профиля', () async {
      final reader = _FakeAppSessionReader();
      final bootstrap = AppBootstrap(reader, store);

      await bootstrap.start();

      expect(store.current, const AppProfileRequired());
      expect(reader.calls, ['availability', 'profile']);
    });

    test('восстанавливает согласованную operational session', () async {
      final reader = _FakeAppSessionReader(
        profile: profile,
        activeTournament: activeTournament,
      );
      final bootstrap = AppBootstrap(reader, store);

      await bootstrap.start();

      final state = store.current as AppOperational;
      expect(state.session.profile, profile);
      expect(state.session.activeTournament, activeTournament);
      expect(reader.calls, ['availability', 'profile', 'active:profile-1']);
    });

    test('не публикует несогласованный active context', () async {
      final reader = _FakeAppSessionReader(
        profile: profile,
        activeTournament: const ActiveTournamentProjection(
          id: 'tournament-1',
          localProfileId: 'another-profile',
          actor: AppActor.host,
          lifecycle: TournamentLifecycleProjection.running,
        ),
      );
      final bootstrap = AppBootstrap(reader, store);

      await bootstrap.start();

      expect(
        store.current,
        const AppRecoverableFailure(
          problem: AppProblemCode.inconsistentSession,
        ),
      );
    });

    test('маппит typed recoverable failure без внутренних деталей', () async {
      final reader = _FakeAppSessionReader(
        failure: const AppSessionReadFailure(
          code: AppSessionReadFailureCode.profileReadFailed,
          recoverable: true,
        ),
      );
      final bootstrap = AppBootstrap(reader, store);

      await bootstrap.start();

      expect(
        store.current,
        const AppRecoverableFailure(problem: AppProblemCode.profileReadFailed),
      );
    });

    test(
      'retry после recoverable failure заново восстанавливает state',
      () async {
        final reader = _FakeAppSessionReader(
          failure: const AppSessionReadFailure(
            code: AppSessionReadFailureCode.profileReadFailed,
            recoverable: true,
          ),
        );
        final bootstrap = AppBootstrap(reader, store);

        await bootstrap.start();
        expect(store.current, isA<AppRecoverableFailure>());

        reader
          ..failure = null
          ..profile = profile;
        await bootstrap.retry();

        expect((store.current as AppOperational).session.profile, profile);
      },
    );

    test('маппит non-recoverable failure в fatal state', () async {
      final reader = _FakeAppSessionReader(
        failure: const AppSessionReadFailure(
          code: AppSessionReadFailureCode.dependencyUnavailable,
          recoverable: false,
        ),
      );
      final bootstrap = AppBootstrap(reader, store);

      await bootstrap.start();

      expect(
        store.current,
        const AppFatalFailure(problem: AppProblemCode.dependencyUnavailable),
      );
    });

    test('late result старой попытки не заменяет новое состояние', () async {
      final firstProfile = Completer<LocalProfileProjection?>();
      var profileRead = 0;
      final reader = _FakeAppSessionReader(
        readProfile: () {
          profileRead++;
          if (profileRead == 1) return firstProfile.future;
          return Future.value(profile);
        },
      );
      final bootstrap = AppBootstrap(reader, store);

      final firstRun = bootstrap.start();
      await Future<void>.delayed(Duration.zero);
      await bootstrap.retry();
      expect(store.current, isA<AppOperational>());

      firstProfile.complete(null);
      await firstRun;

      expect((store.current as AppOperational).session.profile, profile);
    });

    test('dispose блокирует публикацию late result', () async {
      final pendingProfile = Completer<LocalProfileProjection?>();
      final reader = _FakeAppSessionReader(
        readProfile: () => pendingProfile.future,
      );
      final bootstrap = AppBootstrap(reader, store);

      final run = bootstrap.start();
      await Future<void>.delayed(Duration.zero);
      final stateBeforeDispose = store.current;
      bootstrap.dispose();
      pendingProfile.complete(profile);
      await run;

      expect(store.current, stateBeforeDispose);
    });
  });

  test('AppStateStore отклоняет запрещённый lifecycle transition', () async {
    final store = AppStateStore(
      initialState: const AppFatalFailure(
        problem: AppProblemCode.unexpectedFailure,
      ),
    );
    addTearDown(store.dispose);

    expect(
      () => store.publish(const AppProfileRequired()),
      throwsA(isA<StateError>()),
    );
  });
}

final class _FakeAppSessionReader implements AppSessionReader {
  _FakeAppSessionReader({
    this.profile,
    this.activeTournament,
    this.failure,
    this.readProfile,
  });

  LocalProfileProjection? profile;
  ActiveTournamentProjection? activeTournament;
  AppSessionReadFailure? failure;
  final Future<LocalProfileProjection?> Function()? readProfile;
  final List<String> calls = [];

  @override
  Future<void> validateAvailability() async {
    calls.add('availability');
    if (failure?.code == AppSessionReadFailureCode.dependencyUnavailable) {
      throw failure!;
    }
  }

  @override
  Future<LocalProfileProjection?> readLocalProfile() async {
    calls.add('profile');
    if (failure?.code == AppSessionReadFailureCode.profileReadFailed) {
      throw failure!;
    }
    return readProfile?.call() ?? profile;
  }

  @override
  Future<ActiveTournamentProjection?> readActiveTournament({
    required String localProfileId,
  }) async {
    calls.add('active:$localProfileId');
    if (failure?.code == AppSessionReadFailureCode.activeTournamentReadFailed) {
      throw failure!;
    }
    return activeTournament;
  }
}
