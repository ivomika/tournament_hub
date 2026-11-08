import 'package:flutter/foundation.dart';

@immutable
class ProfileStatistics {
  const ProfileStatistics({
    required this.wins,
    required this.tournaments,
    required this.matches,
  });
  final String wins, tournaments, matches;
}

@immutable
class ProfileRecentTournament {
  const ProfileRecentTournament({
    required this.place,
    required this.name,
    required this.character,
    required this.initials,
    required this.date,
  });
  final String place, name, character, initials, date;
}

@immutable
class ProfileScreenState {
  const ProfileScreenState({
    required this.name,
    required this.initials,
    this.statistics,
    this.recent,
  });
  final String name, initials;
  final ProfileStatistics? statistics;
  final ProfileRecentTournament? recent;
}
