import 'package:tournament_app/app/navigation/navigation_effect.dart';
import 'package:tournament_app/app/navigation/navigation_context.dart';

sealed class NavigationDecision {
  const NavigationDecision();
}

final class NavigationAllowed extends NavigationDecision {
  const NavigationAllowed(this.effect, this.entryId, this.revision);
  final NavigationEffect effect;
  final NavigationEntryId entryId;
  final int revision;
}

enum NavigationRejection { alreadyAtDestination, notInitialized, unavailable }

final class NavigationDenied extends NavigationDecision {
  const NavigationDenied(this.reason);
  final NavigationRejection reason;
}
