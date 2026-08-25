import 'dart:math' as math;

import 'package:tournament_app/features/tournament/domain/entities/bracket_slot_source.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_match_definition.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_topology.dart';
import 'package:tournament_app/features/tournament/domain/exceptions/tournament_validation_exception.dart';
import 'package:tournament_app/features/tournament/domain/services/random_index_generator.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_stage.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';

final class DoubleEliminationTopologyGenerator {
  const DoubleEliminationTopologyGenerator(this._random);

  final RandomIndexGenerator _random;

  DoubleEliminationTopology generate(
    Iterable<TournamentParticipantId> participantIds,
  ) {
    final participants = participantIds.toList();
    if (participants.length < 2 ||
        participants.toSet().length != participants.length) {
      throw const TournamentValidationException(
        'Double Elimination требует минимум двух уникальных участников.',
      );
    }
    _shuffle(participants);
    final bracketSize = _nextPowerOfTwo(participants.length);
    final slots = _createSeededSlots(participants, bracketSize);
    final matches = <DoubleEliminationMatchDefinition>[];
    final winnersByRound = <int, List<TournamentMatchId>>{};
    final winnersRoundCount = math.log(bracketSize) ~/ math.ln2;

    for (var round = 1; round <= winnersRoundCount; round++) {
      final count = bracketSize >> round;
      final ids = <TournamentMatchId>[];
      for (var position = 0; position < count; position++) {
        final id = TournamentMatchId('de-w-$round-${position + 1}');
        ids.add(id);
        matches.add(
          DoubleEliminationMatchDefinition(
            id: id,
            stage: BracketStage.winners,
            round: round,
            position: position,
            firstSource: round == 1
                ? BracketSlotSource.seed(position * 2)
                : BracketSlotSource.winner(
                    winnersByRound[round - 1]![position * 2],
                  ),
            secondSource: round == 1
                ? BracketSlotSource.seed(position * 2 + 1)
                : BracketSlotSource.winner(
                    winnersByRound[round - 1]![position * 2 + 1],
                  ),
          ),
        );
      }
      winnersByRound[round] = ids;
    }

    TournamentMatchId losersChampionSource;
    if (bracketSize == 2) {
      losersChampionSource = winnersByRound[1]!.single;
    } else {
      var losersRound = 1;
      var previousIds = <TournamentMatchId>[];
      final firstLosers = winnersByRound[1]!;
      for (var position = 0; position < firstLosers.length ~/ 2; position++) {
        final id = TournamentMatchId('de-l-$losersRound-${position + 1}');
        previousIds.add(id);
        matches.add(
          DoubleEliminationMatchDefinition(
            id: id,
            stage: BracketStage.losers,
            round: losersRound,
            position: position,
            firstSource: BracketSlotSource.loser(firstLosers[position * 2]),
            secondSource: BracketSlotSource.loser(
              firstLosers[position * 2 + 1],
            ),
          ),
        );
      }
      for (
        var winnersRound = 2;
        winnersRound <= winnersRoundCount;
        winnersRound++
      ) {
        losersRound += 1;
        final injectedIds = <TournamentMatchId>[];
        final droppedIds = winnersByRound[winnersRound]!;
        for (var position = 0; position < previousIds.length; position++) {
          final id = TournamentMatchId('de-l-$losersRound-${position + 1}');
          injectedIds.add(id);
          matches.add(
            DoubleEliminationMatchDefinition(
              id: id,
              stage: BracketStage.losers,
              round: losersRound,
              position: position,
              firstSource: BracketSlotSource.winner(previousIds[position]),
              secondSource: BracketSlotSource.loser(
                droppedIds[droppedIds.length - 1 - position],
              ),
            ),
          );
        }
        previousIds = injectedIds;
        if (winnersRound < winnersRoundCount) {
          losersRound += 1;
          final consolidatedIds = <TournamentMatchId>[];
          for (
            var position = 0;
            position < previousIds.length ~/ 2;
            position++
          ) {
            final id = TournamentMatchId('de-l-$losersRound-${position + 1}');
            consolidatedIds.add(id);
            matches.add(
              DoubleEliminationMatchDefinition(
                id: id,
                stage: BracketStage.losers,
                round: losersRound,
                position: position,
                firstSource: BracketSlotSource.winner(
                  previousIds[position * 2],
                ),
                secondSource: BracketSlotSource.winner(
                  previousIds[position * 2 + 1],
                ),
              ),
            );
          }
          previousIds = consolidatedIds;
        }
      }
      losersChampionSource = previousIds.single;
    }

    final grandFinalId = TournamentMatchId('de-grand-final');
    matches.add(
      DoubleEliminationMatchDefinition(
        id: grandFinalId,
        stage: BracketStage.grandFinal,
        round: 1,
        position: 0,
        firstSource: BracketSlotSource.winner(
          winnersByRound[winnersRoundCount]!.single,
        ),
        secondSource: bracketSize == 2
            ? BracketSlotSource.loser(losersChampionSource)
            : BracketSlotSource.winner(losersChampionSource),
      ),
    );
    matches.add(
      DoubleEliminationMatchDefinition(
        id: TournamentMatchId('de-grand-final-reset'),
        stage: BracketStage.grandFinalReset,
        round: 1,
        position: 0,
        firstSource: BracketSlotSource.winner(grandFinalId),
        secondSource: BracketSlotSource.loser(grandFinalId),
      ),
    );
    return DoubleEliminationTopology(
      participants: participants,
      seededSlots: slots,
      matches: matches,
    );
  }

  List<TournamentParticipantId?> _createSeededSlots(
    List<TournamentParticipantId> participants,
    int bracketSize,
  ) {
    final byeCount = bracketSize - participants.length;
    final matchIndices = List.generate(bracketSize ~/ 2, (index) => index);
    _shuffle(matchIndices);
    final slots = List<TournamentParticipantId?>.filled(bracketSize, null);
    final reservedByeSlots = <int>{};
    var participantIndex = 0;
    for (var index = 0; index < byeCount; index++) {
      final matchIndex = matchIndices[index];
      final side = _random.nextInt(2);
      slots[matchIndex * 2 + side] = participants[participantIndex++];
      reservedByeSlots.add(matchIndex * 2 + (side == 0 ? 1 : 0));
    }
    for (var slot = 0; slot < slots.length; slot++) {
      if (slots[slot] == null &&
          !reservedByeSlots.contains(slot) &&
          participantIndex < participants.length) {
        slots[slot] = participants[participantIndex++];
      }
    }
    return slots;
  }

  void _shuffle<T>(List<T> values) {
    for (var index = values.length - 1; index > 0; index--) {
      final other = _random.nextInt(index + 1);
      final value = values[index];
      values[index] = values[other];
      values[other] = value;
    }
  }

  int _nextPowerOfTwo(int value) {
    var result = 1;
    while (result < value) {
      result *= 2;
    }
    return result;
  }
}
