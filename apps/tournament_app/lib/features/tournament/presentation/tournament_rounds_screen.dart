import 'package:flutter/material.dart';
import 'package:tournament_app/app/presentation/layout/app_breakpoints.dart';
import 'package:tournament_app/features/fighters/domain/entities/fighter.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_round.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_conduct_controller.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_results_screen.dart';

class TournamentRoundsScreen extends StatelessWidget {
  const TournamentRoundsScreen({
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
      appBar: AppBar(title: const Text('Раунды')),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final tournament = controller.tournament;
            if (tournament == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                if (controller.isSaving) const LinearProgressIndicator(),
                if (controller.errorMessage case final message?)
                  _ErrorBanner(message: message),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      key: const Key('tournament-rounds-content'),
                      constraints: const BoxConstraints(
                        maxWidth: AppBreakpoints.maxContentWidth,
                      ),
                      child: ListView.separated(
                        padding: const EdgeInsets.all(16),
                        itemCount: tournament.setup.schedule.rounds.length + 1,
                        separatorBuilder: (_, _) => const SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          if (index ==
                              tournament.setup.schedule.rounds.length) {
                            return FilledButton.icon(
                              key: const Key('open-tournament-results'),
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => TournamentResultsScreen(
                                    controller: controller,
                                    fighterRegistry: fighterRegistry,
                                    avatarResolver: avatarResolver,
                                  ),
                                ),
                              ),
                              icon: const Icon(Icons.leaderboard_outlined),
                              label: const Text('Подвести итоги'),
                            );
                          }
                          return _RoundCard(
                            tournament: tournament,
                            round: tournament.setup.schedule.rounds[index],
                            controller: controller,
                            fighterRegistry: fighterRegistry,
                            avatarResolver: avatarResolver,
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.errorContainer,
      child: Padding(
        key: const Key('match-save-error'),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.error_outline),
            const SizedBox(width: 12),
            Expanded(child: Text(message)),
          ],
        ),
      ),
    );
  }
}

class _RoundCard extends StatelessWidget {
  const _RoundCard({
    required this.tournament,
    required this.round,
    required this.controller,
    required this.fighterRegistry,
    required this.avatarResolver,
  });

  final ActiveTournament tournament;
  final TournamentRound round;
  final TournamentConductController controller;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    return Card(
      key: ValueKey('round-${round.number}'),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Раунд ${round.number}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            for (final scheduledMatch in round.matches) ...[
              _MatchCard(
                match: tournament.matches.firstWhere(
                  (match) => match.scheduledMatch.id == scheduledMatch.id,
                ),
                tournament: tournament,
                controller: controller,
                fighterRegistry: fighterRegistry,
                avatarResolver: avatarResolver,
              ),
              if (scheduledMatch != round.matches.last)
                const SizedBox(height: 12),
            ],
            if (round.byeParticipantId case final bye?) ...[
              if (round.matches.isNotEmpty) const SizedBox(height: 12),
              Text(
                'Пропускает раунд',
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              _ParticipantPanel(
                key: ValueKey('round-${round.number}-bye'),
                participant: _participant(bye),
                fighter: _fighter(bye),
                avatarResolver: avatarResolver,
              ),
            ],
          ],
        ),
      ),
    );
  }

  TournamentParticipant _participant(TournamentParticipantId id) => tournament
      .draft
      .participants
      .firstWhere((participant) => participant.id == id);

  Fighter? _fighter(TournamentParticipantId id) {
    final assignment = tournament.setup.fighterAssignments.firstWhere(
      (assignment) => assignment.participantId == id,
    );
    return fighterRegistry.findById(assignment.fighterId);
  }
}

class _MatchCard extends StatelessWidget {
  const _MatchCard({
    required this.match,
    required this.tournament,
    required this.controller,
    required this.fighterRegistry,
    required this.avatarResolver,
  });

