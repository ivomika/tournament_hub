import '../tournament/models/host_tournament_projection.dart';
import 'models/spectator_projection.dart';

abstract final class SpectatorProjectionFactory {
  static SpectatorTournamentProjection? fromHost(
    HostTournamentProjection source,
  ) {
    if (source.lifecycle != 'distribution' &&
        source.lifecycle != 'running' &&
        source.lifecycle != 'finished') {
      return null;
    }
    final publicIds = <String, String>{
      for (var index = 0; index < source.participants.length; index++)
        source.participants[index].id: 'participant-${index + 1}',
    };
    String publicId(String internalId) => publicIds[internalId]!;

    return SpectatorTournamentProjection(
      tournamentId: source.id,
      revision: source.revision,
      sequence: source.sequence,
      title: source.title,
      formatId: source.formatId,
      lifecycle: source.lifecycle,
      participants: List.unmodifiable(
        source.participants.map(
          (participant) => SpectatorParticipantProjection(
            id: publicId(participant.id),
            nickname: participant.nickname,
            isGuest: participant.isGuest,
            fighter:
                participant.fighterId == null ||
                    participant.fighterName == null ||
                    participant.fighterAssetPath == null
                ? null
                : SpectatorFighterProjection(
                    id: participant.fighterId!,
                    displayName: participant.fighterName!,
                    assetPath: participant.fighterAssetPath!,
                  ),
          ),
        ),
      ),
      matches: List.unmodifiable(
        source.matches.map(
          (match) => SpectatorMatchProjection(
            id: match.id,
            round: match.round,
            order: match.order,
            stage: match.stage,
            firstTo: match.firstTo,
            firstParticipantId: publicId(match.firstParticipantId),
            secondParticipantId: publicId(match.secondParticipantId),
            status: match.status,
            result:
                match.winnerParticipantId == null ||
                    match.loserParticipantId == null
                ? null
                : SpectatorMatchResultProjection(
                    kind: match.isTechnical ? 'technical' : 'normal',
                    winnerParticipantId: publicId(match.winnerParticipantId!),
                    loserParticipantId: publicId(match.loserParticipantId!),
                    winnerScore: match.winnerScore,
                    loserScore: match.loserScore,
                    reason: match.technicalReason,
                  ),
          ),
        ),
      ),
      standings: List.unmodifiable(
        source.ranking.map(
          (standing) => SpectatorStandingProjection(
            participantId: publicId(standing.participantId),
            placeFrom: standing.from,
            placeTo: standing.to,
          ),
        ),
      ),
      championParticipantId: source.championId == null
          ? null
          : publicId(source.championId!),
    );
  }
}
