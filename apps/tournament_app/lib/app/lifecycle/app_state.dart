import 'package:equatable/equatable.dart';

import '../../application/bootstrap/models/app_session_projection.dart';

enum AppStateKind {
  bootstrapping,
  profileRequired,
  operational,
  recoverableFailure,
  fatalFailure,
}

enum AppBootstrapStage { dependencies, profile, activeTournament }

enum AppProblemCode {
  dependencyUnavailable,
  profileReadFailed,
  activeTournamentReadFailed,
  inconsistentSession,
  unexpectedFailure,
}

enum AppRetryTarget { bootstrap }

sealed class AppState extends Equatable {
  const AppState();

  AppStateKind get kind;
}

final class AppBootstrapping extends AppState {
  const AppBootstrapping({required this.stage, required this.generation});

  final AppBootstrapStage stage;
  final int generation;

  @override
  AppStateKind get kind => AppStateKind.bootstrapping;

  @override
  List<Object?> get props => [stage, generation];
}

final class AppProfileRequired extends AppState {
  const AppProfileRequired();

  @override
  AppStateKind get kind => AppStateKind.profileRequired;

  @override
  List<Object?> get props => const [];
}

final class AppOperational extends AppState {
  const AppOperational(this.session);

  final AppSessionProjection session;

  @override
  AppStateKind get kind => AppStateKind.operational;

  @override
  List<Object?> get props => [session];
}

final class AppRecoverableFailure extends AppState {
  const AppRecoverableFailure({
    required this.problem,
    this.retryTarget = AppRetryTarget.bootstrap,
  });

  final AppProblemCode problem;
  final AppRetryTarget retryTarget;

  @override
  AppStateKind get kind => AppStateKind.recoverableFailure;

  @override
  List<Object?> get props => [problem, retryTarget];
}

final class AppFatalFailure extends AppState {
  const AppFatalFailure({required this.problem});

  final AppProblemCode problem;

  @override
  AppStateKind get kind => AppStateKind.fatalFailure;

  @override
  List<Object?> get props => [problem];
}
