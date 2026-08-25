import 'package:flutter/material.dart';
import 'package:tournament_app/features/fighters/domain/repositories/fighter_registry.dart';
import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/fighters/presentation/resolvers/fighter_avatar_resolver.dart';
import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

class TournamentHistoryDetail extends StatelessWidget {
  const TournamentHistoryDetail({
    required this.snapshot,
    required this.fighterRegistry,
    required this.avatarResolver,
    super.key,
  });

  final FinishedTournamentSnapshot snapshot;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    final tournament = snapshot.tournament;
    final participantById = {
      for (final participant in tournament.draft.participants)
        participant.id: participant,
    };
    final assignmentByParticipantId = {
      for (final assignment in tournament.setup.fighterAssignments)
        assignment.participantId: assignment,
    };
    String fighterName(TournamentParticipantId id) {
      final fighterId = assignmentByParticipantId[id]!.fighterId;
      return snapshot.fighterNamesById[fighterId] ?? fighterId.value;
    }

    String participantLabel(TournamentParticipantId id) =>
        '${participantById[id]!.nickname.value} · ${fighterName(id)}';
    return ListView(
      key: const Key('history-detail'),
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          tournament.draft.name.value,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          '${snapshot.outcome.rulesetId} · версия ${snapshot.outcome.rulesetVersion}',
        ),
        const SizedBox(height: 20),
        Text('Итоговые места', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final row in snapshot.outcome.standings.rows)
          Card(
            child: ListTile(
              leading: CircleAvatar(child: Text('${row.position}')),
              title: Text(participantById[row.participantId]!.nickname.value),
              subtitle: Text(
                '${fighterName(row.participantId)}\n'
                '${row.wins} побед · ${row.losses} поражений · ${row.points} очков',
              ),
              trailing: _FighterAvatar(
                fighterId:
                    assignmentByParticipantId[row.participantId]!.fighterId,
                fighterRegistry: fighterRegistry,
                avatarResolver: avatarResolver,
              ),
            ),
          ),
        const SizedBox(height: 20),
        Text('Матчи', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        for (final round in tournament.setup.schedule.rounds) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              'Раунд ${round.number}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          for (final scheduled in round.matches)
            Builder(
              builder: (context) {
                final match = tournament.matches.firstWhere(
                  (item) => item.scheduledMatch.id == scheduled.id,
                );
                final result = match.result!;
                return ListTile(
                  title: Text(
                    '${participantLabel(scheduled.firstParticipantId)} — '
                    '${participantLabel(scheduled.secondParticipantId)}',
                  ),
                  trailing: Text(
                    '${result.firstParticipantScore}:${result.secondParticipantScore}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                );
              },
            ),
        ],
      ],
    );
  }
}

class _FighterAvatar extends StatelessWidget {
  const _FighterAvatar({
    required this.fighterId,
    required this.fighterRegistry,
    required this.avatarResolver,
  });

  final FighterId fighterId;
  final FighterRegistry fighterRegistry;
  final FighterAvatarResolver avatarResolver;

  @override
  Widget build(BuildContext context) {
    final fighter = fighterRegistry.findById(fighterId);
    if (fighter == null) return const Icon(Icons.person_off_outlined);
    return Tooltip(
      message: fighter.displayName,
      child: CircleAvatar(
        backgroundImage: AssetImage(avatarResolver.resolve(fighter.avatarId)),
      ),
    );
  }
}
