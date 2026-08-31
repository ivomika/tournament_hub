final class SpectatorFighterProjection {
  const SpectatorFighterProjection({
    required this.id,
    required this.displayName,
    required this.assetPath,
  });

  final String id;
  final String displayName;
  final String assetPath;
}

final class SpectatorParticipantProjection {
  const SpectatorParticipantProjection({
    required this.id,
    required this.nickname,
    required this.isGuest,
    this.fighter,
  });

  final String id;
  final String nickname;
  final bool isGuest;
  final SpectatorFighterProjection? fighter;
}

final class SpectatorMatchResultProjection {
  const SpectatorMatchResultProjection({
    required this.kind,
    required this.winnerParticipantId,
    required this.loserParticipantId,
    this.winnerScore,
    this.loserScore,
    this.reason,
  });

  final String kind;
  final String winnerParticipantId;
  final String loserParticipantId;
  final int? winnerScore;
  final int? loserScore;
  final String? reason;
}

final class SpectatorMatchProjection {
  const SpectatorMatchProjection({
    required this.id,
    required this.round,
    required this.order,
    required this.stage,
    required this.firstTo,
    required this.firstParticipantId,
    required this.secondParticipantId,
    required this.status,
    this.result,
  });

  final String id;
  final int round;
  final int order;
  final String stage;
  final int firstTo;
  final String firstParticipantId;
  final String secondParticipantId;
  final String status;
  final SpectatorMatchResultProjection? result;
}

final class SpectatorStandingProjection {
  const SpectatorStandingProjection({
    required this.participantId,
    required this.placeFrom,
    required this.placeTo,
  });

  final String participantId;
  final int placeFrom;
  final int placeTo;
}

final class SpectatorTournamentProjection {
  const SpectatorTournamentProjection({
    required this.tournamentId,
    required this.revision,
    required this.sequence,
    required this.title,
    required this.formatId,
    required this.lifecycle,
    required this.participants,
    required this.matches,
    required this.standings,
    this.championParticipantId,
  });

  static const snapshotVersion = 1;
  static const rulesetVersion = 1;

  final String tournamentId;
  final int revision;
  final int sequence;
  final String title;
  final String formatId;
  final String lifecycle;
  final List<SpectatorParticipantProjection> participants;
  final List<SpectatorMatchProjection> matches;
  final List<SpectatorStandingProjection> standings;
  final String? championParticipantId;
}
