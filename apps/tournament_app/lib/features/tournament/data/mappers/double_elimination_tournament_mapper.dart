import 'dart:convert';

import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/tournament/domain/entities/bracket_slot_source.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_bracket.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_match_definition.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_topology.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/elimination_match_result.dart';
import 'package:tournament_app/features/tournament/domain/entities/fighter_assignment.dart';
import 'package:tournament_app/features/tournament/domain/entities/placement_replay.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_participant.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_slot_source_type.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/bracket_stage.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/match_update_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_format.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_match_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_name.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_id.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_nickname.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_participant_source.dart';

final class DoubleEliminationTournamentMapper {
  const DoubleEliminationTournamentMapper();

  String encode(DoubleEliminationTournament tournament) {
    return jsonEncode({
      'schemaVersion': 2,
      'draft': {
        'id': tournament.draft.id.value,
        'name': tournament.draft.name.value,
        'participants': [
          for (final participant in tournament.draft.participants)
            {
              'id': participant.id.value,
              'nickname': participant.nickname.value,
              'source': participant.source.name,
            },
        ],
      },
      'assignments': [
        for (final assignment in tournament.fighterAssignments)
          {
            'participantId': assignment.participantId.value,
            'fighterId': assignment.fighterId.value,
          },
      ],
      'topology': {
        'participants': [
          for (final id in tournament.bracket.topology.participants) id.value,
        ],
        'seededSlots': [
          for (final id in tournament.bracket.topology.seededSlots) id?.value,
        ],
        'matches': [
          for (final definition in tournament.bracket.topology.matches)
            {
              'id': definition.id.value,
              'stage': definition.stage.name,
              'round': definition.round,
              'position': definition.position,
              'firstSource': _encodeSource(definition.firstSource),
              'secondSource': _encodeSource(definition.secondSource),
            },
        ],
      },
      'results': [
        for (final result in tournament.bracket.results.values)
          _encodeResult(result),
      ],
      'placementReplays': {
        for (final entry in tournament.placementReplays.entries)
          entry.key: [
            for (final replay in entry.value)
              {
                'participantIds': [
                  for (final id in replay.participantIds) id.value,
                ],
                'replayNumber': replay.replayNumber,
                'results': [
                  for (final result in replay.results.values)
                    _encodeResult(result),
                ],
              },
          ],
      },
    });
  }

