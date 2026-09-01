import '../participant_identity/participant_identity.dart';

class StandingRowViewData {
  const StandingRowViewData({
    required this.placeLabel,
    required this.participant,
    required this.resultLabel,
    this.points,
    this.tieBreakLabel,
  });

  final String placeLabel;
  final PreviewParticipant participant;
  final String resultLabel;
  final int? points;
  final String? tieBreakLabel;
}
