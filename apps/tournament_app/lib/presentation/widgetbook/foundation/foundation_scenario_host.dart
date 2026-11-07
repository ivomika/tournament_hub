import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

/// Один контекст локализации/темы для Widgetbook и golden.
class FoundationScenarioHost extends StatelessWidget {
  const FoundationScenarioHost({required this.child, this.theme, super.key});

  final Widget child;
  final ThemeData? theme;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme ?? Theme.of(context),
      locale: FoundationLocalizations.supportedLocales.first,
      localizationsDelegates: FoundationLocalizations.localizationsDelegates,
      supportedLocales: FoundationLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: child),
    );
  }
}
