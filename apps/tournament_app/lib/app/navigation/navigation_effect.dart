import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';

sealed class NavigationEffect {
  const NavigationEffect();
}

final class PushRouteEffect extends NavigationEffect {
  const PushRouteEffect(this.route);
  final AppRoute route;
}

final class GoToRouteEffect extends NavigationEffect {
  const GoToRouteEffect(this.route);
  final AppRoute route;
}

final class PopRouteEffect extends NavigationEffect {
  const PopRouteEffect(this.entryId);
  final NavigationEntryId entryId;
}
