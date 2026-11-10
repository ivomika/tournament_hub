import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/setup/setup_screen_state.dart';
import 'package:tournament_app/presentation/screens/setup/setup_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/components/field/app_field.dart';
import 'package:tournament_app/presentation/design_system/components/segmented_choice/app_segmented_choice.dart';
import 'package:tournament_app/presentation/design_system/components/number_stepper/app_number_stepper.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({
    required this.state,
    required this.nameController,
    required this.onBack,
    required this.onNameChanged,
    required this.onFormatChanged,
    required this.onContinue,
    super.key,
  });
  final SetupScreenState state;
  final TextEditingController nameController;
  final VoidCallback? onBack, onContinue;
  final ValueChanged<String>? onNameChanged;
  final ValueChanged<TournamentFormatDisplay>? onFormatChanged;
  @override
  Widget build(BuildContext context) {
    final appearance = SetupScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final format = Column(
      mainAxisSize: appearance.desktop ? appearance.max : appearance.min,
      crossAxisAlignment: appearance.stretch,
      children: [
        Text(localizations.screenFormat, style: appearance.caption),
        SizedBox(height: appearance.small),
        AppSegmentedChoice<TournamentFormatDisplay>(
          nested: appearance.desktop,
          label: localizations.screenFormat,
          options: [
            AppSegment(
              value: TournamentFormatDisplay.doubleElimination,
              label: localizations.screenDe,
            ),
            AppSegment(
              value: TournamentFormatDisplay.singleElimination,
              label: localizations.screenSe,
            ),
            AppSegment(
              value: TournamentFormatDisplay.roundRobin,
              label: localizations.screenRr,
            ),
          ],
          value: state.format,
          onChanged: onFormatChanged,
        ),
        if (appearance.desktop)
          const Spacer()
        else
          SizedBox(height: appearance.layoutGap),
        Text(state.formatTitle, style: appearance.formatStyle),
        SizedBox(height: appearance.small),
        Text(state.formatHint, style: appearance.caption),
      ],
    );
    final controls = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.stretch,
      children: [
        for (final (index, control) in state.controls.indexed) ...[
          if (index > 0) SizedBox(height: appearance.layoutGap),
          if (appearance.desktop)
            AppScreenTile(
              padding: appearance.panePadding,
              child: AppNumberStepper.output(
                label: control.label,
                valueLabel: control.valueLabel,
                decreaseLabel: localizations.screenDecreaseFt,
                increaseLabel: localizations.screenIncreaseFt,
                onDecrease: control.onDecrease,
                onIncrease: control.onIncrease,
              ),
            )
          else
            AppNumberStepper.output(
              label: control.label,
              valueLabel: control.valueLabel,
              decreaseLabel: localizations.screenDecreaseFt,
              increaseLabel: localizations.screenIncreaseFt,
              onDecrease: control.onDecrease,
              onIncrease: control.onIncrease,
            ),
        ],
        if (state.notice != null) ...[
          SizedBox(height: appearance.layoutGap),
          AppNotice(text: state.notice!),
        ],
      ],
    );
    final action = AppButton(
      label: localizations.screenToRoster,
      glyph: AppGlyph.arrow,
      onPressed: onContinue,
    );
    final field = AppField(
      label: localizations.screenTournamentName,
      controller: nameController,
      onChanged: onNameChanged,
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenNewTournament,
            backLabel: localizations.screenBack,
            onBack: onBack,
          ),
          SizedBox(height: appearance.layoutGap),
          Expanded(
            child: appearance.desktop
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: appearance.stretch,
                      children: [
                        AppScreenTile(
                          padding: appearance.panePadding,
                          child: field,
                        ),
                        SizedBox(height: appearance.layoutGap),
                        SizedBox(
                          height: appearance.formatHeight,
                          child: Row(
                            crossAxisAlignment: appearance.stretch,
                            children: [
                              Expanded(
                                flex: appearance.widePaneFlex,
                                child: AppScreenTile(
                                  padding: appearance.panePadding,
                                  child: format,
                                ),
                              ),
                              SizedBox(width: appearance.layoutGap),
                              Expanded(
                                flex: appearance.narrowPaneFlex,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: appearance.stretch,
                                    children: [
                                      controls,
                                      SizedBox(height: appearance.layoutGap),
                                      action,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: appearance.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: appearance.stretch,
                            children: [
                              field,
                              SizedBox(height: appearance.layoutGap),
                              format,
                              SizedBox(height: appearance.layoutGap),
                              controls,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: appearance.layoutGap),
                      action,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
