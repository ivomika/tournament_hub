import 'package:flutter/material.dart';
import 'package:tournament_app/app/presentation/layout/app_breakpoints.dart';
import 'package:tournament_app/features/fighters/domain/entities/fighter.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';
import 'package:tournament_app/features/tournament/presentation/tournament_rounds_screen.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({
    required this.draft,
    required this.setup,
    required this.fighterRegistry,
    required this.avatarResolver,
    super.key,
  });

  final TournamentDraft draft;
  final TournamentSetup setup;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    final assignments = <TournamentParticipantId, FighterAssignment>{
      for (final assignment in setup.fighterAssignments)
        assignment.participantId: assignment,
    };

    return Scaffold(
      appBar: AppBar(title: Text(draft.name.value)),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= AppBreakpoints.wide;
            final summary = _TournamentSummary(
              participantCount: draft.participants.length,
              roundCount: setup.schedule.rounds.length,
              onOpenRounds: () => _openRounds(context),
            );
            final participants = _ParticipantsList(
              draft: draft,
              assignments: assignments,
              fighterRegistry: fighterRegistry,
              avatarResolver: avatarResolver,
            );

            return Center(
              child: ConstrainedBox(
                key: const Key('tournament-overview-content'),
                constraints: const BoxConstraints(
                  maxWidth: AppBreakpoints.maxContentWidth,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: isWide
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(width: 280, child: summary),
                            const SizedBox(width: 32),
                            Expanded(child: participants),
                          ],
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            summary,
                            const SizedBox(height: 32),
                            participants,
                          ],
                        ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _openRounds(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => TournamentRoundsScreen(draft: draft, setup: setup),
      ),
    );
  }
}

class _TournamentSummary extends StatelessWidget {
  const _TournamentSummary({
    required this.participantCount,
    required this.roundCount,
    required this.onOpenRounds,
  });

  final int participantCount;
  final int roundCount;
  final VoidCallback onOpenRounds;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.emoji_events_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              'Турнир готов',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            _SummaryRow(label: 'Участников', value: '$participantCount'),
            const SizedBox(height: 8),
            _SummaryRow(label: 'Раундов', value: '$roundCount'),
            const SizedBox(height: 20),
            FilledButton.icon(
              key: const Key('open-tournament-rounds'),
              onPressed: onOpenRounds,
              icon: const Icon(Icons.view_agenda_outlined),
              label: const Text('Открыть раунды'),
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(label)),
        Text(value, style: Theme.of(context).textTheme.titleMedium),
      ],
    );
  }
}

class _ParticipantsList extends StatelessWidget {
  const _ParticipantsList({
    required this.draft,
    required this.assignments,
    required this.fighterRegistry,
    required this.avatarResolver,
  });

  final TournamentDraft draft;
  final Map<TournamentParticipantId, FighterAssignment> assignments;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Участники', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        for (final participant in draft.participants)
          _ParticipantCard(
            key: ValueKey('participant-${participant.id.value}'),
            nickname: participant.nickname.value,
            fighter: _fighterFor(participant.id),
            avatarResolver: avatarResolver,
          ),
      ],
    );
  }

  Fighter? _fighterFor(TournamentParticipantId participantId) {
    final assignment = assignments[participantId];
    return assignment == null
        ? null
        : fighterRegistry.findById(assignment.fighterId);
  }
}

class _ParticipantCard extends StatelessWidget {
  const _ParticipantCard({
    required this.nickname,
    required this.fighter,
    required this.avatarResolver,
    super.key,
  });

  final String nickname;
  final Fighter? fighter;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    final resolvedFighter = fighter;
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: SizedBox.square(
          dimension: 56,
          child: resolvedFighter == null
              ? const Icon(Icons.person_off_outlined)
              : ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    avatarResolver.resolve(resolvedFighter.avatarId),
                    key: ValueKey('fighter-avatar-${resolvedFighter.id.value}'),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.image_not_supported_outlined),
                  ),
                ),
        ),
        title: Text(nickname),
        subtitle: Text(resolvedFighter?.displayName ?? 'Боец недоступен'),
      ),
    );
  }
}
