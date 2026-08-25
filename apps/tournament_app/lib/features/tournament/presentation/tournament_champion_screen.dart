import 'package:flutter/material.dart';
import 'package:tournament_app/app/presentation/layout/app_breakpoints.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_conduct_controller.dart';

class TournamentChampionScreen extends StatelessWidget {
  const TournamentChampionScreen({
    required this.controller,
    required this.fighterRegistry,
    required this.avatarResolver,
    super.key,
  });

  final TournamentConductController controller;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    final tournament = controller.tournament!;
    final outcome = controller.outcome!;
    final championId = outcome.championId!;
    final champion = tournament.draft.participants.firstWhere(
      (item) => item.id == championId,
    );
    final assignment = tournament.setup.fighterAssignments.firstWhere(
      (item) => item.participantId == championId,
    );
    final fighter = fighterRegistry.findById(assignment.fighterId);
    return Scaffold(
      appBar: AppBar(title: const Text('Турнир завершён')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            key: const Key('tournament-champion-content'),
            constraints: const BoxConstraints(
              maxWidth: AppBreakpoints.formColumnWidth,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(
                        Icons.emoji_events,
                        size: 72,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Чемпион',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 20),
                      SizedBox.square(
                        dimension: 140,
                        child: fighter == null
                            ? const Icon(Icons.person_off_outlined, size: 80)
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: Image.asset(
                                  avatarResolver.resolve(fighter.avatarId),
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 80,
                                  ),
                                ),
                              ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        champion.nickname.value,
                        key: const Key('champion-nickname'),
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        fighter?.displayName ?? 'Боец недоступен',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        '${outcome.standings.rows.first.points} очков · '
                        '${outcome.standings.rows.first.wins} побед',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
