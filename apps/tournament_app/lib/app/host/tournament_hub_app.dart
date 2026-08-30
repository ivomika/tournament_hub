import 'dart:async';

import 'package:flutter/material.dart';

import '../../presentation/design_system/design_system.dart';
import '../../presentation/screens/bootstrap/bootstrap_screen.dart';
import '../runtime/app_runtime.dart';

final class TournamentHubApp extends StatefulWidget {
  const TournamentHubApp({required this.runtime, super.key});

  final AppRuntime runtime;

  @override
  State<TournamentHubApp> createState() => _TournamentHubAppState();
}

final class _TournamentHubAppState extends State<TournamentHubApp> {
  @override
  void initState() {
    super.initState();
    unawaited(widget.runtime.start());
  }

  @override
  void dispose() {
    widget.runtime.dispose();
    super.dispose();
  }

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
