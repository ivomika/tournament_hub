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
    final t = ResultsScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final featured = state.featured, explanation = state.explanation;
    final ranking = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.stretch,
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
          SizedBox(height: t.gap),
          AppAdaptiveGrid(
            columns: t.desktop && group.layout == RankingGroupLayout.paired
                ? t.gridColumns
                : t.stackColumns,
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
      mainAxisSize: t.min,
      crossAxisAlignment: t.stretch,
      children: [
        Text(state.title, style: t.contextTitle),
        SizedBox(height: t.small),
        Text(state.meta, style: t.caption),
      ],
    );
    final links = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.stretch,
      children: [
        if (state.hasBracket)
          AppScreenTile(
            padding: t.linkPadding,
            child: AppButton(
              label: l.screenViewBracket,
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
              child: Text(explanation.text, style: t.caption),
            ),
          ),
      ],
    );
    final home = AppButton(
      label: l.screenHome,
      glyph: AppGlyph.arrow,
      onPressed: onHome,
    );
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenResults,
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
                        child: SingleChildScrollView(child: ranking),
                      ),
                      SizedBox(width: t.gap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: t.stretch,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: t.rankFeaturedHeight,
                              ),
                              child: AppScreenTile(child: contextCard),
                            ),
                            SizedBox(height: t.gap),
                            links,
                            const Spacer(),
                            home,
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
                              contextCard,
                              SizedBox(height: t.gap),
                              ranking,
                              SizedBox(height: t.gap),
                              links,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: t.gap),
                      home,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
