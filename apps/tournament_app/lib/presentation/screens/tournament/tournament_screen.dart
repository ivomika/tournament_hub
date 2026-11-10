import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/tournament/tournament_screen_state.dart';
import 'package:tournament_app/presentation/screens/tournament/tournament_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/disclosure/app_disclosure.dart';
import 'package:tournament_app/presentation/design_system/widgets/data_table/app_data_table.dart';
import 'package:tournament_app/presentation/design_system/components/score/app_score.dart';

class TournamentScreen extends StatelessWidget {
  const TournamentScreen({
    required this.state,
    required this.onBack,
    required this.onShare,
    required this.onBracket,
    required this.onResult,
    super.key,
  });
  final TournamentScreenState state;
  final VoidCallback? onBack, onShare, onBracket, onResult;
  @override
  Widget build(BuildContext context) {
    final appearance = TournamentScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
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
                theme: appearance.currentIdentity,
              ),
              if (state.leftPoints != null) ...[
                SizedBox(height: appearance.small),
                Text(state.leftPoints!, style: appearance.points),
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
                theme: appearance.currentIdentity,
              ),
              if (state.rightPoints != null) ...[
                SizedBox(height: appearance.small),
                Text(state.rightPoints!, style: appearance.points),
              ],
            ],
          ),
        ),
      ],
    );
    final score = AppScore.pair(
      left: state.leftScore,
      right: state.rightScore,
      separator: localizations.scoreSeparator,
      semanticLabel: localizations.screenCurrentScore,
    );
    final next = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.stretch,
      children: [
        Text(localizations.screenNext, style: appearance.caption),
        SizedBox(height: appearance.small),
        if (appearance.desktop)
          for (final player in state.nextPlayers) ...[
            AppIdentity(
              primary: player.character,
              initials: player.initials,
              secondary: player.name,
              theme: appearance.nextIdentity,
            ),
            SizedBox(height: appearance.small),
          ]
        else
          Row(
            children: [
              for (final player in state.nextPlayers)
                Expanded(
                  child: AppIdentity(
                    primary: player.character,
                    initials: player.initials,
                    secondary: player.name,
                    theme: appearance.nextIdentity,
                  ),
                ),
            ],
          ),
      ],
    );
    final details = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.stretch,
      children: [
        if (state.nextPlayers.isNotEmpty) ...[
          if (appearance.desktop) AppScreenTile(child: next) else next,
          SizedBox(height: appearance.gap),
        ],
        if (state.hasBracket) ...[
          AppScreenTile(
            child: AppButton(
              label: localizations.screenBracket,
              kind: AppButtonKind.textLink,
              glyph: AppGlyph.chevron,
              onPressed: onBracket,
            ),
          ),
          SizedBox(height: appearance.gap),
        ],
        for (final detail in state.details) ...[
          AppScreenTile(
            child: AppDisclosure(
              title: detail.title,
              expanded: detail.expanded,
              onToggle: detail.onToggle,
              child: switch (detail.content) {
                TournamentTextContent(:final text) => Text(
                  text,
                  style: appearance.caption,
                ),
                TournamentTableContent(
                  :final caption,
                  :final columns,
                  :final rows,
                ) =>
                  AppDataTable(caption: caption, columns: columns, rows: rows),
                TournamentActionsContent(:final actions) => Column(
                  mainAxisSize: appearance.min,
                  children: [
                    for (final action in actions)
                      AppButton(
                        label: action.label,
                        kind: AppButtonKind.textLink,
                        glyph: AppGlyph.chevron,
                        onPressed: action.onPressed,
                      ),
                  ],
                ),
              },
            ),
          ),
          SizedBox(height: appearance.gap),
        ],
      ],
    );
    final action = AppButton(
      label: localizations.screenEnterResult,
      glyph: AppGlyph.arrow,
      onPressed: onResult,
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: state.title,
            backLabel: localizations.screenBack,
            onBack: onBack,
            action: AppHeaderAction(
              kind: AppHeaderActionKind.share,
              label: localizations.screenSpectators,
              onPressed: onShare,
            ),
          ),
          SizedBox(height: appearance.gap),
          Expanded(
            child: appearance.desktop
                ? Row(
                    crossAxisAlignment: appearance.stretch,
                    children: [
                      Expanded(
                        flex: appearance.homePrimaryFlex,
                        child: AppScreenTile(
                          child: Center(
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: appearance.min,
                                mainAxisAlignment: appearance.centerMain,
                                children: [
                                  Text(
                                    state.roundLabel,
                                    style: appearance.caption,
                                    textAlign: appearance.centerText,
                                  ),
                                  SizedBox(height: appearance.gap),
                                  pair,
                                  SizedBox(height: appearance.gap),
                                  score,
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: appearance.gap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: appearance.stretch,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(child: details),
                            ),
                            SizedBox(height: appearance.gap),
                            action,
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: appearance.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: appearance.stretch,
                            children: [
                              Text(
                                state.roundLabel,
                                style: appearance.caption,
                                textAlign: appearance.centerText,
                              ),
                              SizedBox(height: appearance.gap),
                              pair,
                              SizedBox(height: appearance.gap),
                              score,
                              SizedBox(height: appearance.gap),
                              details,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: appearance.gap),
                      action,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
