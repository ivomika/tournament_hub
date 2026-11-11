// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_routes.dart';

// **************************************************************************
// GoRouterGenerator
// **************************************************************************

List<RouteBase> get $appRoutes => [$homeRoute, $bootstrapRoute];

RouteBase get $homeRoute => GoRouteData.$route(
  path: '/',
  hasOverriddenOnExit: true,
  factory: $HomeRoute._fromState,
  routes: [
    GoRouteData.$route(
      path: 'profile',
      hasOverriddenOnExit: true,
      factory: $ProfileRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'utility',
      hasOverriddenOnExit: true,
      factory: $UtilityRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'profile/edit',
      hasOverriddenOnExit: true,
      factory: $ProfileEditRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'settings',
      hasOverriddenOnExit: true,
      factory: $SettingsRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'about',
      hasOverriddenOnExit: true,
      factory: $AboutRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'contact',
      hasOverriddenOnExit: true,
      factory: $ContactRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'history',
      hasOverriddenOnExit: true,
      factory: $HistoryRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'setup',
      hasOverriddenOnExit: true,
      factory: $SetupRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId',
      hasOverriddenOnExit: true,
      factory: $TournamentRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/roster',
      hasOverriddenOnExit: true,
      factory: $RosterRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/participant-access',
      hasOverriddenOnExit: true,
      factory: $ParticipantAccessRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/guest-add',
      hasOverriddenOnExit: true,
      factory: $GuestAddRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/guest-remove',
      hasOverriddenOnExit: true,
      factory: $GuestRemoveRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/distribution',
      hasOverriddenOnExit: true,
      factory: $DistributionRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/spectator-access',
      hasOverriddenOnExit: true,
      factory: $SpectatorAccessRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/tie',
      hasOverriddenOnExit: true,
      factory: $TieRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/withdraw',
      hasOverriddenOnExit: true,
      factory: $WithdrawRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/result-locked',
      hasOverriddenOnExit: true,
      factory: $ResultLockedRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/bracket',
      hasOverriddenOnExit: true,
      factory: $BracketRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/match-result',
      hasOverriddenOnExit: true,
      factory: $MatchResultRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/forfeit',
      hasOverriddenOnExit: true,
      factory: $ForfeitRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/champion',
      hasOverriddenOnExit: true,
      factory: $ChampionRoute._fromState,
    ),
    GoRouteData.$route(
      path: 'tournament/:tournamentId/results',
      hasOverriddenOnExit: true,
      factory: $ResultsRoute._fromState,
    ),
  ],
);

