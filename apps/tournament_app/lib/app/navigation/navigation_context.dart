import 'package:tournament_app/app/routing/app_routes.dart';

final class NavigationEntryId {
  const NavigationEntryId(this.value);

  final int value;

  @override
  bool operator ==(Object other) =>
      other is NavigationEntryId && other.value == value;

  @override
  int get hashCode => value.hashCode;
}

enum NavigationProfileStatus { ready, registrationRequired }

enum NavigationProfileEditStatus { idle, saving, saved }

final class NavigationContext {
  const NavigationContext({
    required this.currentRoute,
    required this.entryId,
    required this.revision,
    required this.initialized,
    required this.canPop,
    this.profileStatus = NavigationProfileStatus.ready,
    this.profileEditStatus = NavigationProfileEditStatus.idle,
    this.previousRoute,
  });

  final AppRoute currentRoute;
  final NavigationEntryId entryId;
  final int revision;
  final bool initialized, canPop;
  final NavigationProfileStatus profileStatus;
  final NavigationProfileEditStatus profileEditStatus;
  final AppRoute? previousRoute;
}
