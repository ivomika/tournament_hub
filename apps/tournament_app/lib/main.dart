import 'package:flutter/material.dart';

import 'presentation/design_system/design_system.dart';
import 'presentation/screens/bootstrap/bootstrap_screen.dart';

void main() {
  runApp(const TournamentHubApp());
}

class TournamentHubApp extends StatelessWidget {
  const TournamentHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tournament Hub',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: TournamentTheme.dark,
      home: const BootstrapScreenPreview(),
    );
  }
}
