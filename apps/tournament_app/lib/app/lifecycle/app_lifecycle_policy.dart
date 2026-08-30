import 'app_state.dart';

final class AppLifecyclePolicy {
  const AppLifecyclePolicy();

  bool canTransition(AppState from, AppState to) {
    return switch (from.kind) {
      AppStateKind.bootstrapping => switch (to.kind) {
        AppStateKind.bootstrapping ||
        AppStateKind.profileRequired ||
        AppStateKind.operational ||
        AppStateKind.recoverableFailure ||
        AppStateKind.fatalFailure => true,
      },
      AppStateKind.profileRequired => switch (to.kind) {
        AppStateKind.bootstrapping ||
        AppStateKind.operational ||
        AppStateKind.recoverableFailure ||
        AppStateKind.fatalFailure => true,
        AppStateKind.profileRequired => false,
      },
      AppStateKind.operational => switch (to.kind) {
        AppStateKind.bootstrapping ||
        AppStateKind.operational ||
        AppStateKind.recoverableFailure ||
        AppStateKind.fatalFailure => true,
        AppStateKind.profileRequired => false,
      },
      AppStateKind.recoverableFailure => switch (to.kind) {
        AppStateKind.bootstrapping ||
        AppStateKind.operational ||
        AppStateKind.fatalFailure => true,
        AppStateKind.profileRequired ||
        AppStateKind.recoverableFailure => false,
      },
      AppStateKind.fatalFailure => false,
    };
  }
}