  DoubleEliminationTournament decode(String payload) {
    final root = jsonDecode(payload) as Map<String, dynamic>;
    final draftData = root['draft'] as Map<String, dynamic>;
    final draft = TournamentDraft(
      id: TournamentId(draftData['id'] as String),
      name: TournamentName(draftData['name'] as String),
      format: TournamentFormat.doubleElimination,
      participants: (draftData['participants'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(
            (item) => TournamentParticipant(
              id: TournamentParticipantId(item['id'] as String),
              nickname: TournamentParticipantNickname(
                item['nickname'] as String,
              ),
              source: TournamentParticipantSource.values.byName(
                item['source'] as String,
              ),
            ),
          ),
    );
    final topologyData = root['topology'] as Map<String, dynamic>;
    final topology = DoubleEliminationTopology(
      participants: (topologyData['participants'] as List<dynamic>)
          .cast<String>()
          .map(TournamentParticipantId.new),
      seededSlots: (topologyData['seededSlots'] as List<dynamic>).map(
        (value) =>
            value == null ? null : TournamentParticipantId(value as String),
      ),
      matches: (topologyData['matches'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(
            (item) => DoubleEliminationMatchDefinition(
              id: TournamentMatchId(item['id'] as String),
              stage: BracketStage.values.byName(item['stage'] as String),
              round: item['round'] as int,
              position: item['position'] as int,
              firstSource: _decodeSource(
                item['firstSource'] as Map<String, dynamic>,
              ),
              secondSource: _decodeSource(
                item['secondSource'] as Map<String, dynamic>,
              ),
            ),
          ),
    );
    final bracket = DoubleEliminationBracket(
      topology: topology,
      results: {
        for (final item
            in (root['results'] as List<dynamic>).cast<Map<String, dynamic>>())
          TournamentMatchId(item['id'] as String): _decodeResult(item),
      },
    );
    final placementData =
        root['placementReplays'] as Map<String, dynamic>? ?? const {};
    return DoubleEliminationTournament(
      draft: draft,
      fighterAssignments: (root['assignments'] as List<dynamic>)
          .cast<Map<String, dynamic>>()
          .map(
            (item) => FighterAssignment(
              participantId: TournamentParticipantId(
                item['participantId'] as String,
              ),
              fighterId: FighterId(item['fighterId'] as String),
            ),
          ),
      bracket: bracket,
      placementReplays: placementData.map(
        (key, value) => MapEntry(
          key,
          (value as List<dynamic>).cast<Map<String, dynamic>>().map((item) {
            final results = {
              for (final result
                  in (item['results'] as List<dynamic>)
                      .cast<Map<String, dynamic>>())
                TournamentMatchId(result['id'] as String): _decodeResult(
                  result,
                ),
            };
            return PlacementReplay(
              participantIds: (item['participantIds'] as List<dynamic>)
                  .cast<String>()
                  .map(TournamentParticipantId.new),
              replayNumber: item['replayNumber'] as int,
              results: results,
            );
          }).toList(),
        ),
      ),
    );
  }

  Map<String, Object?> _encodeSource(BracketSlotSource source) => {
    'type': source.type.name,
    'seedIndex': source.seedIndex,
    'matchId': source.matchId?.value,
  };

  BracketSlotSource _decodeSource(Map<String, dynamic> data) {
    return switch (BracketSlotSourceType.values.byName(
      data['type'] as String,
    )) {
      BracketSlotSourceType.seed => BracketSlotSource.seed(
        data['seedIndex'] as int,
      ),
      BracketSlotSourceType.winner => BracketSlotSource.winner(
        TournamentMatchId(data['matchId'] as String),
      ),
      BracketSlotSourceType.loser => BracketSlotSource.loser(
        TournamentMatchId(data['matchId'] as String),
      ),
    };
  }

  Map<String, Object?> _encodeResult(EliminationMatchResult result) {
    return {
      'id': result.matchId.value,
      'firstParticipantId': result.firstParticipantId.value,
      'secondParticipantId': result.secondParticipantId.value,
      'winnerId': result.winnerId.value,
      'updateId': result.updateId.value,
    };
  }

  EliminationMatchResult _decodeResult(Map<String, dynamic> data) {
    final winnerId = data['winnerId'] as String? ?? _legacyWinnerId(data);
    final updateIds = (data['updateIds'] as List<dynamic>? ?? const [])
        .whereType<String>()
        .toList();
    return EliminationMatchResult(
      matchId: TournamentMatchId(data['id'] as String),
      firstParticipantId: TournamentParticipantId(
        data['firstParticipantId'] as String,
      ),
      secondParticipantId: TournamentParticipantId(
        data['secondParticipantId'] as String,
      ),
      winnerId: TournamentParticipantId(winnerId),
      updateId: MatchUpdateId(
        data['updateId'] as String? ??
            (updateIds.isEmpty ? null : updateIds.first) ??
            'legacy-${data['id'] as String}',
      ),
    );
  }

  String _legacyWinnerId(Map<String, dynamic> data) {
    final technicalWinnerId = data['technicalWinnerId'] as String?;
    if (technicalWinnerId != null) return technicalWinnerId;
    final wins = <String, int>{};
    for (final bout
        in (data['bouts'] as List<dynamic>? ?? const [])
            .cast<Map<String, dynamic>>()) {
      final id = bout['winnerId'] as String;
      wins[id] = (wins[id] ?? 0) + 1;
    }
    if (wins.isEmpty) {
      throw const FormatException(
        'Сохранённый результат Double Elimination не содержит победителя.',
      );
    }
    return wins.entries.reduce((left, right) {
      return left.value >= right.value ? left : right;
    }).key;
  }
}
