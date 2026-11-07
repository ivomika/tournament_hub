import 'package:tournament_app/presentation/widgetbook/foundation/shape/large_sheet/large_sheet_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/shape/source_shapes/source_shapes_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/shape/sheet/sheet_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/spacing/source_scale/source_scale_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/spacing/application/application_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/typography/source_roles/source_roles_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/colors/source_roles/source_roles_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/default/default_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/revealed/revealed_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/focus/focus_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/disabled/disabled_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/roster_row/long/long_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/inline/inline_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/stacked/stacked_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/participant/participant_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/identity/long/long_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/content/content_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/primary/primary_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/secondary/secondary_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/destructive/destructive_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/icon/icon_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/button/accenticon/accenticon_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/surface/panel/panel_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/surface/nested/nested_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/icons/slots/slots_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/icons/glyphs/glyphs_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/content/content_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/size_28/size_28_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/size_40/size_40_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/size_48/size_48_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/size_64/size_64_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/size_96/size_96_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/size_112/size_112_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/avatar/size_128/size_128_use_case.dart';
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
        name: 'Shape',
        useCases: [
          shapeSourceUseCase,
          shapeSheetUseCase,
          shapeLargeSheetUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Spacing',
        useCases: [spacingScaleUseCase, spacingApplicationUseCase],
      ),
      WidgetbookComponent(
        name: 'Colors',
        useCases: [scalesUseCase, colorsUseCase, sourceColorsUseCase],
      ),
      WidgetbookComponent(
        name: 'Icons',
        useCases: [iconUseCase, iconSlotsUseCase],
      ),
      WidgetbookComponent(
        name: 'Typography',
        useCases: [typographyUseCase, sourceTypographyUseCase],
      ),
    ],
  ),
  WidgetbookFolder(
    name: 'Components',
    isInitiallyExpanded: true,
    children: [
      WidgetbookComponent(
        name: 'Button',
        useCases: [
          primaryButtonUseCase,
          contentButtonUseCase,
          secondaryButtonUseCase,
          destructiveButtonUseCase,
          iconButtonUseCase,
          accenticonButtonUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Surface',
        useCases: [panelSurfaceUseCase, nestedSurfaceUseCase],
      ),
      WidgetbookComponent(
        name: 'Avatar',
        useCases: [
          avatar28UseCase,
          avatar40UseCase,
          avatar48UseCase,
          avatar64UseCase,
          avatar96UseCase,
          avatar112UseCase,
          avatar128UseCase,
          avatarContentUseCase,
        ],
      ),
    ],
  ),
  WidgetbookFolder(
    name: 'Widgets',
    children: [
      WidgetbookComponent(
        name: 'Roster row',
        useCases: [
          defaultRosterUseCase,
          revealedRosterUseCase,
          focusRosterUseCase,
          disabledRosterUseCase,
          longRosterUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Identity',
        useCases: [
          inlineIdentityUseCase,
          stackedIdentityUseCase,
          participantIdentityUseCase,
          longIdentityUseCase,
        ],
      ),
    ],
  ),
];
