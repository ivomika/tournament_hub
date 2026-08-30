import 'package:equatable/equatable.dart';

sealed class TournamentScopedId extends Equatable {
  const TournamentScopedId(this.tournamentId, this.value);
  final String tournamentId;
  final String value;
  @override
  List<Object?> get props => [tournamentId, value];
}

final class GuestId extends TournamentScopedId {
  GuestId(super.tournamentId, super.value) {
    if (tournamentId.trim().isEmpty || value.trim().isEmpty) {
      throw const FormatException('Guest ID must be tournament-scoped.');
    }
  }
}

final class TournamentParticipantId extends TournamentScopedId {
  TournamentParticipantId(super.tournamentId, super.value) {
    if (tournamentId.trim().isEmpty || value.trim().isEmpty) {
      throw const FormatException('Participant ID must be tournament-scoped.');
    }
  }
}