  final TournamentMatch match;
  final ActiveTournament tournament;
  final TournamentConductController controller;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    final firstId = match.scheduledMatch.firstParticipantId;
    final secondId = match.scheduledMatch.secondParticipantId;
    final firstScore =
        match.result?.firstParticipantScore ??
        match.bouts.where((bout) => bout.winnerId == firstId).length;
    final secondScore =
        match.result?.secondParticipantScore ??
        match.bouts.where((bout) => bout.winnerId == secondId).length;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    match.isCompleted
                        ? 'Матч завершён'
                        : 'Схватка ${match.bouts.length + 1}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(
                  '$firstScore : $secondScore',
                  key: ValueKey('match-score-${match.scheduledMatch.id.value}'),
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ],
            ),
            const SizedBox(height: 12),
            LayoutBuilder(
              builder: (context, constraints) {
                final first = _participantPanel(firstId);
                final second = _participantPanel(secondId);
                if (constraints.maxWidth < 620) {
                  return Column(
                    children: [first, const SizedBox(height: 8), second],
                  );
                }
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: first),
                    const SizedBox(width: 12),
                    Expanded(child: second),
                  ],
                );
              },
            ),
            if (match.isCompleted) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                key: ValueKey('correct-match-${match.scheduledMatch.id.value}'),
                onPressed: controller.isSaving || controller.isFinished
                    ? null
                    : () => _showCorrection(context, firstId, secondId),
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Исправить результат'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _participantPanel(TournamentParticipantId id) => _ParticipantPanel(
    participant: tournament.draft.participants.firstWhere(
      (participant) => participant.id == id,
    ),
    fighter: _fighter(id),
    avatarResolver: avatarResolver,
    actionLabel: 'Победа в схватке',
    onPressed: match.isCompleted || controller.isSaving || controller.isFinished
        ? null
        : () => controller.recordBout(
            matchId: match.scheduledMatch.id,
            winnerId: id,
          ),
    actionKey: ValueKey(
      'record-bout-${match.scheduledMatch.id.value}-${id.value}',
    ),
  );

  Fighter? _fighter(TournamentParticipantId id) {
    final assignment = tournament.setup.fighterAssignments.firstWhere(
      (assignment) => assignment.participantId == id,
    );
    return fighterRegistry.findById(assignment.fighterId);
  }

  Future<void> _showCorrection(
    BuildContext context,
    TournamentParticipantId firstId,
    TournamentParticipantId secondId,
  ) async {
    final variants = <_ResultVariant>[
      _ResultVariant('Итог 2:0', [firstId, firstId]),
      _ResultVariant('Итог 2:1', [firstId, secondId, firstId]),
      _ResultVariant('Итог 1:2', [secondId, firstId, secondId]),
      _ResultVariant('Итог 0:2', [secondId, secondId]),
    ];
    final selected = await showDialog<_ResultVariant>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Заменить результат матча?'),
        children: [
          for (final variant in variants)
            SimpleDialogOption(
              key: ValueKey(
                'correction-${match.scheduledMatch.id.value}-${variant.label}',
              ),
              onPressed: () => Navigator.of(context).pop(variant),
              child: Text(variant.label),
            ),
        ],
      ),
    );
    if (selected == null) return;
    await controller.correctResult(
      matchId: match.scheduledMatch.id,
      boutWinners: selected.winners,
    );
  }
}

class _ParticipantPanel extends StatelessWidget {
  const _ParticipantPanel({
    required this.participant,
    required this.fighter,
    required this.avatarResolver,
    this.actionLabel,
    this.onPressed,
    this.actionKey,
    super.key,
  });

  final TournamentParticipant participant;
  final Fighter? fighter;
  final FighterAvatarResolver avatarResolver;
  final String? actionLabel;
  final VoidCallback? onPressed;
  final Key? actionKey;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                SizedBox.square(
                  dimension: 52,
                  child: fighter == null
                      ? const Icon(Icons.person_off_outlined)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            avatarResolver.resolve(fighter!.avatarId),
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) =>
                                const Icon(Icons.image_not_supported_outlined),
                          ),
                        ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        participant.nickname.value,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        fighter?.displayName ?? 'Боец недоступен',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 10),
              FilledButton.tonalIcon(
                key: actionKey,
                onPressed: onPressed,
                icon: const Icon(Icons.sports_mma_outlined),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

final class _ResultVariant {
  const _ResultVariant(this.label, this.winners);

  final String label;
  final List<TournamentParticipantId> winners;
}
