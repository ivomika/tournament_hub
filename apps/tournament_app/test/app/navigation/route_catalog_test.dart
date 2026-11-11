import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/domain/tournament/tournament_id.dart';

void main() => _RouteCatalogTests.run();

abstract final class _RouteCatalogTests {
  static void run() {
    TestWidgetsFlutterBinding.ensureInitialized();
    test('all screen routes match and decode to their concrete type', _catalog);
    test('tournament screen routes preserve encoded identifiers', _identifiers);
    test('unknown destinations are not registered', _unknown);
  }

  static List<AppRoute> _applicationRoutes() => const [
    HomeRoute(),
    BootstrapRoute(),
    UtilityRoute(),
    ProfileRoute(),
    ProfileEditRoute(),
    SettingsRoute(),
    AboutRoute(),
    ContactRoute(),
    HistoryRoute(),
    SetupRoute(),
  ];

  static List<AppRoute> _tournamentRoutes(TournamentId identifier) => [
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
  ];

  static void _catalog() {
    final routes = [
      ..._applicationRoutes(),
      ..._tournamentRoutes(TournamentId('session-1')),
    ];
    final router = GoRouter(routes: $appRoutes);
    addTearDown(router.dispose);
    expect(routes.map((route) => route.location).toSet(), hasLength(25));
    for (final route in routes) {
      _expectRoundTrip(router, route);
    }
  }

  static void _identifiers() {
    final router = GoRouter(routes: $appRoutes);
    addTearDown(router.dispose);
    for (final identifier in ['Турнир / 100%', 'id?#&=+']) {
      for (final route in _tournamentRoutes(TournamentId(identifier))) {
        _expectRoundTrip(router, route);
        final matches = router.configuration.findMatch(
          Uri.parse(route.location),
        );
        expect(matches.pathParameters['tournamentId'], identifier);
      }
    }
  }

  static void _expectRoundTrip(GoRouter router, AppRoute route) {
    final matches = router.configuration.findMatch(Uri.parse(route.location));
    expect(matches.isError, isFalse, reason: route.location);
    final state = matches.matches.last.buildState(
      router.configuration,
      matches,
      metadata: const {},
    );
    final decoded = AppRoute.decode(state);
    expect(decoded.runtimeType, route.runtimeType, reason: route.location);
    expect(decoded.location, route.location);
  }

  static void _unknown() {
    final router = GoRouter(routes: $appRoutes);
    addTearDown(router.dispose);
    for (final address in ['/unknown', '/tournament/session-1/unknown']) {
      expect(
        router.configuration.findMatch(Uri.parse(address)).isError,
        isTrue,
      );
    }
  }
}
