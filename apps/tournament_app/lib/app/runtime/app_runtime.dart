import '../lifecycle/app_state_source.dart';

abstract interface class AppRuntime {
  AppStateSource get appStateSource;

  Future<void> start();

  Future<void> retry();

  void dispose();
}
