import 'package:equatable/equatable.dart';

import 'tournament_ids.dart';

enum TournamentLifecycle {
  draft,
  open,
  distribution,
  running,
  finished,
  cancelled,
}

enum TournamentParticipantSource { localProfile, guest }

final class TournamentParticipant extends Equatable {
  TournamentParticipant({
    required this.id,
    required String nickname,
    required this.source,
    this.profileId,
  }) : nickname = _nickname(nickname) {
    if (source == TournamentParticipantSource.localProfile &&
        (profileId?.trim().isEmpty ?? true)) {
      throw const FormatException(
        'Local profile participant requires profileId.',
      );
    }
    if (source == TournamentParticipantSource.guest && profileId != null) {
      throw const FormatException('Guest cannot have profileId.');
    }
  }

  final TournamentParticipantId id;
  final String nickname;
  final TournamentParticipantSource source;
  final String? profileId;

  static String _nickname(String value) {
    final normalized = value.trim();
    if (normalized.isEmpty) {
      throw const FormatException('Nickname must not be empty.');
    }
    return normalized;
  }

  @override
  List<Object?> get props => [id, nickname, source, profileId];
}

final class TournamentFinalOutcome extends Equatable {
  const TournamentFinalOutcome({
    required this.championId,
    required this.ranking,
  });
  final TournamentParticipantId championId;
  final List<TournamentParticipantId> ranking;
  @override
  List<Object?> get props => [championId, ranking];
}

final class TournamentCancellation extends Equatable {
  const TournamentCancellation({
    required this.reason,
    required this.cancelledAtUtc,
  });
  final String reason;
  final DateTime cancelledAtUtc;
  @override
  List<Object?> get props => [reason, cancelledAtUtc];
}
