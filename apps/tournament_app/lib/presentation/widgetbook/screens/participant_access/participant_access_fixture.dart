import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/participant_access/participant_access_screen.dart';
import 'package:tournament_app/presentation/screens/participant_access/participant_access_screen_state.dart';

class ParticipantAccessFixture extends StatelessWidget {
  const ParticipantAccessFixture({super.key});
  static void action() {}
  @override
  Widget build(BuildContext context) => ParticipantAccessScreen(
    state: ParticipantAccessScreenState(
      qrPayload: 'http://localhost/code=48271930615',
      code: "4827 1930 615",
    ),
    onBack: action,
  );
}
