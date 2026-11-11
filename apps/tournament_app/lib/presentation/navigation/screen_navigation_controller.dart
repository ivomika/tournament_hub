import 'dart:async';

import 'package:tournament_app/presentation/navigation/navigation_intent.dart';

class ScreenNavigationController {
  const ScreenNavigationController(this.navigation);

  final NavigationIntentSink navigation;

  void openProfile() {
    unawaited(navigation.submit(const OpenProfileIntent()));
  }

  void back() {
    unawaited(navigation.submit(const BackRequestedIntent()));
  }
}
