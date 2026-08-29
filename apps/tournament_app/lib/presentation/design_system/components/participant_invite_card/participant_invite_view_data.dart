enum ParticipantInviteState { starting, ready, stale, unavailable, error }

class ParticipantInviteViewData {
  const ParticipantInviteViewData({
    required this.endpoint,
    required this.joinCode,
    required this.state,
  });

  final String endpoint;
  final String joinCode;
  final ParticipantInviteState state;
}
