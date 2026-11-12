import 'package:tournament_app/app/navigation/navigation_context.dart';
import 'package:tournament_app/app/navigation/navigation_decision.dart';
import 'package:tournament_app/app/navigation/navigation_effect.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/presentation/navigation/navigation_intent.dart';

class NavigationGuard {
  const NavigationGuard();

  bool canEnter(AppRoute route, NavigationContext context) {
    if (route is BootstrapRoute) return true;
    if (!context.initialized) return false;
    if (context.profileStatus == NavigationProfileStatus.registrationRequired) {
      return route is RegistrationRoute;
    }
    return route is! RegistrationRoute;
  }

  NavigationDecision evaluate(
    NavigationIntent intent,
    NavigationContext context,
  ) {
    if (!context.initialized) {
      return const NavigationDenied(NavigationRejection.notInitialized);
    }
    if (context.profileStatus == NavigationProfileStatus.registrationRequired) {
      return const NavigationDenied(NavigationRejection.unavailable);
    }
    if (intent is ProfileRegisteredIntent &&
        context.currentRoute is RegistrationRoute) {
      return NavigationAllowed(
        const GoToRouteEffect(HomeRoute()),
        context.entryId,
        context.revision,
      );
    }
    if (intent is OpenProfileIntent) {
      if (context.currentRoute is ProfileRoute) {
        return const NavigationDenied(NavigationRejection.alreadyAtDestination);
      }
      if (context.currentRoute is! HomeRoute) {
        return const NavigationDenied(NavigationRejection.unavailable);
      }
      return NavigationAllowed(
        const PushRouteEffect(ProfileRoute()),
        context.entryId,
        context.revision,
      );
    }
    if (intent is OpenTournamentIntent && context.currentRoute is HomeRoute) {
      return NavigationAllowed(
        PushRouteEffect(TournamentRoute(intent.tournamentId)),
        context.entryId,
        context.revision,
      );
    }
    if (intent is BootstrapCompletedIntent &&
        context.currentRoute is BootstrapRoute) {
      return NavigationAllowed(
        const GoToRouteEffect(HomeRoute()),
        context.entryId,
        context.revision,
      );
    }
    if (intent is BackRequestedIntent) {
      if (context.canPop) {
        return NavigationAllowed(
          PopRouteEffect(context.entryId),
          context.entryId,
          context.revision,
        );
      }
      if (context.currentRoute is ProfileRoute ||
          context.currentRoute is TournamentRoute) {
        return NavigationAllowed(
          const GoToRouteEffect(HomeRoute()),
          context.entryId,
          context.revision,
        );
      }
    }
    return const NavigationDenied(NavigationRejection.unavailable);
  }
}
