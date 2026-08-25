import 'package:flutter/material.dart';
import 'package:tournament_app/features/fighters/domain/entities/fighter.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

class DoubleEliminationResultsView extends StatelessWidget {
  const DoubleEliminationResultsView({
    required this.tournament,
    required this.fighterRegistry,
    required this.avatarResolver,
    super.key,
  });

  final DoubleEliminationTournament tournament;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    final placements = tournament.finalPlacements!;
    final participants = {
      for (final participant in tournament.draft.participants)
        participant.id: participant,
    };
    final champion = participants[placements.first]!;
    final championFighter = _fighter(placements.first);
    return ListView(
      key: const Key('double-elimination-results'),
      padding: const EdgeInsets.all(24),
      children: [
        Icon(
          Icons.emoji_events,
          size: 72,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Победитель турнира',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 8),
        Text(
          champion.nickname.value,
          key: const Key('double-elimination-champion'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        Text(
          championFighter?.displayName ?? 'Боец недоступен',
          key: const Key('double-elimination-champion-fighter'),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 32),
        Text('Итоговые места', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final (index, participantId) in placements.indexed)
          Card(
            child: ListTile(
              leading: Badge(
                label: Text('${index + 1}'),
                child: _FighterAvatar(
                  fighter: _fighter(participantId),
                  resolver: avatarResolver,
                ),
              ),
              title: Text(participants[participantId]!.nickname.value),
              subtitle: Text(
                _fighter(participantId)?.displayName ?? 'Боец недоступен',
              ),
            ),
          ),
      ],
    );
  }

  Fighter? _fighter(TournamentParticipantId participantId) {
    final assignment = tournament.fighterAssignments.firstWhere(
      (item) => item.participantId == participantId,
    );
    return fighterRegistry.findById(assignment.fighterId);
  }
}

class _FighterAvatar extends StatelessWidget {
  const _FighterAvatar({required this.fighter, required this.resolver});

  final Fighter? fighter;
  final FighterAvatarResolver resolver;

  @override
  Widget build(BuildContext context) {
    final value = fighter;
    return CircleAvatar(
      backgroundImage: value == null
          ? null
          : AssetImage(resolver.resolve(value.avatarId)),
      child: value == null ? const Icon(Icons.person_off_outlined) : null,
    );
  }
}
