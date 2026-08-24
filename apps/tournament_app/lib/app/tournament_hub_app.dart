import 'package:flutter/material.dart';
import 'package:tournament_app/features/profile/application/local_profile_controller.dart';
import 'package:tournament_app/features/profile/domain/repositories/local_profile_repository.dart';
import 'package:tournament_app/features/profile/presentation/profile_gate.dart';

class TournamentHubApp extends StatefulWidget {
  const TournamentHubApp({required this.profileRepository, super.key});

  final LocalProfileRepository profileRepository;

  @override
  State<TournamentHubApp> createState() => _TournamentHubAppState();
}

class _TournamentHubAppState extends State<TournamentHubApp> {
  late final LocalProfileController _profileController;

  @override
  void initState() {
    super.initState();
    _profileController = LocalProfileController(widget.profileRepository)
      ..initialize();
  }

  @override
  void dispose() {
    _profileController.dispose();
    super.dispose();
  }

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
      home: ProfileGate(controller: _profileController),
    );
  }
}
