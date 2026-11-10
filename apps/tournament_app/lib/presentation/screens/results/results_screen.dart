import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/results/results_screen_state.dart';
import 'package:tournament_app/presentation/screens/results/results_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/disclosure/app_disclosure.dart';
import 'package:tournament_app/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid.dart';
import 'package:tournament_app/presentation/design_system/widgets/ranking_row/app_ranking_row.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({
    required this.state,
    required this.onBack,
    required this.onShare,
    required this.onBracket,
    required this.onHome,
    super.key,
  });
  final ResultsScreenState state;
  final VoidCallback? onBack, onShare, onBracket, onHome;
  @override
  Widget build(BuildContext context) {
    final appearance = ResultsScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final featured = state.featured, explanation = state.explanation;
    final ranking = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.stretch,
      children: [
        AppRankingRow(
          featured: true,
          value: featured.value,
          primary: featured.player.character,
          secondary: featured.player.name,
          initials: featured.player.initials,
          placement: state.valuePlacement,
        ),
        for (final group in state.groups) ...[
          SizedBox(height: appearance.gap),
          AppAdaptiveGrid(
            columns:
                appearance.desktop && group.layout == RankingGroupLayout.paired
                ? appearance.gridColumns
                : appearance.stackColumns,
            children: [
              for (final entry in group.entries)
                AppRankingRow(
                  value: entry.value,
                  primary: entry.player.character,
                  secondary: entry.player.name,
                  initials: entry.player.initials,
                  placement: state.valuePlacement,
                ),
            ],
          ),
        ],
      ],
    );
    final contextCard = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.stretch,
      children: [
        Text(state.title, style: appearance.contextTitle),
        SizedBox(height: appearance.small),
        Text(state.meta, style: appearance.caption),
      ],
    );
    final links = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.stretch,
      children: [
        if (state.hasBracket)
          AppScreenTile(
            padding: appearance.linkPadding,
            child: AppButton(
              label: localizations.screenViewBracket,
              kind: AppButtonKind.textLink,
              glyph: AppGlyph.chevron,
              onPressed: onBracket,
            ),
          ),
        if (explanation != null)
          AppScreenTile(
            child: AppDisclosure(
              title: explanation.title,
              expanded: explanation.expanded,
              onToggle: explanation.onToggle,
              child: Text(explanation.text, style: appearance.caption),
            ),
          ),
      ],
    );
    final home = AppButton(
      label: localizations.screenHome,
      glyph: AppGlyph.arrow,
      onPressed: onHome,
    );
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenResults,
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
                        child: SingleChildScrollView(child: ranking),
                      ),
                      SizedBox(width: appearance.gap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: appearance.stretch,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: appearance.rankFeaturedHeight,
                              ),
                              child: AppScreenTile(child: contextCard),
                            ),
                            SizedBox(height: appearance.gap),
                            links,
                            const Spacer(),
                            home,
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
                              contextCard,
                              SizedBox(height: appearance.gap),
                              ranking,
                              SizedBox(height: appearance.gap),
                              links,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: appearance.gap),
                      home,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
