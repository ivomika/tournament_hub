import 'package:flutter/material.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_gate.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_runner.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_session.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';
import 'package:tournament_app/app/tournament_app.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

class BootstrapApplication extends StatelessWidget {
  const BootstrapApplication({
    required this.runner,
    required this.theme,
    super.key,
  });

  final BootstrapRunner<AppNavigationSession> runner;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => BootstrapGate<AppNavigationSession>(
    runner: runner,
    readyBuilder: _ready,
    shellBuilder: _shell,
  );

  Widget _ready(
    BuildContext context,
    BootstrapSession<AppNavigationSession> session,
  ) => TournamentApp(theme: theme, navigation: session.value);

  Widget _shell(BuildContext context, Widget content) => MaterialApp(
    theme: theme,
    localizationsDelegates: FoundationLocalizations.localizationsDelegates,
    supportedLocales: FoundationLocalizations.supportedLocales,
    home: content,
  );
}
