import 'package:tournament_app/presentation/widgetbook/widgets/adaptive_grid/default/default_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/history_entry/default/default_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/stage_progress/current/current_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/screens/screen_catalog.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/short_link/short_link_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/long_link/long_link_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/unicode_link/unicode_link_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/share_link/short/short_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/share_link/long/long_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/share_link/disabled/disabled_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/access/access_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/qr_code/graphic/graphic_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/dialog/default/default_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/dialog/disabled/disabled_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/dialog/overlay/overlay_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/bracket_node/ready/ready_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/bracket_node/current/current_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/bracket_node/pending/pending_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/data_table/standings/standings_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/progress_indicator/animated/animated_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/progress_indicator/reduced/reduced_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/progress_indicator/fixed_phase/fixed_phase_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/notice/information/information_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/notice/operation_error/operation_error_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/notice/inline_error/inline_error_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/disclosure/closed/closed_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/disclosure/open/open_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/disclosure/disabled/disabled_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/status_label/live/live_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/status_label/win/win_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/status_label/loss/loss_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/status_label/points/points_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/section_header/back/back_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/section_header/save/save_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/section_header/edit/edit_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/widgets/section_header/long/long_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/navigation_item/default/default_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/navigation_item/hovered/hovered_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/navigation_item/focused/focused_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/navigation_item/disabled/disabled_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/metric/achievement/achievement_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/metric/plain/plain_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/score_choice/left/left_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/score_choice/right/right_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/score_choice/disabled/disabled_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/score/pair/pair_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/score/fixed/fixed_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/score/two_digits/two_digits_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/number_stepper/format/format_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/number_stepper/score/score_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/segmented_choice/selected/selected_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/segmented_choice/focused/focused_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/segmented_choice/disabled/disabled_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/closed/closed_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/focused/focused_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/disabled/disabled_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/select/sheet/sheet_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/field/single_line/single_line_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/components/field/multiline/multiline_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/responsive/consumers/consumers_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/responsive/text_scale/text_scale_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/motion/normal/normal_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/motion/reduced/reduced_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/motion/progress/progress_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/elevation/shadows/shadows_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/elevation/scrim/scrim_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/borders/catalog/catalog_use_case.dart';
import 'package:tournament_app/presentation/widgetbook/foundation/borders/focus/focus_use_case.dart';
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
  WidgetbookFolder(name: 'Screens', children: screenCatalog),
  WidgetbookFolder(
    name: 'Foundation',
    isInitiallyExpanded: true,
    children: [
      WidgetbookComponent(
        name: 'Responsive',
        useCases: [responsiveConsumersUseCase, responsiveTextScaleUseCase],
      ),
      WidgetbookComponent(
        name: 'Motion',
        useCases: [
          motionNormalUseCase,
          motionReducedUseCase,
          motionProgressUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Elevation',
        useCases: [elevationShadowsUseCase, elevationScrimUseCase],
      ),
      WidgetbookComponent(
        name: 'Borders',
        useCases: [bordersCatalogUseCase, borderFocusUseCase],
      ),
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
        name: 'Stage progress',
        useCases: [stageProgressCurrentUseCase],
      ),
      WidgetbookComponent(
        name: 'QR code',
        useCases: [
          qrAccessUseCase,
          qrGraphicUseCase,
          qrShortLinkUseCase,
          qrLongLinkUseCase,
          qrUnicodeLinkUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Progress indicator',
        useCases: [
          progressAnimatedUseCase,
          progressReducedUseCase,
          progressFixedPhaseUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Notice',
        useCases: [
          noticeInformationUseCase,
          noticeOperationErrorUseCase,
          noticeInlineErrorUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Status label',
        useCases: [
          statusLiveUseCase,
          statusWinUseCase,
          statusLossUseCase,
          statusPointsUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Navigation item',
        useCases: [
          navigationDefaultUseCase,
          navigationHoveredUseCase,
          navigationFocusedUseCase,
          navigationDisabledUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Metric',
        useCases: [metricAchievementUseCase, metricPlainUseCase],
      ),
      WidgetbookComponent(
        name: 'Score choice',
        useCases: [
          scoreChoiceLeftUseCase,
          scoreChoiceRightUseCase,
          scoreChoiceDisabledUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Score',
        useCases: [scorePairUseCase, scoreFixedUseCase, scoreTwoDigitsUseCase],
      ),
      WidgetbookComponent(
        name: 'Number stepper',
        useCases: [stepperFormatUseCase, stepperScoreUseCase],
      ),
      WidgetbookComponent(
        name: 'Segmented choice',
        useCases: [
          segmentedSelectedUseCase,
          segmentedFocusedUseCase,
          segmentedDisabledUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Select',
        useCases: [
          selectClosedUseCase,
          selectFocusedUseCase,
          selectDisabledUseCase,
          selectSheetUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Field',
        useCases: [fieldSingleLineUseCase, fieldMultilineUseCase],
      ),
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
        name: 'History entry',
        useCases: [historyEntryDefaultUseCase],
      ),
      WidgetbookComponent(
        name: 'Adaptive grid',
        useCases: [adaptiveGridDefaultUseCase],
      ),
      WidgetbookComponent(
        name: 'Section header',
        useCases: [
          headerBackUseCase,
          headerSaveUseCase,
          headerEditUseCase,
          headerLongUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Disclosure',
        useCases: [
          disclosureClosedUseCase,
          disclosureOpenUseCase,
          disclosureDisabledUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Data table',
        useCases: [tableStandingsUseCase],
      ),
      WidgetbookComponent(
        name: 'Bracket node',
        useCases: [
          bracketReadyUseCase,
          bracketCurrentUseCase,
          bracketPendingUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Dialog',
        useCases: [
          dialogDefaultUseCase,
          dialogDisabledUseCase,
          dialogOverlayUseCase,
        ],
      ),
      WidgetbookComponent(
        name: 'Share link',
        useCases: [shareShortUseCase, shareLongUseCase, shareDisabledUseCase],
      ),
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
