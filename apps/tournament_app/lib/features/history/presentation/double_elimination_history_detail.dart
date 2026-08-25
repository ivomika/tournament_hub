import 'package:flutter/material.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_match_status.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

class DoubleEliminationHistoryDetail extends StatelessWidget {
  const DoubleEliminationHistoryDetail({required this.snapshot, super.key});

  final FinishedDoubleEliminationSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final tournament = snapshot.tournament;
    final participants = {
      for (final participant in tournament.draft.participants)
        participant.id: participant,
    };
    final assignments = {
      for (final assignment in tournament.fighterAssignments)
        assignment.participantId: assignment,
    };
    String participantLabel(TournamentParticipantId id) {
      final fighterId = assignments[id]!.fighterId;
      final fighterName =
          snapshot.fighterNamesById[fighterId] ?? fighterId.value;
      return '${participants[id]!.nickname.value} · $fighterName';
    }

    return ListView(
      key: const Key('double-elimination-history-detail'),
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          tournament.draft.name.value,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const Text('Double Elimination · завершён'),
        const SizedBox(height: 20),
        Text('Итоговые места', style: Theme.of(context).textTheme.titleLarge),
        for (final (index, id) in snapshot.placements.indexed)
          ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text(participantLabel(id)),
          ),
        const SizedBox(height: 20),
        Text('Сетка', style: Theme.of(context).textTheme.titleLarge),
        for (final view in tournament.bracket.matches)
          Card(
            child: ListTile(
              title: Text(
                '${view.definition.stage.name} · раунд ${view.definition.round}',
              ),
              subtitle: Text(
                view.status == BracketMatchStatus.automatic
                    ? '${participantLabel(view.winnerId!)} · bye'
                    : view.status == BracketMatchStatus.skipped
                    ? 'Матч не потребовался'
                    : '${participantLabel(view.firstParticipantId!)} — '
                          '${participantLabel(view.secondParticipantId!)}',
              ),
              trailing: view.result == null
                  ? null
                  : Text('Победил: ${participantLabel(view.result!.winnerId)}'),
            ),
          ),
        if (tournament.placementReplays.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Переигровки', style: Theme.of(context).textTheme.titleLarge),
          for (final replays in tournament.placementReplays.values)
            for (final replay in replays)
              for (final match in replay.matches)
                ListTile(
                  title: Text(
                    '${participantLabel(match.scheduledMatch.firstParticipantId)} — '
                    '${participantLabel(match.scheduledMatch.secondParticipantId)}',
                  ),
                  trailing: Text(
                    'Победил: ${participantLabel(match.result!.winnerId)}',
                  ),
                ),
        ],
      ],
    );
  }
}
