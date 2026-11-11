import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';

class TournamentApp extends StatefulWidget {
  const TournamentApp({required this.theme, this.navigation, super.key});
  final ThemeData theme;
  final AppNavigationSession? navigation;
  @override
  State<TournamentApp> createState() => _TournamentAppState();
}

class _TournamentAppState extends State<TournamentApp> {
  late final _navigation = widget.navigation ?? AppNavigationSession();
  @override
  void dispose() {
    if (widget.navigation == null) _navigation.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) => AppNavigationScope(
    session: _navigation,
    child: MaterialApp.router(
      theme: widget.theme,
      localizationsDelegates: FoundationLocalizations.localizationsDelegates,
      supportedLocales: FoundationLocalizations.supportedLocales,
      routerConfig: _navigation.router,
    ),
  );
}
