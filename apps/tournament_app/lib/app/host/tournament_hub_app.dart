import 'dart:async';

import 'package:flutter/material.dart';

import '../../presentation/design_system/design_system.dart';
import '../navigation/models/app_route_projection.dart';
import '../navigation/models/navigation_intent.dart';
import '../runtime/app_runtime.dart';
import 'app_route_screen.dart';

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
    final profileRuntime = widget.runtime is AppProfileRuntime
        ? widget.runtime as AppProfileRuntime
        : null;
    return MaterialApp(
      title: 'Tournament Hub',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      darkTheme: TournamentTheme.dark,
      home: StreamBuilder<AppRouteProjection>(
        stream: widget.runtime.appRouteSource.changes,
        initialData: widget.runtime.appRouteSource.current,
        builder: (context, snapshot) => PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, _) {
            if (!didPop) widget.runtime.navigation.back();
          },
          child: AppRouteScreen(
            key: ValueKey(snapshot.requireData),
            projection: snapshot.requireData,
            appState: widget.runtime.appStateSource.current,
            onRetry: widget.runtime.retry,
            onCreateProfile: profileRuntime?.createProfile,
            onRenameProfile: profileRuntime?.renameProfile,
            onResetAccount: profileRuntime?.resetAccount,
            onDestinationSelected: _selectDestination,
          ),
        ),
      ),
    );
  }

  void _selectDestination(AppDestination destination) {
    final intent = switch (destination) {
      AppDestination.home => const NavigationIntent.main(),
      AppDestination.history => const NavigationIntent.history(),
      AppDestination.profile => const NavigationIntent.profile(),
      AppDestination.settings => const NavigationIntent.settings(),
    };
    widget.runtime.navigation.go(intent);
  }
}
