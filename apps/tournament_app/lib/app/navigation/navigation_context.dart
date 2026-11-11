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

final class NavigationContext {
  const NavigationContext({
    required this.currentRoute,
    required this.entryId,
    required this.revision,
    required this.initialized,
    required this.canPop,
  });
  final AppRoute currentRoute;
  final NavigationEntryId entryId;
  final int revision;
  final bool initialized, canPop;
}
