import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/app/routing/screen_route_builders.dart';
import 'package:tournament_app/app/tournament_app.dart';
import 'package:tournament_app/domain/tournament/tournament_id.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/navigation/screen_navigation_controller.dart';
import 'package:tournament_app/presentation/screens/about/about_screen.dart';
import 'package:tournament_app/presentation/screens/about/about_screen_state.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen_state.dart';
import 'package:tournament_app/presentation/screens/roster/roster_screen.dart';
import 'package:tournament_app/presentation/screens/roster/roster_screen_state.dart';

void main() => _ScreenRouteBuildersTests.run();

abstract final class _ScreenRouteBuildersTests {
  static void run() {
    testWidgets('application route builds the injected real screen', _about);
    testWidgets('scoped screen builder receives the decoded route', _roster);
    testWidgets(
      'unbound route shows an error without fabricated state',
      _unbound,
    );
    testWidgets('readiness guard blocks scoped screen builders', _notReady);
  }

  static Future<void> _about(WidgetTester tester) async {
    final probe = _ScreenBuilderProbe();
    final session = AppNavigationSession(
      initialRoute: const AboutRoute(),
      screens: ScreenRouteBuilders(about: probe.about),
    );
    addTearDown(session.dispose);
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: session),
    );
    await tester.pumpAndSettle();
    expect(session.currentRoute, isA<AboutRoute>());
    expect(find.byType(AboutScreen), findsOneWidget);
    expect(find.byType(BootstrapScreen), findsNothing);
    expect(tester.takeException(), isNull);
  }

  static Future<void> _roster(WidgetTester tester) async {
    final identifier = TournamentId('Турнир / 100%');
    final probe = _ScreenBuilderProbe();
    final session = AppNavigationSession(
      initialRoute: RosterRoute(identifier),
      screens: ScreenRouteBuilders(roster: probe.roster),
    );
    addTearDown(session.dispose);
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: session),
    );
    await tester.pumpAndSettle();
    expect(session.currentRoute, isA<RosterRoute>());
    expect(probe.identifier, identifier);
    expect(probe.navigation, isNotNull);
    expect(find.byType(RosterScreen), findsOneWidget);
    expect(
      tester.widget<RosterScreen>(find.byType(RosterScreen)).onDeal,
      isNull,
    );
    expect(tester.takeException(), isNull);
  }

  static Future<void> _unbound(WidgetTester tester) async {
    final session = AppNavigationSession(initialRoute: const HistoryRoute());
    addTearDown(session.dispose);
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: session),
    );
    await tester.pumpAndSettle();
    expect(session.currentRoute, isA<HistoryRoute>());
    final screen = tester.widget<BootstrapScreen>(find.byType(BootstrapScreen));
    expect(screen.state.phase, BootstrapPhase.error);
    expect(screen.onRetry, isNull);
    expect(tester.takeException(), isNull);
  }

  static Future<void> _notReady(WidgetTester tester) async {
    final probe = _ScreenBuilderProbe();
    final session = AppNavigationSession(
      initialRoute: RosterRoute(TournamentId('session-1')),
      initialized: false,
      screens: ScreenRouteBuilders(roster: probe.roster),
    );
    addTearDown(session.dispose);
    await tester.pumpWidget(
      TournamentApp(theme: AppTheme.dark(), navigation: session),
    );
    await tester.pumpAndSettle();
    expect(probe.identifier, isNull);
    expect(find.byType(RosterScreen), findsNothing);
    expect(find.byType(BootstrapScreen), findsOneWidget);
    expect(tester.takeException(), isNull);
  }
}

class _ScreenBuilderProbe {
  TournamentId? identifier;
  ScreenNavigationController? navigation;

  AboutScreen about(
    BuildContext context,
    AboutRoute route,
    ScreenNavigationController navigation,
  ) => AboutScreen(
    state: const AboutScreenState(version: '1.0.0', rulesExpanded: false),
    onBack: navigation.back,
    onToggleRules: null,
  );

  RosterScreen roster(
    BuildContext context,
    RosterRoute route,
    ScreenNavigationController navigation,
  ) {
    identifier = route.tournamentId;
    this.navigation = navigation;
    return RosterScreen(
      state: RosterScreenState(
        contextLabel: identifier!.value,
        guests: const [],
      ),
      onBack: navigation.back,
      onAdd: null,
      onConnect: null,
      onDeal: null,
    );
  }
}
