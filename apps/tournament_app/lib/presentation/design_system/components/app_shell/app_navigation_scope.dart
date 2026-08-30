import 'package:flutter/widgets.dart';

import 'app_destination.dart';

final class AppNavigationScope extends InheritedWidget {
  const AppNavigationScope({
    required this.onDestinationSelected,
    required super.child,
    super.key,
  });

  final ValueChanged<AppDestination> onDestinationSelected;

  static AppNavigationScope? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppNavigationScope>();

  @override
  bool updateShouldNotify(AppNavigationScope oldWidget) =>
      onDestinationSelected != oldWidget.onDestinationSelected;
}
