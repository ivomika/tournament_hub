import 'package:flutter/material.dart';
import 'package:tournament_app/core/common/domain/id_generator.dart';
import 'package:tournament_app/features/guest_profile/application/guest_profile_manager.dart';
import 'package:tournament_app/features/guest_profile/data/repositories/in_memory_guest_profile_collection.dart';
import 'package:tournament_app/features/profile/application/local_profile_controller.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/profile/domain/repositories/local_profile_repository.dart';
import 'package:tournament_app/features/profile/presentation/profile_gate.dart';
import 'package:tournament_app/features/tournament/application/create_tournament_draft.dart';
import 'package:tournament_app/features/tournament/application/tournament_creation_controller.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';

class TournamentHubApp extends StatefulWidget {
  const TournamentHubApp({
    required this.profileRepository,
    required this.tournamentRepository,
    required this.idGenerator,
    super.key,
  });

  final LocalProfileRepository profileRepository;
  final TournamentRepository tournamentRepository;
  final IdGenerator idGenerator;

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
      home: ProfileGate(
        controller: _profileController,
        createTournamentController: _createTournamentController,
      ),
    );
  }

  TournamentCreationController _createTournamentController(LocalProfile owner) {
    return TournamentCreationController(
      GuestProfileManager(InMemoryGuestProfileCollection(), widget.idGenerator),
      CreateTournamentDraft(widget.tournamentRepository, widget.idGenerator),
      owner: owner,
    );
  }
}
