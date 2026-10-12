import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/app_foundation.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';

/// Один контекст локализации/темы для Widgetbook и golden.
class FoundationScenarioHost extends StatelessWidget {
  const FoundationScenarioHost({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    const foundation = AppFoundation.dark();
    return MaterialApp(
      theme: foundation.materialTheme,
      locale: FoundationLocalizations.supportedLocales.first,
      localizationsDelegates: FoundationLocalizations.localizationsDelegates,
      supportedLocales: FoundationLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: child),
    );
  }
}
