import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/screens/utility/loading/loading_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/utility/error/error_use_case.dart';

final screenCatalog = <WidgetbookNode>[
  WidgetbookComponent(
    name: 'Utility',
    useCases: [utilityLoadingUseCase, utilityErrorUseCase],
  ),
];
