import 'package:flutter/widgets.dart';
import 'package:tournament_app/app/routing/app_routes.dart';
import 'package:tournament_app/presentation/navigation/screen_navigation_controller.dart';
import 'package:tournament_app/presentation/screens/home/home_screen.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen.dart';
import 'package:tournament_app/presentation/screens/bootstrap/bootstrap_screen.dart';
import 'package:tournament_app/presentation/screens/tournament/tournament_screen.dart';
import 'package:tournament_app/presentation/screens/utility/utility_screen.dart';
import 'package:tournament_app/presentation/screens/profile_edit/profile_edit_screen.dart';
import 'package:tournament_app/presentation/screens/settings/settings_screen.dart';
import 'package:tournament_app/presentation/screens/about/about_screen.dart';
import 'package:tournament_app/presentation/screens/contact/contact_screen.dart';
import 'package:tournament_app/presentation/screens/history/history_screen.dart';
import 'package:tournament_app/presentation/screens/setup/setup_screen.dart';
import 'package:tournament_app/presentation/screens/roster/roster_screen.dart';
import 'package:tournament_app/presentation/screens/participant_access/participant_access_screen.dart';
import 'package:tournament_app/presentation/screens/guest_add/guest_add_screen.dart';
import 'package:tournament_app/presentation/screens/guest_remove/guest_remove_screen.dart';
import 'package:tournament_app/presentation/screens/distribution/distribution_screen.dart';
import 'package:tournament_app/presentation/screens/spectator_access/spectator_access_screen.dart';
import 'package:tournament_app/presentation/screens/tie/tie_screen.dart';
import 'package:tournament_app/presentation/screens/withdraw/withdraw_screen.dart';
import 'package:tournament_app/presentation/screens/result_locked/result_locked_screen.dart';
import 'package:tournament_app/presentation/screens/bracket/bracket_screen.dart';
import 'package:tournament_app/presentation/screens/match_result/match_result_screen.dart';
import 'package:tournament_app/presentation/screens/forfeit/forfeit_screen.dart';
import 'package:tournament_app/presentation/screens/champion/champion_screen.dart';
import 'package:tournament_app/presentation/screens/results/results_screen.dart';

/// App передаёт состояние экрана; route выбирает типизированный builder.
class ScreenRouteBuilders {
  const ScreenRouteBuilders({
    this.home,
    this.profile,
    this.bootstrap,
    this.tournament,
    this.utility,
    this.profileEdit,
    this.settings,
    this.about,
    this.contact,
    this.history,
    this.setup,
    this.roster,
    this.participantAccess,
    this.guestAdd,
    this.guestRemove,
    this.distribution,
    this.spectatorAccess,
    this.tie,
    this.withdraw,
    this.resultLocked,
    this.bracket,
    this.matchResult,
    this.forfeit,
    this.champion,
    this.results,
  });
  final HomeScreen Function(
    BuildContext context,
    HomeRoute route,
    ScreenNavigationController navigation,
  )?
  home;
  final ProfileScreen Function(
    BuildContext context,
    ProfileRoute route,
    ScreenNavigationController navigation,
  )?
  profile;
  final BootstrapScreen Function(
    BuildContext context,
    BootstrapRoute route,
    ScreenNavigationController navigation,
  )?
  bootstrap;
  final TournamentScreen Function(
    BuildContext context,
    TournamentRoute route,
    ScreenNavigationController navigation,
  )?
  tournament;
  final UtilityScreen Function(
    BuildContext context,
    UtilityRoute route,
    ScreenNavigationController navigation,
  )?
  utility;
  final ProfileEditScreen Function(
    BuildContext context,
    ProfileEditRoute route,
    ScreenNavigationController navigation,
  )?
  profileEdit;
  final SettingsScreen Function(
    BuildContext context,
    SettingsRoute route,
    ScreenNavigationController navigation,
  )?
  settings;
  final AboutScreen Function(
    BuildContext context,
    AboutRoute route,
    ScreenNavigationController navigation,
  )?
  about;
  final ContactScreen Function(
    BuildContext context,
    ContactRoute route,
    ScreenNavigationController navigation,
  )?
  contact;
  final HistoryScreen Function(
    BuildContext context,
    HistoryRoute route,
    ScreenNavigationController navigation,
  )?
  history;
  final SetupScreen Function(
    BuildContext context,
    SetupRoute route,
    ScreenNavigationController navigation,
  )?
  setup;
  final RosterScreen Function(
    BuildContext context,
    RosterRoute route,
    ScreenNavigationController navigation,
  )?
  roster;
  final ParticipantAccessScreen Function(
    BuildContext context,
    ParticipantAccessRoute route,
    ScreenNavigationController navigation,
  )?
  participantAccess;
  final GuestAddScreen Function(
    BuildContext context,
    GuestAddRoute route,
    ScreenNavigationController navigation,
  )?
  guestAdd;
  final GuestRemoveScreen Function(
    BuildContext context,
    GuestRemoveRoute route,
    ScreenNavigationController navigation,
  )?
  guestRemove;
  final DistributionScreen Function(
    BuildContext context,
    DistributionRoute route,
    ScreenNavigationController navigation,
  )?
  distribution;
  final SpectatorAccessScreen Function(
    BuildContext context,
    SpectatorAccessRoute route,
    ScreenNavigationController navigation,
  )?
  spectatorAccess;
  final TieScreen Function(
    BuildContext context,
    TieRoute route,
    ScreenNavigationController navigation,
  )?
  tie;
  final WithdrawScreen Function(
    BuildContext context,
    WithdrawRoute route,
    ScreenNavigationController navigation,
  )?
  withdraw;
  final ResultLockedScreen Function(
    BuildContext context,
    ResultLockedRoute route,
    ScreenNavigationController navigation,
  )?
  resultLocked;
  final BracketScreen Function(
    BuildContext context,
    BracketRoute route,
    ScreenNavigationController navigation,
  )?
  bracket;
  final MatchResultScreen Function(
    BuildContext context,
    MatchResultRoute route,
    ScreenNavigationController navigation,
  )?
  matchResult;
  final ForfeitScreen Function(
    BuildContext context,
    ForfeitRoute route,
    ScreenNavigationController navigation,
  )?
  forfeit;
  final ChampionScreen Function(
    BuildContext context,
    ChampionRoute route,
    ScreenNavigationController navigation,
  )?
  champion;
  final ResultsScreen Function(
    BuildContext context,
    ResultsRoute route,
    ScreenNavigationController navigation,
  )?
  results;
}
