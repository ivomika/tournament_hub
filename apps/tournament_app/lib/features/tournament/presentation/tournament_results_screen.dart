import 'package:flutter/material.dart';
import 'package:tournament_app/app/presentation/layout/app_breakpoints.dart';
import 'package:tournament_app/features/fighters/domain/entities/fighter.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';
import 'package:tournament_app/features/standings/domain/entities/standings_row.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_champion_screen.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_conduct_controller.dart';

class TournamentResultsScreen extends StatelessWidget {
  const TournamentResultsScreen({
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
    return Scaffold(
      appBar: AppBar(title: const Text('Итоги турнира')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final tournament = controller.tournament;
            final outcome = controller.outcome;
            if (tournament == null || outcome == null) {
              return const Center(child: CircularProgressIndicator());
            }
            final remaining =
                outcome.standings.requiredMatchCount -
                outcome.standings.completedMatchCount;
            final status = remaining > 0
                ? 'Осталось матчей: $remaining'
                : outcome.standings.hasUniquePositions
                ? 'Итоги готовы'
                : 'Нужен дополнительный tie-break';
            return Center(
              child: ConstrainedBox(
                key: const Key('tournament-results-content'),
                constraints: const BoxConstraints(
                  maxWidth: AppBreakpoints.maxContentWidth,
                ),
                child: ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Icon(
                              outcome.canFinish
                                  ? Icons.emoji_events_outlined
                                  : Icons.leaderboard_outlined,
                              size: 52,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              status,
                              key: const Key('tournament-results-status'),
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Ruleset: ${outcome.rulesetId} v${outcome.rulesetVersion}',
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    for (final row in outcome.standings.rows) ...[
                      _StandingCard(
                        row: row,
                        participant: tournament.draft.participants.firstWhere(
                          (item) => item.id == row.participantId,
                        ),
                        fighter: _fighter(row.participantId),
                        avatarResolver: avatarResolver,
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (controller.errorMessage case final message?) ...[
                      const SizedBox(height: 8),
                      Text(
                        message,
                        key: const Key('tournament-finish-error'),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                    FilledButton.icon(
                      key: const Key('finish-tournament-button'),
                      onPressed: outcome.canFinish && !controller.isSaving
                          ? () async {
                              final finished = await controller
                                  .finishTournament();
                              if (!finished || !context.mounted) return;
                              await Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => TournamentChampionScreen(
                                    controller: controller,
                                    fighterRegistry: fighterRegistry,
                                    avatarResolver: avatarResolver,
                                  ),
                                ),
                              );
                            }
                          : null,
                      icon: const Icon(Icons.emoji_events),
                      label: const Text('Завершить и показать чемпиона'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Fighter? _fighter(TournamentParticipantId id) {
    final tournament = controller.tournament!;
    final assignment = tournament.setup.fighterAssignments.firstWhere(
      (item) => item.participantId == id,
    );
    return fighterRegistry.findById(assignment.fighterId);
  }
}

class _StandingCard extends StatelessWidget {
  const _StandingCard({
    required this.row,
    required this.participant,
    required this.fighter,
    required this.avatarResolver,
  });

  final StandingsRow row;
  final TournamentParticipant participant;
  final Fighter? fighter;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey('standing-${participant.id.value}'),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            SizedBox(
              width: 36,
              child: Text(
                '${row.position}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            _FighterAvatar(fighter: fighter, resolver: avatarResolver),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    participant.nickname.value,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Text(fighter?.displayName ?? 'Боец недоступен'),
                  Text(
                    'Матчи ${row.matchesPlayed} · Победы ${row.wins} · '
                    'Схватки ${row.gamesWon}:${row.gamesLost}',
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              children: [
                Text(
                  '${row.points}',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Text('очков'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FighterAvatar extends StatelessWidget {
  const _FighterAvatar({required this.fighter, required this.resolver});

  final Fighter? fighter;
  final FighterAvatarResolver resolver;

  @override
  Widget build(BuildContext context) {
    final value = fighter;
    return SizedBox.square(
      dimension: 52,
      child: value == null
          ? const Icon(Icons.person_off_outlined)
          : ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                resolver.resolve(value.avatarId),
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.image_not_supported_outlined),
              ),
            ),
    );
  }
}
