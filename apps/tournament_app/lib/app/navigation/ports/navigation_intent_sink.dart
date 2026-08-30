import '../models/navigation_intent.dart';

abstract interface class NavigationIntentSink {
  void go(NavigationIntent intent);

  void back();
}
