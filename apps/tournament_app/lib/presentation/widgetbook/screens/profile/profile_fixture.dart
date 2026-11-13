import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen_state.dart';

class ProfileFixture extends StatelessWidget {
  const ProfileFixture({required this.newcomer, super.key});
  final bool newcomer;
  static void action() {}
  @override
  Widget build(BuildContext context) => ProfileScreen(
    state: ProfileScreenState(
      name: 'Иван Михайлов',
      initials: 'ИМ',
      statistics: newcomer
          ? null
          : const ProfileStatistics(
              wins: '3',
              tournaments: '12',
              matches: '28',
            ),
      recent: newcomer
          ? null
          : const ProfileRecentTournament(
              place: '2',
              name: 'Пятничный турнир',
              character: 'Sub-Zero',
              initials: 'SZ',
              date: '14 октября · Double Elimination',
            ),
    ),
    onBack: action,
    onEdit: action,
    onCreate: action,
    onRecent: action,
    onSettings: action,
    onAbout: action,
    onContact: action,
  );
}