mixin $HomeRoute on GoRouteData {
  static HomeRoute _fromState(GoRouterState state) => const HomeRoute();

  @override
  String get location => GoRouteData.$location('/');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileRoute on GoRouteData {
  static ProfileRoute _fromState(GoRouterState state) => const ProfileRoute();

  @override
  String get location => GoRouteData.$location('/profile');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $UtilityRoute on GoRouteData {
  static UtilityRoute _fromState(GoRouterState state) => const UtilityRoute();

  @override
  String get location => GoRouteData.$location('/utility');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ProfileEditRoute on GoRouteData {
  static ProfileEditRoute _fromState(GoRouterState state) =>
      const ProfileEditRoute();

  @override
  String get location => GoRouteData.$location('/profile/edit');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SettingsRoute on GoRouteData {
  static SettingsRoute _fromState(GoRouterState state) => const SettingsRoute();

  @override
  String get location => GoRouteData.$location('/settings');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $AboutRoute on GoRouteData {
  static AboutRoute _fromState(GoRouterState state) => const AboutRoute();

  @override
  String get location => GoRouteData.$location('/about');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ContactRoute on GoRouteData {
  static ContactRoute _fromState(GoRouterState state) => const ContactRoute();

  @override
  String get location => GoRouteData.$location('/contact');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $HistoryRoute on GoRouteData {
  static HistoryRoute _fromState(GoRouterState state) => const HistoryRoute();

  @override
  String get location => GoRouteData.$location('/history');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SetupRoute on GoRouteData {
  static SetupRoute _fromState(GoRouterState state) => const SetupRoute();

  @override
  String get location => GoRouteData.$location('/setup');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TournamentRoute on GoRouteData {
  static TournamentRoute _fromState(GoRouterState state) => TournamentRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  TournamentRoute get _self => this as TournamentRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $RosterRoute on GoRouteData {
  static RosterRoute _fromState(GoRouterState state) => RosterRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  RosterRoute get _self => this as RosterRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/roster',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ParticipantAccessRoute on GoRouteData {
  static ParticipantAccessRoute _fromState(GoRouterState state) =>
      ParticipantAccessRoute(
        TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
      );

  ParticipantAccessRoute get _self => this as ParticipantAccessRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/participant-access',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GuestAddRoute on GoRouteData {
  static GuestAddRoute _fromState(GoRouterState state) => GuestAddRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  GuestAddRoute get _self => this as GuestAddRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/guest-add',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $GuestRemoveRoute on GoRouteData {
  static GuestRemoveRoute _fromState(GoRouterState state) => GuestRemoveRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  GuestRemoveRoute get _self => this as GuestRemoveRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/guest-remove',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $DistributionRoute on GoRouteData {
  static DistributionRoute _fromState(GoRouterState state) => DistributionRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  DistributionRoute get _self => this as DistributionRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/distribution',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $SpectatorAccessRoute on GoRouteData {
  static SpectatorAccessRoute _fromState(GoRouterState state) =>
      SpectatorAccessRoute(
        TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
      );

  SpectatorAccessRoute get _self => this as SpectatorAccessRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/spectator-access',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $TieRoute on GoRouteData {
  static TieRoute _fromState(GoRouterState state) =>
      TieRoute(TournamentRoute.decodeId(state.pathParameters['tournamentId']!));

  TieRoute get _self => this as TieRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/tie',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $WithdrawRoute on GoRouteData {
  static WithdrawRoute _fromState(GoRouterState state) => WithdrawRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  WithdrawRoute get _self => this as WithdrawRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/withdraw',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ResultLockedRoute on GoRouteData {
  static ResultLockedRoute _fromState(GoRouterState state) => ResultLockedRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  ResultLockedRoute get _self => this as ResultLockedRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/result-locked',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $BracketRoute on GoRouteData {
  static BracketRoute _fromState(GoRouterState state) => BracketRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  BracketRoute get _self => this as BracketRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/bracket',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $MatchResultRoute on GoRouteData {
  static MatchResultRoute _fromState(GoRouterState state) => MatchResultRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  MatchResultRoute get _self => this as MatchResultRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/match-result',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ForfeitRoute on GoRouteData {
  static ForfeitRoute _fromState(GoRouterState state) => ForfeitRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  ForfeitRoute get _self => this as ForfeitRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/forfeit',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ChampionRoute on GoRouteData {
  static ChampionRoute _fromState(GoRouterState state) => ChampionRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  ChampionRoute get _self => this as ChampionRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/champion',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

mixin $ResultsRoute on GoRouteData {
  static ResultsRoute _fromState(GoRouterState state) => ResultsRoute(
    TournamentRoute.decodeId(state.pathParameters['tournamentId']!),
  );

  ResultsRoute get _self => this as ResultsRoute;

  @override
  String get location => GoRouteData.$location(
    '/tournament/${Uri.encodeComponent(TournamentRoute.encodeId(_self.tournamentId))}/results',
  );

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}

RouteBase get $bootstrapRoute => GoRouteData.$route(
  path: '/bootstrap',
  hasOverriddenOnExit: true,
  factory: $BootstrapRoute._fromState,
);

mixin $BootstrapRoute on GoRouteData {
  static BootstrapRoute _fromState(GoRouterState state) =>
      const BootstrapRoute();

  @override
  String get location => GoRouteData.$location('/bootstrap');

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context) => context.push<T>(location);

  @override
  void pushReplacement(BuildContext context) =>
      context.pushReplacement(location);

  @override
  void replace(BuildContext context) => context.replace(location);
}
