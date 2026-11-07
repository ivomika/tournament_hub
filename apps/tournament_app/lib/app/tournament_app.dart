import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/placeholder/placeholder_screen.dart';

class TournamentApp extends StatelessWidget {
  const TournamentApp({required this.theme, super.key});
  final ThemeData theme;

  @override
  Widget build(BuildContext context) => MaterialApp(
    theme: theme,
    localizationsDelegates: FoundationLocalizations.localizationsDelegates,
    supportedLocales: FoundationLocalizations.supportedLocales,
    home: const PlaceholderScreen(),
  );
}
