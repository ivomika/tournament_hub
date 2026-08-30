import 'app_state.dart';

abstract interface class AppStateWriter {
  void publish(AppState state);
}
