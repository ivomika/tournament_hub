import 'package:tournament_app/presentation/widgetbook/screens/spectator_access/distribution/distribution_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/spectator_access/tournament/tournament_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/distribution/working/working_use_case.dart';
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
import 'package:tournament_app/presentation/widgetbook/screens/bootstrap/retrying/retrying_use_case.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/utility/loading/loading_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/utility/error/error_use_case.dart';

final screenCatalog = <WidgetbookNode>[
  WidgetbookComponent(
    name: 'SpectatorAccess',
    useCases: [
      spectatorAccessDistributionUseCase,
      spectatorAccessTournamentUseCase,
    ],
  ),
  WidgetbookComponent(
    name: 'Distribution',
    useCases: [distributionWorkingUseCase, distributionReadyUseCase],
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
    ],
  ),
  WidgetbookComponent(
    name: 'Utility',
    useCases: [utilityLoadingUseCase, utilityErrorUseCase],
  ),
];
