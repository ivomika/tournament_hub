import 'package:flutter/material.dart';
import 'package:tournament_app/core/common/domain/id_generator.dart';
import 'package:tournament_app/features/fighters/data/repositories/mk11_ultimate_fighter_registry.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/bundled_fighter_avatar_resolver.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';
import 'package:tournament_app/features/guest_profile/application/guest_profile_manager.dart';
import 'package:tournament_app/features/guest_profile/data/repositories/in_memory_guest_profile_collection.dart';
import 'package:tournament_app/features/profile/application/local_profile_controller.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/profile/domain/repositories/local_profile_repository.dart';
import 'package:tournament_app/features/profile/presentation/profile_gate.dart';
import 'package:tournament_app/features/tournament/application/create_tournament_draft.dart';
import 'package:tournament_app/features/tournament/application/prepare_tournament.dart';
import 'package:tournament_app/features/tournament/application/tournament_creation_controller.dart';
import 'package:tournament_app/features/tournament/data/random/dart_random_index_generator.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/services/random_index_generator.dart';
import 'package:tournament_app/features/tournament/domain/services/random_unique_fighter_assignment_strategy.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_screen.dart';

class TournamentHubApp extends StatefulWidget {
  const TournamentHubApp({
    required this.profileRepository,
    required this.tournamentRepository,
    required this.idGenerator,
    this.fighterRegistry,
    this.fighterAvatarResolver,
    this.randomIndexGenerator,
    super.key,
  });

  final LocalProfileRepository profileRepository;
  final TournamentRepository tournamentRepository;
  final IdGenerator idGenerator;
  final FighterRegistry? fighterRegistry;
  final FighterAvatarResolver? fighterAvatarResolver;
  final RandomIndexGenerator? randomIndexGenerator;

  @override
  State<TournamentHubApp> createState() => _TournamentHubAppState();
}

class _TournamentHubAppState extends State<TournamentHubApp> {
  late final LocalProfileController _profileController;
  late final FighterRegistry _fighterRegistry;
  late final FighterAvatarResolver _fighterAvatarResolver;
  late final PrepareTournament _prepareTournament;

  @override
  void initState() {
    super.initState();
    _fighterRegistry = widget.fighterRegistry ?? Mk11UltimateFighterRegistry();
    _fighterAvatarResolver =
        widget.fighterAvatarResolver ?? const BundledFighterAvatarResolver();
    _prepareTournament = PrepareTournament(
      const RoundRobinTournamentRules(),
      RandomUniqueFighterAssignmentStrategy(
        widget.randomIndexGenerator ?? DartRandomIndexGenerator(),
      ),
      _fighterRegistry,
    );
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
        tournamentScreenBuilder: _buildTournamentScreen,
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

  Widget _buildTournamentScreen(TournamentDraft draft) {
    return TournamentScreen(
      draft: draft,
      setup: _prepareTournament.execute(draft),
      fighterRegistry: _fighterRegistry,
      avatarResolver: _fighterAvatarResolver,
    );
  }
}
