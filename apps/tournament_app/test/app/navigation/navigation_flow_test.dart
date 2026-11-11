import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/app/tournament_app.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/screens/home/home_screen.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen.dart';
import 'package:tournament_app/domain/tournament/tournament_id.dart';

void main() => _NavigationFlowTests.run();

abstract final class _NavigationFlowTests {
  static void run() {
    testWidgets(
      'typed tournament identifier survives URI codec',
      _typedIdentifier,
    );
    testWidgets(
      'platform Back uses exit guard and preserves home origin',
      _platformBack,
    );
    testWidgets(
      'cold profile entry is blocked before initialization',
      _blockedEntry,
    );
    testWidgets(
      'home callback opens profile and back restores home',
      _profileRoundTrip,
    );
    testWidgets('direct profile back falls back to home', _directProfile);
    testWidgets(
      'reopened profile has new origin and home keeps its callback',
      _reopenedProfile,
    );
  }

  static Future<void> _typedIdentifier(WidgetTester tester) async {
    final identifier = TournamentId('Турнир / 100%');
    final session = AppNavigationSession(
      initialRoute: TournamentRoute(identifier),
      initialized: true,
    );
    addTearDown(session.dispose);
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: session),
    );
    await tester.pumpAndSettle();
    expect(session.currentRoute, isA<TournamentRoute>());
    expect((session.currentRoute as TournamentRoute).tournamentId, identifier);
    final decoded = session.currentRoute as TournamentRoute;
    expect(decoded.location, TournamentRoute(identifier).location);
    expect(tester.takeException(), isNull);
  }

  static Future<void> _platformBack(WidgetTester tester) async {
    final session = AppNavigationSession(
      initialRoute: const HomeRoute(),
      initialized: true,
    );
    addTearDown(session.dispose);
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: session),
    );
    await tester.pumpAndSettle();
    final openProfile = tester
        .widget<HomeScreen>(find.byType(HomeScreen))
        .onProfile!;
    openProfile();
    await tester.pumpAndSettle();
    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();
    expect(session.currentRoute, isA<HomeRoute>());
    openProfile();
    await tester.pumpAndSettle();
    expect(session.currentRoute, isA<ProfileRoute>());
  }

  static Future<void> _blockedEntry(WidgetTester tester) async {
    final session = AppNavigationSession(
      initialRoute: const ProfileRoute(),
      initialized: false,
    );
    addTearDown(session.dispose);
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: session),
    );
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsNothing);
    expect(find.byType(BootstrapScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  }

  static Future<void> _profileRoundTrip(WidgetTester tester) async {
    final session = AppNavigationSession(
      initialRoute: const HomeRoute(),
      initialized: true,
    );
    addTearDown(session.dispose);
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: session),
    );
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    tester.widget<HomeScreen>(find.byType(HomeScreen)).onProfile!.call();
    await tester.pumpAndSettle();
    expect(find.byType(ProfileScreen), findsOneWidget);
    expect(session.currentRoute, isA<ProfileRoute>());
    tester.widget<ProfileScreen>(find.byType(ProfileScreen)).onBack!.call();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(session.currentRoute, isA<HomeRoute>());
  }

  static Future<void> _directProfile(WidgetTester tester) async {
    final session = AppNavigationSession(
      initialRoute: const ProfileRoute(),
      initialized: true,
    );
    addTearDown(session.dispose);
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: session),
    );
    await tester.pumpAndSettle();
    tester.widget<ProfileScreen>(find.byType(ProfileScreen)).onBack!.call();
    await tester.pumpAndSettle();
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(session.currentRoute, isA<HomeRoute>());
  }

  static Future<void> _reopenedProfile(WidgetTester tester) async {
    final session = AppNavigationSession(
      initialRoute: const HomeRoute(),
      initialized: true,
    );
    addTearDown(session.dispose);
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: session),
    );
    await tester.pumpAndSettle();
    final homeCallback = tester
        .widget<HomeScreen>(find.byType(HomeScreen))
        .onProfile!;
    homeCallback();
    await tester.pumpAndSettle();
    final oldBack = tester
        .widget<ProfileScreen>(find.byType(ProfileScreen))
        .onBack!;
    oldBack();
    await tester.pumpAndSettle();
    homeCallback();
    await tester.pumpAndSettle();
    oldBack();
    await tester.pumpAndSettle();
    expect(session.currentRoute, isA<ProfileRoute>());
    tester.widget<ProfileScreen>(find.byType(ProfileScreen)).onBack!.call();
    await tester.pumpAndSettle();
    expect(session.currentRoute, isA<HomeRoute>());
  }
}
