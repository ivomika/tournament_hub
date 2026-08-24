import 'package:flutter/material.dart';
import 'package:tournament_app/app/presentation/layout/app_breakpoints.dart';
import 'package:tournament_app/features/tournament/domain/entities/scheduled_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_round.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_setup.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

class TournamentRoundsScreen extends StatelessWidget {
  const TournamentRoundsScreen({
    required this.draft,
    required this.setup,
    super.key,
  });

  final TournamentDraft draft;
  final TournamentSetup setup;

  @override
  Widget build(BuildContext context) {
    final nicknames = <TournamentParticipantId, String>{
      for (final participant in draft.participants)
        participant.id: participant.nickname.value,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Раунды')),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            key: const Key('tournament-rounds-content'),
            constraints: const BoxConstraints(
              maxWidth: AppBreakpoints.maxContentWidth,
            ),
            child: ListView.separated(
              padding: const EdgeInsets.all(24),
              itemCount: setup.schedule.rounds.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => _RoundCard(
                round: setup.schedule.rounds[index],
                nicknames: nicknames,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RoundCard extends StatelessWidget {
  const _RoundCard({required this.round, required this.nicknames});

  final TournamentRound round;
  final Map<TournamentParticipantId, String> nicknames;

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
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),
            for (final match in round.matches) ...[
              _MatchRow(match: match, nicknames: nicknames),
              const Divider(height: 20),
            ],
            if (round.byeParticipantId case final bye?)
              Row(
                key: ValueKey('round-${round.number}-bye'),
                children: [
                  const Icon(Icons.free_breakfast_outlined, size: 20),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Пропускает раунд: ${_nickname(bye)}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  String _nickname(TournamentParticipantId id) =>
      nicknames[id] ?? 'Неизвестный участник';
}

class _MatchRow extends StatelessWidget {
  const _MatchRow({required this.match, required this.nicknames});

  final ScheduledTournamentMatch match;
  final Map<TournamentParticipantId, String> nicknames;

  @override
  Widget build(BuildContext context) {
    return Row(
      key: ValueKey(
        'match-${match.firstParticipantId.value}-${match.secondParticipantId.value}',
      ),
      children: [
        Expanded(
          child: Text(
            _nickname(match.firstParticipantId),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Text('VS'),
        ),
        Expanded(
          child: Text(
            _nickname(match.secondParticipantId),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  String _nickname(TournamentParticipantId id) =>
      nicknames[id] ?? 'Неизвестный участник';
}
