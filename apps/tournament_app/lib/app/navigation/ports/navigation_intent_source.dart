import '../models/navigation_intent.dart';

abstract interface class NavigationIntentSource {
  NavigationIntent get current;

  Stream<NavigationIntent> get changes;
}
