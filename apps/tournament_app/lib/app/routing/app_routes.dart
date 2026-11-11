import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tournament_app/domain/tournament/tournament_id.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/presentation/screens/home/home_screen.dart';
import 'package:tournament_app/presentation/screens/home/home_screen_state.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen_state.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen_state.dart';

part 'app_routes.g.dart';

abstract class AppRoute extends GoRouteData {
  const AppRoute();

  @override
  String get location;

  static AppRoute decode(GoRouterState state) {
    final candidates = <AppRoute>[
      const HomeRoute(),
      const ProfileRoute(),
      const BootstrapRoute(),
      const UtilityRoute(),
      const ProfileEditRoute(),
      const SettingsRoute(),
      const AboutRoute(),
      const ContactRoute(),
      const HistoryRoute(),
      const SetupRoute(),
    ];
    final encodedIdentifier = state.pathParameters['tournamentId'];
    if (encodedIdentifier != null) {
      final identifier = TournamentRoute.decodeId(encodedIdentifier);
      candidates.addAll([
        TournamentRoute(identifier),
        RosterRoute(identifier),
        ParticipantAccessRoute(identifier),
        GuestAddRoute(identifier),
        GuestRemoveRoute(identifier),
        DistributionRoute(identifier),
        SpectatorAccessRoute(identifier),
        TieRoute(identifier),
        WithdrawRoute(identifier),
        ResultLockedRoute(identifier),
        BracketRoute(identifier),
        MatchResultRoute(identifier),
        ForfeitRoute(identifier),
        ChampionRoute(identifier),
        ResultsRoute(identifier),
      ]);
    }
    for (final candidate in candidates) {
      if (Uri.parse(candidate.location).path == state.uri.path) {
        return candidate;
      }
    }
    throw const FormatException('Unknown navigation destination');
  }

  bool _allowExit(BuildContext context) =>
      AppNavigationScope.of(context).allowExit();
}

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: [
    TypedGoRoute<ProfileRoute>(path: 'profile'),
    TypedGoRoute<UtilityRoute>(path: 'utility'),
    TypedGoRoute<ProfileEditRoute>(path: 'profile/edit'),
    TypedGoRoute<SettingsRoute>(path: 'settings'),
    TypedGoRoute<AboutRoute>(path: 'about'),
    TypedGoRoute<ContactRoute>(path: 'contact'),
    TypedGoRoute<HistoryRoute>(path: 'history'),
    TypedGoRoute<SetupRoute>(path: 'setup'),
    TypedGoRoute<TournamentRoute>(path: 'tournament/:tournamentId'),
    TypedGoRoute<RosterRoute>(path: 'tournament/:tournamentId/roster'),
    TypedGoRoute<ParticipantAccessRoute>(
      path: 'tournament/:tournamentId/participant-access',
    ),
    TypedGoRoute<GuestAddRoute>(path: 'tournament/:tournamentId/guest-add'),
    TypedGoRoute<GuestRemoveRoute>(
      path: 'tournament/:tournamentId/guest-remove',
    ),
    TypedGoRoute<DistributionRoute>(
      path: 'tournament/:tournamentId/distribution',
    ),
    TypedGoRoute<SpectatorAccessRoute>(
      path: 'tournament/:tournamentId/spectator-access',
    ),
    TypedGoRoute<TieRoute>(path: 'tournament/:tournamentId/tie'),
    TypedGoRoute<WithdrawRoute>(path: 'tournament/:tournamentId/withdraw'),
    TypedGoRoute<ResultLockedRoute>(
      path: 'tournament/:tournamentId/result-locked',
    ),
    TypedGoRoute<BracketRoute>(path: 'tournament/:tournamentId/bracket'),
    TypedGoRoute<MatchResultRoute>(
      path: 'tournament/:tournamentId/match-result',
    ),
    TypedGoRoute<ForfeitRoute>(path: 'tournament/:tournamentId/forfeit'),
    TypedGoRoute<ChampionRoute>(path: 'tournament/:tournamentId/champion'),
    TypedGoRoute<ResultsRoute>(path: 'tournament/:tournamentId/results'),
  ],
)
class HomeRoute extends AppRoute with $HomeRoute {
  const HomeRoute();

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.home;
    if (builder != null) return builder(context, this, controller);
    return HomeScreen(
      state: const HomeScreenState(),
      onProfile: controller.openProfile,
      onHistory: null,
      onCreate: null,
      onContinue: null,
    );
  }
}

