import 'dart:convert';

import 'package:tournament_app/features/fighters/domain/value_objects/fighter_id.dart';
import 'package:tournament_app/features/tournament/data/mappers/double_elimination_tournament_mapper.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';

final class FinishedDoubleEliminationSnapshotMapper {
  const FinishedDoubleEliminationSnapshotMapper();

  static const _tournamentMapper = DoubleEliminationTournamentMapper();

  String encode(FinishedDoubleEliminationSnapshot snapshot) {
    return jsonEncode({
      'schemaVersion': 1,
      'tournamentPayload': _tournamentMapper.encode(snapshot.tournament),
      'fighterNames': {
        for (final entry in snapshot.fighterNamesById.entries)
          entry.key.value: entry.value,
      },
    });
  }

  FinishedDoubleEliminationSnapshot decode(String payload) {
    final data = jsonDecode(payload) as Map<String, dynamic>;
    return FinishedDoubleEliminationSnapshot(
      tournament: _tournamentMapper.decode(data['tournamentPayload'] as String),
      fighterNamesById: (data['fighterNames'] as Map<String, dynamic>).map(
        (id, name) => MapEntry(FighterId(id), name as String),
      ),
    );
  }
}
