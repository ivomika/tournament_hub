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
    final t = SetupScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final format = Column(
      mainAxisSize: t.desktop ? t.max : t.min,
      crossAxisAlignment: t.stretch,
      children: [
        Text(l.screenFormat, style: t.caption),
        SizedBox(height: t.small),
        AppSegmentedChoice<TournamentFormatDisplay>(
          label: l.screenFormat,
          options: [
            AppSegment(
              value: TournamentFormatDisplay.doubleElimination,
              label: l.screenDe,
            ),
            AppSegment(
              value: TournamentFormatDisplay.singleElimination,
              label: l.screenSe,
            ),
            AppSegment(
              value: TournamentFormatDisplay.roundRobin,
              label: l.screenRr,
            ),
          ],
          value: state.format,
          onChanged: onFormatChanged,
        ),
        if (t.desktop) const Spacer() else SizedBox(height: t.layoutGap),
        Text(state.formatTitle, style: t.formatStyle),
        SizedBox(height: t.small),
        Text(state.formatHint, style: t.caption),
      ],
    );
    final controls = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.stretch,
      children: [
        for (final (index, control) in state.controls.indexed) ...[
          if (index > 0) SizedBox(height: t.layoutGap),
          if (t.desktop)
            AppScreenTile(
              padding: t.panePadding,
              child: AppNumberStepper.output(
                label: control.label,
                valueLabel: control.valueLabel,
                decreaseLabel: l.screenDecreaseFt,
                increaseLabel: l.screenIncreaseFt,
                onDecrease: control.onDecrease,
                onIncrease: control.onIncrease,
              ),
            )
          else
            AppNumberStepper.output(
              label: control.label,
              valueLabel: control.valueLabel,
              decreaseLabel: l.screenDecreaseFt,
              increaseLabel: l.screenIncreaseFt,
              onDecrease: control.onDecrease,
              onIncrease: control.onIncrease,
            ),
        ],
        if (state.notice != null) ...[
          SizedBox(height: t.layoutGap),
          AppNotice(text: state.notice!),
        ],
      ],
    );
    final action = AppButton(
      label: l.screenToRoster,
      glyph: AppGlyph.arrow,
      onPressed: onContinue,
    );
    final field = AppField(
      label: l.screenTournamentName,
      controller: nameController,
      onChanged: onNameChanged,
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenNewTournament,
            backLabel: l.screenBack,
            onBack: onBack,
          ),
          SizedBox(height: t.layoutGap),
          Expanded(
            child: t.desktop
                ? SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: t.stretch,
                      children: [
                        AppScreenTile(padding: t.panePadding, child: field),
                        SizedBox(height: t.layoutGap),
                        SizedBox(
                          height: t.utilityHeight,
                          child: Row(
                            crossAxisAlignment: t.stretch,
                            children: [
                              Expanded(
                                flex: t.widePaneFlex,
                                child: AppScreenTile(
                                  padding: t.panePadding,
                                  child: format,
                                ),
                              ),
                              SizedBox(width: t.layoutGap),
                              Expanded(
                                flex: t.narrowPaneFlex,
                                child: Column(
                                  crossAxisAlignment: t.stretch,
                                  children: [
                                    controls,
                                    SizedBox(height: t.layoutGap),
                                    action,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    crossAxisAlignment: t.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: t.stretch,
                            children: [
                              field,
                              SizedBox(height: t.layoutGap),
                              format,
                              SizedBox(height: t.layoutGap),
                              controls,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: t.layoutGap),
                      action,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
