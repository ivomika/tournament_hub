enum ParticipantJoinState {
  idle,
  scanning,
  connecting,
  accepted,
  denied,
  notFound,
  error,
}

class ParticipantJoinViewData {
  const ParticipantJoinViewData({required this.state, this.enteredValue = ''});

  final ParticipantJoinState state;
  final String enteredValue;
}
