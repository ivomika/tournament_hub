import 'package:tournament_app/presentation/widgetbook/screens/results/de/de_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/results/se/se_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/results/rr/rr_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/champion/winner/winner_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/forfeit/confirmation/confirmation_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/ft1/ft1_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/ft2/ft2_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/ft3/ft3_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/ft10/ft10_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/correction/correction_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/save_error/save_error_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/technical_rr/technical_rr_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/match_result/technical_de/technical_de_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bracket/de/de_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bracket/se/se_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/result_locked/dependent_match/dependent_match_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/withdraw/confirmation/confirmation_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tie/equal_points/equal_points_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/de/de_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/se/se_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/rr/rr_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/tournament/tiebreak/tiebreak_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/spectator_access/distribution/distribution_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/spectator_access/tournament/tournament_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/utility/distribution/distribution_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/distribution/ready/ready_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/guest_add/name/name_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/guest_remove/confirmation/confirmation_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/participant_access/code/code_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/roster/guests/guests_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/setup/de/de_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/setup/se/se_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/setup/rr/rr_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/history/list/list_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/history/empty/empty_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/contact/unavailable/unavailable_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/about/collapsed/collapsed_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/about/rules/rules_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/settings/dark_russian/dark_russian_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/editing/editing_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile_edit/error/error_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile/view/view_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/profile/newcomer/newcomer_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/home/empty/empty_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/home/active/active_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/loading/loading_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/error/error_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/preparing_navigation/preparing_navigation_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/retrying_navigation/retrying_navigation_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/preparing_component/preparing_component_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/dependency_unavailable/dependency_unavailable_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/timed_out/timed_out_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/incompatible_version/incompatible_version_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/restart_required/restart_required_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/cancelled/cancelled_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/retrying/retrying_use_case.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/profile_unavailable/profile_unavailable_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/empty/empty_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/editing/editing_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/invalid/invalid_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/saving/saving_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/registration/error/error_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/preparing_profile/preparing_profile_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/utility/loading/loading_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/utility/error/error_use_case.dart';

final screenCatalog = <WidgetbookNode>[
  WidgetbookComponent(
    name: 'Results',
    useCases: [resultsDeUseCase, resultsSeUseCase, resultsRrUseCase],
  ),
  WidgetbookComponent(name: 'Champion', useCases: [championWinnerUseCase]),
  WidgetbookComponent(name: 'Forfeit', useCases: [forfeitConfirmationUseCase]),
  WidgetbookComponent(
    name: 'MatchResult',
    useCases: [
      matchResultFt1UseCase,
      matchResultFt2UseCase,
      matchResultFt3UseCase,
      matchResultFt10UseCase,
      matchResultCorrectionUseCase,
      matchResultSaveErrorUseCase,
      matchResultTechnicalRrUseCase,
      matchResultTechnicalDeUseCase,
    ],
  ),
  WidgetbookComponent(
    name: 'Bracket',
    useCases: [bracketDeUseCase, bracketSeUseCase],
  ),
  WidgetbookComponent(
    name: 'ResultLocked',
    useCases: [resultLockedDependentMatchUseCase],
  ),
  WidgetbookComponent(
    name: 'Withdraw',
    useCases: [withdrawConfirmationUseCase],
  ),
  WidgetbookComponent(name: 'Tie', useCases: [tieEqualPointsUseCase]),
  WidgetbookComponent(
    name: 'Tournament',
    useCases: [
      tournamentDeUseCase,
      tournamentSeUseCase,
      tournamentRrUseCase,
      tournamentTiebreakUseCase,
    ],
  ),
  WidgetbookComponent(
    name: 'SpectatorAccess',
    useCases: [
      spectatorAccessDistributionUseCase,
      spectatorAccessTournamentUseCase,
    ],
  ),
  WidgetbookComponent(
    name: 'Distribution',
    useCases: [distributionReadyUseCase],
  ),
  WidgetbookComponent(name: 'GuestAdd', useCases: [guestAddNameUseCase]),
  WidgetbookComponent(
    name: 'GuestRemove',
    useCases: [guestRemoveConfirmationUseCase],
  ),
  WidgetbookComponent(
    name: 'ParticipantAccess',
    useCases: [participantAccessCodeUseCase],
  ),
  WidgetbookComponent(name: 'Roster', useCases: [rosterGuestsUseCase]),
  WidgetbookComponent(
    name: 'Setup',
    useCases: [setupDeUseCase, setupSeUseCase, setupRrUseCase],
  ),
  WidgetbookComponent(
    name: 'History',
    useCases: [historyListUseCase, historyEmptyUseCase],
  ),
  WidgetbookComponent(name: 'Contact', useCases: [contactUnavailableUseCase]),
  WidgetbookComponent(
    name: 'About',
    useCases: [aboutCollapsedUseCase, aboutRulesUseCase],
  ),
  WidgetbookComponent(name: 'Settings', useCases: [settingsDarkRussianUseCase]),
  WidgetbookComponent(
    name: 'ProfileEdit',
    useCases: [profileEditEditingUseCase, profileEditErrorUseCase],
  ),
  WidgetbookComponent(
    name: 'Registration',
    useCases: [
      registrationEmptyUseCase,
      registrationEditingUseCase,
      registrationInvalidUseCase,
      registrationSavingUseCase,
      registrationErrorUseCase,
    ],
  ),
  WidgetbookComponent(
    name: 'Profile',
    useCases: [profileViewUseCase, profileNewcomerUseCase],
  ),
  WidgetbookComponent(
    name: 'Home',
    useCases: [homeEmptyUseCase, homeActiveUseCase],
  ),
  WidgetbookComponent(
    name: 'Bootstrap',
    useCases: [
      bootstrapLoadingUseCase,
      bootstrapErrorUseCase,
      bootstrapRetryingUseCase,
      bootstrapPreparingNavigationUseCase,
      bootstrapPreparingProfileUseCase,
      bootstrapProfileUnavailableUseCase,
      bootstrapRetryingNavigationUseCase,
      bootstrapPreparingComponentUseCase,
      bootstrapDependencyUnavailableUseCase,
      bootstrapTimedOutUseCase,
      bootstrapIncompatibleVersionUseCase,
      bootstrapRestartRequiredUseCase,
      bootstrapCancelledUseCase,
    ],
  ),
  WidgetbookComponent(
    name: 'Utility',
    useCases: [
      utilityLoadingUseCase,
      utilityErrorUseCase,
      utilityDistributionUseCase,
    ],
  ),
];
