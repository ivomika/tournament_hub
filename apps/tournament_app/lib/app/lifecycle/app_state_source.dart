import 'app_state.dart';

abstract interface class AppStateSource {
  AppState get current;

  Stream<AppState> get changes;
}
