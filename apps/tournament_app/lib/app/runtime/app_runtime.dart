import '../lifecycle/app_state_source.dart';
import '../navigation/ports/app_route_source.dart';
import '../navigation/ports/navigation_intent_sink.dart';

abstract interface class AppRuntime {
  AppStateSource get appStateSource;

  AppRouteSource get appRouteSource;

  NavigationIntentSink get navigation;

  Future<void> start();

  Future<void> retry();

  void dispose();
}

abstract interface class AppProfileRuntime {
  Future<void> createProfile(String nickname);

  Future<void> renameProfile(String nickname);

  Future<void> resetAccount();
}
