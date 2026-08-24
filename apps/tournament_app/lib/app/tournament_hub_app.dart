import 'package:flutter/material.dart';

class TournamentHubApp extends StatelessWidget {
  const TournamentHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tournament HUB',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFD9FF43),
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const _BootstrapScreen(),
    );
  }
}

class _BootstrapScreen extends StatelessWidget {
  const _BootstrapScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('TOURNAMENT HUB'),
            SizedBox(height: 8),
            Text('Локальная турнирная сессия'),
          ],
        ),
      ),
    );
  }
}
