import '../../../domain/tournament/engine/tournament_engines.dart';
import '../../../domain/tournament/tournament_models.dart';
import 'host_tournament_session.dart';

final class HostParticipantProjection {
  const HostParticipantProjection({
    required this.id,
    required this.nickname,
    required this.isGuest,
    this.fighterId,
    this.fighterName,
    this.fighterAssetPath,
  });

  final String id;
  final String nickname;
  final bool isGuest;
  final String? fighterId;
  final String? fighterName;
  final String? fighterAssetPath;
}

final class HostMatchProjection {
  const HostMatchProjection({
    required this.id,
    required this.round,
    required this.order,
    required this.stage,
    required this.status,
    required this.firstTo,
    required this.firstParticipantId,
    required this.secondParticipantId,
    this.winnerScore,
    this.loserScore,
    this.isTechnical = false,
    this.winnerParticipantId,
    this.loserParticipantId,
    this.technicalReason,
  });

  final String id;
  final int round;
  final int order;
  final String stage;
  final String status;
  final int firstTo;
  final String firstParticipantId;
  final String secondParticipantId;
  final int? winnerScore;
  final int? loserScore;
  final bool isTechnical;
  final String? winnerParticipantId;
  final String? loserParticipantId;
  final String? technicalReason;
}

final class HostPlacementProjection {
  const HostPlacementProjection({
    required this.participantId,
    required this.from,
    required this.to,
  });

  final String participantId;
  final int from;
  final int to;
}

final class HostTournamentProjection {
  const HostTournamentProjection({
    required this.id,
    required this.title,
    required this.formatId,
    required this.lifecycle,
    required this.participants,
    required this.matches,
    required this.ranking,
    required this.revision,
    required this.sequence,
    this.championId,
    this.cancellationReason,
  });

  final String id;
  final String title;
  final String formatId;
  final String lifecycle;
  final List<HostParticipantProjection> participants;
  final List<HostMatchProjection> matches;
  final List<HostPlacementProjection> ranking;
  final int revision;
  final int sequence;
  final String? championId;
  final String? cancellationReason;

  HostMatchProjection? get currentMatch =>
      matches.where((value) => value.status == 'current').firstOrNull;
  bool get isReadyToFinish => championId != null;
}

abstract final class HostTournamentProjectionMapper {
  static HostTournamentProjection fromSession(HostTournamentSession session) {
    final tournament = session.tournament;
    final assignments = tournament.assignments;
    final state = session.engineState;
    return HostTournamentProjection(
      id: tournament.id,
      title: tournament.title,
      formatId: tournament.formatId,
      lifecycle: tournament.lifecycle.name,
      revision: session.storageRevision,
      sequence: session.lastSequence,
      participants: List.unmodifiable(
        tournament.participants.map((participant) {
          final assignment = assignments?.forParticipant(participant.id);
          return HostParticipantProjection(
            id: participant.id.value,
            nickname: participant.nickname,
            isGuest: participant.source.name == 'guest',
            fighterId: assignment?.fighter.id.value,
            fighterName: assignment?.fighter.displayName,
            fighterAssetPath: assignment?.fighter.assetPath,
          );
        }),
      ),
      matches: List.unmodifiable(
        state?.matches.map((match) {
              final result = match.result;
              return HostMatchProjection(
                id: match.id,
                round: match.round,
                order: match.order,
                stage: match.stage.name,
                status: match.status.name,
                firstTo: match.firstTo,
                firstParticipantId: match.firstParticipantId.value,
                secondParticipantId: match.secondParticipantId.value,
                winnerScore: result is NormalMatchResult
                    ? result.winnerScore
                    : null,
                loserScore: result is NormalMatchResult
                    ? result.loserScore
                    : null,
                isTechnical: result is TechnicalMatchResult,
                winnerParticipantId: result?.winnerId.value,
                loserParticipantId: result?.loserId.value,
                technicalReason: result is TechnicalMatchResult
                    ? result.reason.name
                    : null,
              );
            }) ??
            const <HostMatchProjection>[],
      ),
      ranking: List.unmodifiable(
        tournament.lifecycle == TournamentLifecycle.cancelled
            ? const <HostPlacementProjection>[]
            : state?.outcome?.ranking.map(
                    (placement) => HostPlacementProjection(
                      participantId: placement.participantId.value,
                      from: placement.from,
                      to: placement.to,
                    ),
                  ) ??
                  const <HostPlacementProjection>[],
      ),
      championId: tournament.lifecycle == TournamentLifecycle.cancelled
          ? null
          : state?.outcome?.championId.value,
      cancellationReason: tournament.cancellation?.reason,
    );
  }
}
