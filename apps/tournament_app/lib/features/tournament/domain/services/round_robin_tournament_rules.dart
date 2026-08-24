import 'package:tournament_app/features/tournament/domain/entities/scheduled_tournament_match.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_round.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_schedule.dart';
import 'package:tournament_app/features/tournament/domain/services/tournament_rules.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class RoundRobinTournamentRules implements TournamentRules {
  const RoundRobinTournamentRules();

  @override
  TournamentSchedule createSchedule(
    Iterable<TournamentParticipantId> participantIds,
  ) {
    final participants = List<TournamentParticipantId>.unmodifiable(
      participantIds,
    );
    final rotating = <TournamentParticipantId?>[
      ...participants,
      if (participants.length.isOdd) null,
    ];
    final rounds = <TournamentRound>[];

    for (var roundIndex = 0; roundIndex < rotating.length - 1; roundIndex++) {
      final matches = <ScheduledTournamentMatch>[];
      TournamentParticipantId? byeParticipantId;
      for (var pairIndex = 0; pairIndex < rotating.length ~/ 2; pairIndex++) {
        final first = rotating[pairIndex];
        final second = rotating[rotating.length - 1 - pairIndex];
        if (first == null || second == null) {
          byeParticipantId = first ?? second;
        } else {
          matches.add(
            ScheduledTournamentMatch(
              firstParticipantId: first,
              secondParticipantId: second,
            ),
          );
        }
      }
      rounds.add(
        TournamentRound(
          number: roundIndex + 1,
          matches: matches,
          byeParticipantId: byeParticipantId,
        ),
      );

      final last = rotating.removeLast();
      rotating.insert(1, last);
    }

    return TournamentSchedule(participantIds: participants, rounds: rounds);
  }
}
