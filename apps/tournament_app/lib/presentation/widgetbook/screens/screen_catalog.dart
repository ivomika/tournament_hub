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
