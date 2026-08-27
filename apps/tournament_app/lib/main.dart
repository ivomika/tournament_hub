import 'package:flutter/material.dart';

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
      darkTheme: ThemeData.dark(useMaterial3: true),
      home: const TournamentHubBootstrapScreen(),
    );
  }
}

class TournamentHubBootstrapScreen extends StatelessWidget {
  const TournamentHubBootstrapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Semantics(header: true, child: const Text('Tournament Hub')),
      ),
    );
  }
}
