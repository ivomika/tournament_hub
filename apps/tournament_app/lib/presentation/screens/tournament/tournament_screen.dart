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
    final t = TournamentScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final pair = Row(
      crossAxisAlignment: t.start,
      children: [
        Expanded(
          child: Column(
            mainAxisSize: t.min,
            children: [
              AppIdentity(
                primary: state.left.character,
                initials: state.left.initials,
                secondary: state.left.name,
                layout: AppIdentityLayout.stacked,
                theme: t.currentIdentity,
              ),
              if (state.leftPoints != null) ...[
                SizedBox(height: t.small),
                Text(state.leftPoints!, style: t.points),
              ],
            ],
          ),
        ),
        SizedBox(width: t.gap),
        Expanded(
          child: Column(
            mainAxisSize: t.min,
            children: [
              AppIdentity(
                primary: state.right.character,
                initials: state.right.initials,
                secondary: state.right.name,
                layout: AppIdentityLayout.stacked,
                theme: t.currentIdentity,
              ),
              if (state.rightPoints != null) ...[
                SizedBox(height: t.small),
                Text(state.rightPoints!, style: t.points),
              ],
            ],
          ),
        ),
      ],
    );
    final score = AppScore.pair(
      left: state.leftScore,
      right: state.rightScore,
      separator: l.scoreSeparator,
      semanticLabel: l.screenCurrentScore,
    );
    final next = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.stretch,
      children: [
        Text(l.screenNext, style: t.caption),
        SizedBox(height: t.small),
        if (t.desktop)
          for (final player in state.nextPlayers) ...[
            AppIdentity(
              primary: player.character,
              initials: player.initials,
              secondary: player.name,
              theme: t.nextIdentity,
            ),
            SizedBox(height: t.small),
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
                    theme: t.nextIdentity,
                  ),
                ),
            ],
          ),
      ],
    );
    final details = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.stretch,
      children: [
        if (state.nextPlayers.isNotEmpty) ...[
          if (t.desktop) AppScreenTile(child: next) else next,
          SizedBox(height: t.gap),
        ],
        if (state.hasBracket) ...[
          AppScreenTile(
            child: AppButton(
              label: l.screenBracket,
              kind: AppButtonKind.textLink,
              glyph: AppGlyph.chevron,
              onPressed: onBracket,
            ),
          ),
          SizedBox(height: t.gap),
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
                  style: t.caption,
                ),
                TournamentTableContent(
                  :final caption,
                  :final columns,
                  :final rows,
                ) =>
                  AppDataTable(caption: caption, columns: columns, rows: rows),
                TournamentActionsContent(:final actions) => Column(
                  mainAxisSize: t.min,
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
          SizedBox(height: t.gap),
        ],
      ],
    );
    final action = AppButton(
      label: l.screenEnterResult,
      glyph: AppGlyph.arrow,
      onPressed: onResult,
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: state.title,
            backLabel: l.screenBack,
            onBack: onBack,
            action: AppHeaderAction(
              kind: AppHeaderActionKind.share,
              label: l.screenSpectators,
              onPressed: onShare,
            ),
          ),
          SizedBox(height: t.gap),
          Expanded(
            child: t.desktop
                ? Row(
                    crossAxisAlignment: t.stretch,
                    children: [
                      Expanded(
                        flex: t.homePrimaryFlex,
                        child: AppScreenTile(
                          child: Column(
                            crossAxisAlignment: t.stretch,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: t.centerMain,
                                  children: [
                                    Text(
                                      state.roundLabel,
                                      style: t.caption,
                                      textAlign: t.centerText,
                                    ),
                                    SizedBox(height: t.gap),
                                    pair,
                                    SizedBox(height: t.gap),
                                    score,
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: t.gap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: t.stretch,
                          children: [
                            Expanded(
                              child: SingleChildScrollView(child: details),
                            ),
                            SizedBox(height: t.gap),
                            action,
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: t.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: t.stretch,
                            children: [
                              Text(
                                state.roundLabel,
                                style: t.caption,
                                textAlign: t.centerText,
                              ),
                              SizedBox(height: t.gap),
                              pair,
                              SizedBox(height: t.gap),
                              score,
                              SizedBox(height: t.gap),
                              details,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: t.gap),
                      action,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
