import '../participant_identity/participant_identity.dart';

enum TournamentStructureFormat {
  doubleElimination,
  singleElimination,
  roundRobin,
}

enum BracketLane { winners, losers, finals, stage }

enum BracketMatchState { pending, current, won, lost, bye, reset, locked }

class BracketMatchViewData {
  const BracketMatchViewData({
    required this.id,
    required this.title,
    required this.lane,
    required this.round,
    required this.order,
    required this.first,
    required this.second,
    this.state = BracketMatchState.pending,
    this.resultLabel,
    this.conditionLabel,
  });

  final String id;
  final String title;
  final BracketLane lane;
  final int round;
  final int order;
  final PreviewParticipant? first;
  final PreviewParticipant? second;
  final BracketMatchState state;
  final String? resultLabel;
  final String? conditionLabel;
}

class BracketLinkViewData {
  const BracketLinkViewData({
    required this.fromMatchId,
    required this.toMatchId,
    required this.label,
  });

  final String fromMatchId;
  final String toMatchId;
  final String label;
}

class BracketViewData {
  const BracketViewData({
    required this.format,
    required this.matches,
    this.links = const [],
  });

  final TournamentStructureFormat format;
  final List<BracketMatchViewData> matches;
  final List<BracketLinkViewData> links;
}
