import 'package:widgetbook/widgetbook.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/colors/dark_palette/colors_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/colors/primitive_scales/scales_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/typography/text_styles/typography_use_case.dart';

/// Регистрации добавляются из папок конкретных scoped use cases.
final widgetbookCatalog = <WidgetbookNode>[
  WidgetbookFolder(
    name: 'Foundation',
    isInitiallyExpanded: true,
    children: [
      WidgetbookComponent(
        name: 'Colors',
        useCases: [scalesUseCase, colorsUseCase],
      ),
      WidgetbookComponent(name: 'Typography', useCases: [typographyUseCase]),
    ],
  ),
];