class ProfileRoute extends AppRoute with $ProfileRoute {
  const ProfileRoute();

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.profile;
    if (builder != null) return builder(context, this, controller);
    return ProfileScreen(
      state: const ProfileScreenState(name: '', initials: ''),
      onBack: controller.back,
      onEdit: null,
      onCreate: null,
      onRecent: null,
      onSettings: null,
      onAbout: null,
      onContact: null,
    );
  }
}

@TypedGoRoute<BootstrapRoute>(path: '/bootstrap')
class BootstrapRoute extends AppRoute with $BootstrapRoute {
  const BootstrapRoute();

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.bootstrap;
    if (builder != null) return builder(context, this, controller);
    return const BootstrapScreen(
      state: BootstrapScreenState(phase: BootstrapPhase.loading),
      onRetry: null,
    );
  }
}

class TournamentRoute extends AppRoute with $TournamentRoute {
  const TournamentRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  static String encodeId(TournamentId id) => id.value;

  static TournamentId decodeId(String value) => TournamentId(value);

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.tournament;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class UtilityRoute extends AppRoute with $UtilityRoute {
  const UtilityRoute();

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.utility;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class ProfileEditRoute extends AppRoute with $ProfileEditRoute {
  const ProfileEditRoute();

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.profileEdit;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class SettingsRoute extends AppRoute with $SettingsRoute {
  const SettingsRoute();

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.settings;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class AboutRoute extends AppRoute with $AboutRoute {
  const AboutRoute();

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.about;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class ContactRoute extends AppRoute with $ContactRoute {
  const ContactRoute();

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.contact;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class HistoryRoute extends AppRoute with $HistoryRoute {
  const HistoryRoute();

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.history;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class SetupRoute extends AppRoute with $SetupRoute {
  const SetupRoute();

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.setup;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class RosterRoute extends AppRoute with $RosterRoute {
  const RosterRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.roster;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class ParticipantAccessRoute extends AppRoute with $ParticipantAccessRoute {
  const ParticipantAccessRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.participantAccess;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class GuestAddRoute extends AppRoute with $GuestAddRoute {
  const GuestAddRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.guestAdd;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class GuestRemoveRoute extends AppRoute with $GuestRemoveRoute {
  const GuestRemoveRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.guestRemove;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class DistributionRoute extends AppRoute with $DistributionRoute {
  const DistributionRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.distribution;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class SpectatorAccessRoute extends AppRoute with $SpectatorAccessRoute {
  const SpectatorAccessRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.spectatorAccess;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class TieRoute extends AppRoute with $TieRoute {
  const TieRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.tie;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class WithdrawRoute extends AppRoute with $WithdrawRoute {
  const WithdrawRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.withdraw;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class ResultLockedRoute extends AppRoute with $ResultLockedRoute {
  const ResultLockedRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.resultLocked;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class BracketRoute extends AppRoute with $BracketRoute {
  const BracketRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.bracket;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class MatchResultRoute extends AppRoute with $MatchResultRoute {
  const MatchResultRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.matchResult;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class ForfeitRoute extends AppRoute with $ForfeitRoute {
  const ForfeitRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.forfeit;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class ChampionRoute extends AppRoute with $ChampionRoute {
  const ChampionRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.champion;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class ResultsRoute extends AppRoute with $ResultsRoute {
  const ResultsRoute(
    @TypedQueryParameter(
      encoder: TournamentRoute.encodeId,
      decoder: TournamentRoute.decodeId,
    )
    this.tournamentId,
  );

  final TournamentId tournamentId;

  @override
  Future<bool> onExit(BuildContext context, GoRouterState state) =>
      Future.value(_allowExit(context));

  @override
  Widget build(BuildContext context, GoRouterState state) {
    final session = AppNavigationScope.of(context);
    final controller = session.bind(this, state.pageKey);
    final builder = session.screens.results;
    if (builder != null) return builder(context, this, controller);
    return const _UnboundRouteScreen();
  }
}

class _UnboundRouteScreen extends StatelessWidget {
  const _UnboundRouteScreen();

  @override
  Widget build(BuildContext context) => const BootstrapScreen(
    state: BootstrapScreenState(phase: BootstrapPhase.error),
    onRetry: null,
  );
}
