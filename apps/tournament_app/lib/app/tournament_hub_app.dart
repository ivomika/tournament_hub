import 'package:flutter/material.dart';
import 'package:tournament_app/core/common/domain/id_generator.dart';
import 'package:tournament_app/features/fighters/data/repositories/mk11_ultimate_fighter_registry.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/bundled_fighter_avatar_resolver.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';
import 'package:tournament_app/features/guest_profile/application/guest_profile_manager.dart';
import 'package:tournament_app/features/guest_profile/data/repositories/in_memory_guest_profile_collection.dart';
import 'package:tournament_app/features/spectator/application/spectator_host_controller.dart';
import 'package:tournament_app/features/history/application/tournament_history_controller.dart';
import 'package:tournament_app/features/history/domain/repositories/tournament_history_repository.dart';
import 'package:tournament_app/features/history/presentation/tournament_history_screen.dart';
import 'package:tournament_app/features/profile/application/local_profile_controller.dart';
import 'package:tournament_app/features/profile/domain/entities/local_profile.dart';
import 'package:tournament_app/features/profile/domain/repositories/local_profile_repository.dart';
import 'package:tournament_app/features/profile/presentation/profile_gate.dart';
import 'package:tournament_app/features/standings/domain/services/mvp_tournament_ruleset.dart';
import 'package:tournament_app/features/standings/domain/repositories/tournament_completion_repository.dart';
import 'package:tournament_app/features/tournament/application/create_tournament_draft.dart';
import 'package:tournament_app/features/tournament/application/double_elimination_conduct_controller.dart';
import 'package:tournament_app/features/tournament/application/prepare_tournament.dart';
import 'package:tournament_app/features/tournament/application/start_tournament.dart';
import 'package:tournament_app/features/tournament/application/tournament_creation_controller.dart';
import 'package:tournament_app/features/tournament/application/update_active_tournament_match.dart';
import 'package:tournament_app/features/tournament/data/random/dart_random_index_generator.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_bracket.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/repositories/double_elimination_tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/services/double_elimination_topology_generator.dart';
import 'package:tournament_app/features/tournament/domain/services/fighter_assignment_strategy.dart';
import 'package:tournament_app/features/tournament/domain/services/random_index_generator.dart';
import 'package:tournament_app/features/tournament/domain/services/random_unique_fighter_assignment_strategy.dart';
import 'package:tournament_app/features/tournament/domain/services/round_robin_tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';
import 'package:tournament_app/features/tournament/presentation/double_elimination_screen.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_screen.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_conduct_controller.dart';

class TournamentHubApp extends StatefulWidget {
  const TournamentHubApp({
    required this.profileRepository,
    required this.tournamentRepository,
    required this.tournamentCompletionRepository,
    this.tournamentHistoryRepository,
    this.doubleEliminationTournamentRepository,
    required this.idGenerator,
    this.fighterRegistry,
    this.fighterAvatarResolver,
    this.randomIndexGenerator,
    this.spectatorHostController,
    super.key,
  });

  final LocalProfileRepository profileRepository;
  final TournamentRepository tournamentRepository;
  final TournamentCompletionRepository tournamentCompletionRepository;
  final TournamentHistoryRepository? tournamentHistoryRepository;
  final DoubleEliminationTournamentRepository?
  doubleEliminationTournamentRepository;
  final IdGenerator idGenerator;
  final FighterRegistry? fighterRegistry;
  final FighterAvatarResolver? fighterAvatarResolver;
  final RandomIndexGenerator? randomIndexGenerator;
  final SpectatorHostController? spectatorHostController;

  @override
  State<TournamentHubApp> createState() => _TournamentHubAppState();
}

class _TournamentHubAppState extends State<TournamentHubApp> {
  late final LocalProfileController _profileController;
  late final FighterRegistry _fighterRegistry;
  late final FighterAvatarResolver _fighterAvatarResolver;
  late final PrepareTournament _prepareTournament;
  late final FighterAssignmentStrategy _fighterAssignmentStrategy;
  late final RandomIndexGenerator _randomIndexGenerator;

  @override
  void initState() {
    super.initState();
    _fighterRegistry = widget.fighterRegistry ?? Mk11UltimateFighterRegistry();
    _fighterAvatarResolver =
        widget.fighterAvatarResolver ?? const BundledFighterAvatarResolver();
    _randomIndexGenerator =
        widget.randomIndexGenerator ?? DartRandomIndexGenerator();
    _fighterAssignmentStrategy = RandomUniqueFighterAssignmentStrategy(
      _randomIndexGenerator,
    );
    _prepareTournament = PrepareTournament(
      const RoundRobinTournamentRules(),
      _fighterAssignmentStrategy,
      _fighterRegistry,
    );
    _profileController = LocalProfileController(widget.profileRepository)
      ..initialize();
    widget.spectatorHostController?.start();
  }

  @override
  void dispose() {
    _profileController.dispose();
    widget.spectatorHostController?.dispose();
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
        historyScreenBuilder: _buildHistoryScreen,
        spectatorHostController: widget.spectatorHostController,
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
    if (draft.format == TournamentFormat.doubleElimination) {
      return _buildDoubleEliminationScreen(draft);
    }
    final setup = _prepareTournament.execute(draft);
    return TournamentScreen(
      draft: draft,
      setup: setup,
      fighterRegistry: _fighterRegistry,
      avatarResolver: _fighterAvatarResolver,
      controller: TournamentConductController(
        StartTournament(widget.tournamentRepository),
        UpdateActiveTournamentMatch(widget.tournamentRepository),
        widget.tournamentCompletionRepository,
        widget.idGenerator,
        ruleset: MvpTournamentRuleset.instance,
        draft: draft,
        setup: setup,
        fighterRegistry: _fighterRegistry,
        spectatorPublisher: widget.spectatorHostController,
      ),
    );
  }

  Widget _buildDoubleEliminationScreen(TournamentDraft draft) {
    final repository = widget.doubleEliminationTournamentRepository;
    if (repository == null) {
      throw StateError('Не настроено хранилище Double Elimination.');
    }
    final participantIds = draft.participants.map(
      (participant) => participant.id,
    );
    final assignments = _fighterAssignmentStrategy.assign(
      participantIds: participantIds,
      fighters: _fighterRegistry.fighters,
    );
    final initial = DoubleEliminationTournament(
      draft: draft,
      fighterAssignments: assignments,
      bracket: DoubleEliminationBracket(
        topology: DoubleEliminationTopologyGenerator(_randomIndexGenerator)
            .generate(participantIds),
      ),
    );
    return DoubleEliminationScreen(
      controller: DoubleEliminationConductController(
        initial,
        repository,
        widget.idGenerator,
        _fighterRegistry,
        spectatorPublisher: widget.spectatorHostController,
      ),
      fighterRegistry: _fighterRegistry,
      avatarResolver: _fighterAvatarResolver,
    );
  }

  Widget _buildHistoryScreen() {
    final repository =
        widget.tournamentHistoryRepository ??
        widget.tournamentCompletionRepository as TournamentHistoryRepository;
    return TournamentHistoryScreen(
      controller: TournamentHistoryController(
        repository,
        widget.doubleEliminationTournamentRepository,
      ),
      fighterRegistry: _fighterRegistry,
      avatarResolver: _fighterAvatarResolver,
    );
  }
}
