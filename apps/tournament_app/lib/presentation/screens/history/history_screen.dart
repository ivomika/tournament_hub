import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/history/history_screen_state.dart';
import 'package:tournament_app/presentation/screens/history/history_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_centered_screen.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/history_entry/app_history_entry.dart';
import 'package:tournament_app/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({
    required this.state,
    required this.onBack,
    required this.onCreate,
    super.key,
  });
  final HistoryScreenState state;
  final VoidCallback? onBack, onCreate;
  @override
  Widget build(BuildContext context) {
    final t = HistoryScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final featured = state.featured;
    final header = AppSectionHeader(
      title: l.screenHistory,
      backLabel: l.screenBack,
      onBack: onBack,
    );
    if (featured == null && state.entries.isEmpty) {
      return AppCenteredScreen(
        header: header,
        footer: AppButton(
          label: l.screenCreate,
          glyph: AppGlyph.arrow,
          onPressed: onCreate,
        ),
        child: Column(
          mainAxisSize: t.min,
          crossAxisAlignment: t.start,
          mainAxisAlignment: t.centerMain,
          children: [
            Text(l.screenHistoryEmpty, style: t.heading),
            SizedBox(height: t.gap),
            Text(l.screenHistoryEmptyNote, style: t.muted),
          ],
        ),
      );
    }
    final intro = Text(l.screenYourTournaments, style: t.heading);
    final first = featured == null
        ? null
        : AppHistoryEntry(
            name: featured.name,
            dateLabel: featured.dateLabel,
            winnerCharacter: featured.winnerCharacter,
            winnerName: featured.winnerName,
            initials: featured.initials,
            onOpen: featured.onOpen,
            prominent: true,
          );
    final rest = AppAdaptiveGrid(
      columns: t.desktop ? t.gridColumns : t.stackColumns,
      children: [
        for (final entry in state.entries)
          AppHistoryEntry(
            name: entry.name,
            dateLabel: entry.dateLabel,
            winnerCharacter: entry.winnerCharacter,
            winnerName: entry.winnerName,
            initials: entry.initials,
            onOpen: entry.onOpen,
          ),
      ],
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          header,
          SizedBox(height: t.gap),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: t.stretch,
                children: [
                  if (t.desktop)
                    Row(
                      crossAxisAlignment: t.start,
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: t.historyFeatureHeight,
                            ),
                            child: AppScreenTile(
                              child: Column(
                                mainAxisAlignment: t.centerMain,
                                crossAxisAlignment: t.start,
                                children: [intro],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: t.gap),
                        Expanded(
                          flex: t.homePrimaryFlex,
                          child: Column(
                            crossAxisAlignment: t.stretch,
                            children: [
                              Text(state.periodLabel, style: t.caption),
                              SizedBox(height: t.gap),
                              ?first,
                            ],
                          ),
                        ),
                      ],
                    )
                  else ...[
                    intro,
                    SizedBox(height: t.gap),
                    Text(state.periodLabel, style: t.caption),
                    ?first,
                  ],
                  SizedBox(height: t.gap),
                  rest,
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
