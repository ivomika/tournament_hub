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
