import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/match_result/match_result_screen_state.dart';
import 'package:tournament_app/presentation/screens/match_result/match_result_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_modal_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/disclosure/app_disclosure.dart';
import 'package:tournament_app/presentation/design_system/components/score/app_score.dart';
import 'package:tournament_app/presentation/design_system/components/score_choice/app_score_choice.dart';
import 'package:tournament_app/presentation/design_system/components/number_stepper/app_number_stepper.dart';
import 'package:tournament_app/presentation/design_system/components/status_label/app_status_label.dart';
import 'package:tournament_app/presentation/design_system/components/notice/app_notice.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface_theme.dart';

class MatchResultScreen extends StatelessWidget {
  MatchResultScreen({
    required this.state,
    required this.onCancel,
    required this.onSave,
    required this.onWinnerChanged,
    required this.onDecrease,
    required this.onIncrease,
    required this.onScoreChanged,
    this.loserController,
    super.key,
  }) : assert(state.entry is! SteppedResultEntry || loserController != null);
  final MatchResultScreenState state;
  final TextEditingController? loserController;
  final VoidCallback? onCancel, onSave, onDecrease, onIncrease;
  final ValueChanged<MatchSide>? onWinnerChanged;
  final ValueChanged<String>? onScoreChanged;
  @override
  Widget build(BuildContext context) {
    final appearance = MatchResultScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final entry = state.entry, details = state.details;
    final pair = Row(
      crossAxisAlignment: appearance.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: appearance.min,
            children: [
              AppIdentity(
                primary: state.left.character,
                initials: state.left.initials,
                secondary: state.left.name,
                layout: AppIdentityLayout.stacked,
                theme: appearance.playerIdentity,
              ),
              if (entry case TechnicalResultEntry(
                :final leftOutcome,
                :final leftTone,
              )) ...[
                SizedBox(height: appearance.small),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: appearance.outcomeHeight,
                  ),
                  child: AppStatusLabel(
                    text: leftOutcome,
                    textAlign: appearance.centerText,
                    kind: AppStatusKind.outcome,
                    tone: leftTone,
                  ),
                ),
              ],
            ],
          ),
        ),
        SizedBox(width: appearance.gap),
        Expanded(
          child: Column(
            mainAxisSize: appearance.min,
            children: [
              AppIdentity(
                primary: state.right.character,
                initials: state.right.initials,
                secondary: state.right.name,
                layout: AppIdentityLayout.stacked,
                theme: appearance.playerIdentity,
              ),
              if (entry case TechnicalResultEntry(
                :final rightOutcome,
                :final rightTone,
              )) ...[
                SizedBox(height: appearance.small),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: appearance.outcomeHeight,
                  ),
                  child: AppStatusLabel(
                    text: rightOutcome,
                    textAlign: appearance.centerText,
                    kind: AppStatusKind.outcome,
                    tone: rightTone,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
    final input = loserController == null
        ? null
        : AppNumberStepper.input(
            label: state.inputLabel,
            showLabel: false,
            controller: loserController!,
            decreaseLabel: localizations.screenDecreaseScore,
            increaseLabel: localizations.screenIncreaseScore,
            onDecrease: onDecrease,
            onIncrease: onIncrease,
            onChanged: onScoreChanged,
          );
    final editor = switch (entry) {
      ChoiceResultEntry(:final value) => AppScoreChoice<MatchSide>(
        label: localizations.scoreChoiceLabel,
        options: [
          AppScoreOption(
            value: MatchSide.left,
            label: localizations.scoreChoiceLeft,
          ),
          AppScoreOption(
            value: MatchSide.right,
            label: localizations.scoreChoiceRight,
          ),
        ],
        value: value,
        onChanged: onWinnerChanged,
      ),
      SteppedResultEntry(:final fixedScore, :final fixedSide) => Row(
        children: [
          Expanded(
            child: fixedSide == MatchSide.left
                ? AppScore.fixed(
                    left: fixedScore,
                    semanticLabel: localizations.scoreFixedLabel(fixedScore),
                  )
                : input!,
          ),
          SizedBox(width: appearance.gap),
          Expanded(
            child: fixedSide == MatchSide.right
                ? AppScore.fixed(
                    left: fixedScore,
                    semanticLabel: localizations.scoreFixedLabel(fixedScore),
                  )
                : input!,
          ),
        ],
      ),
      TechnicalResultEntry() => const SizedBox.shrink(),
    };
    return AppModalCanvas(
      theme: appearance,
      sheet: true,
      underlay: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: state.tournamentTitle,
            backLabel: localizations.screenBack,
            onBack: onCancel,
          ),
        ],
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: appearance.desktop
              ? appearance.zero
              : appearance.modalMobileMinHeight,
        ),
        child: AppSurface(
          theme: appearance.sheetSurface,
          child: Column(
            mainAxisSize: appearance.min,
            crossAxisAlignment: appearance.stretch,
            children: [
              AppSectionHeader(
                title: state.title,
                backLabel: state.cancelLabel,
                onBack: onCancel,
                leadingGlyph: AppGlyph.close,
                action: AppHeaderAction(
                  kind: AppHeaderActionKind.save,
                  label: state.saveLabel,
                  onPressed: onSave,
                ),
              ),
              SizedBox(height: appearance.gap),
              if (entry is TechnicalResultEntry) ...[
                Text(
                  localizations.screenTechnicalResult,
                  style: appearance.caption,
                ),
                SizedBox(height: appearance.gap),
              ],
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: appearance.resultContentWidth,
                  ),
                  child: appearance.desktop
                      ? AppSurface(
                          tone: AppSurfaceTone.raised,
                          shape: AppSurfaceShape.nested,
                          child: pair,
                        )
                      : pair,
                ),
              ),
              SizedBox(height: appearance.gap),
              if (entry case TechnicalResultEntry(:final note))
                Text(note, style: appearance.caption)
              else
                Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: appearance.resultContentWidth,
                    ),
                    child: editor,
                  ),
                ),
              if (state.errorText != null) ...[
                SizedBox(height: appearance.gap),
                AppNotice(
                  text: state.errorText!,
                  kind: AppNoticeKind.inlineError,
                ),
              ],
              if (details != null) ...[
                SizedBox(height: appearance.gap),
                AppDisclosure(
                  title: details.title,
                  expanded: details.expanded,
                  onToggle: details.onToggle,
                  child: switch (details) {
                    ResultExplanationDetails(:final text) => Text(
                      text,
                      style: appearance.caption,
                    ),
                    ResultActionsDetails(
                      :final onTechnical,
                      :final onWithdraw,
                    ) =>
                      Column(
                        mainAxisSize: appearance.min,
                        children: [
                          AppButton(
                            label: localizations.screenTechnicalAction,
                            kind: AppButtonKind.textLink,
                            glyph: AppGlyph.chevron,
                            onPressed: onTechnical,
                          ),
                          AppButton(
                            label: localizations.screenWithdrawAction,
                            kind: AppButtonKind.textLink,
                            glyph: AppGlyph.chevron,
                            onPressed: onWithdraw,
                          ),
                        ],
                      ),
                  },
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
