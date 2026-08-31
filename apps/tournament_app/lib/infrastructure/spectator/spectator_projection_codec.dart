import '../../application/spectator/models/spectator_projection.dart';

abstract final class SpectatorProjectionCodec {
  static Map<String, Object?> encode(SpectatorTournamentProjection value) => {
    'tournamentId': value.tournamentId,
    'revision': value.revision,
    'sequence': value.sequence,
    'snapshotVersion': SpectatorTournamentProjection.snapshotVersion,
    if (value.championParticipantId != null)
      'championParticipantId': value.championParticipantId,
    'tournament': {
      'title': value.title,
      'formatId': value.formatId,
      'rulesetVersion': SpectatorTournamentProjection.rulesetVersion,
      'lifecycle': value.lifecycle,
    },
    'participants': [
      for (final participant in value.participants)
        {
          'participantId': participant.id,
          'nickname': participant.nickname,
          'isGuest': participant.isGuest,
          if (participant.fighter case final fighter?)
            'fighter': {
              'fighterId': fighter.id,
              'displayName': fighter.displayName,
              'assetPath': fighter.assetPath,
            },
        },
    ],
    'matches': [
      for (final match in value.matches)
        {
          'matchId': match.id,
          'round': match.round,
          'order': match.order,
          'stage': match.stage,
          'firstTo': match.firstTo,
          'firstParticipantId': match.firstParticipantId,
          'secondParticipantId': match.secondParticipantId,
          'status': match.status,
          if (match.result case final result?)
            'result': {
              'kind': result.kind,
              'winnerParticipantId': result.winnerParticipantId,
              'loserParticipantId': result.loserParticipantId,
              if (result.winnerScore != null) 'winnerScore': result.winnerScore,
              if (result.loserScore != null) 'loserScore': result.loserScore,
              if (result.reason != null) 'reason': result.reason,
            },
        },
    ],
    'standings': [
      for (final standing in value.standings)
        {
          'participantId': standing.participantId,
          'placeFrom': standing.placeFrom,
          'placeTo': standing.placeTo,
        },
    ],
  };
}
