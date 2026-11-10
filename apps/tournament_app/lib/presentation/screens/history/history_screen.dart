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
    final appearance = HistoryScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final featured = state.featured;
    final header = AppSectionHeader(
      title: localizations.screenHistory,
      backLabel: localizations.screenBack,
      onBack: onBack,
    );
    if (featured == null && state.entries.isEmpty) {
      return AppCenteredScreen(
        header: header,
        footer: AppButton(
          label: localizations.screenCreate,
          glyph: AppGlyph.arrow,
          onPressed: onCreate,
        ),
        child: Column(
          mainAxisSize: appearance.min,
          crossAxisAlignment: appearance.start,
          mainAxisAlignment: appearance.centerMain,
          children: [
            Text(localizations.screenHistoryEmpty, style: appearance.heading),
            SizedBox(height: appearance.gap),
            Text(localizations.screenHistoryEmptyNote, style: appearance.muted),
          ],
        ),
      );
    }
    final intro = Text(
      localizations.screenYourTournaments,
      style: appearance.heading,
    );
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
      columns: appearance.desktop
          ? appearance.gridColumns
          : appearance.stackColumns,
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
        crossAxisAlignment: appearance.stretch,
        children: [
          header,
          SizedBox(height: appearance.gap),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: appearance.stretch,
                children: [
                  if (appearance.desktop)
                    Row(
                      crossAxisAlignment: appearance.start,
                      children: [
                        Expanded(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(
                              minHeight: appearance.historyFeatureHeight,
                            ),
                            child: AppScreenTile(
                              child: Column(
                                mainAxisAlignment: appearance.centerMain,
                                crossAxisAlignment: appearance.start,
                                children: [intro],
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: appearance.gap),
                        Expanded(
                          flex: appearance.homePrimaryFlex,
                          child: Column(
                            crossAxisAlignment: appearance.stretch,
                            children: [
                              Text(
                                state.periodLabel,
                                style: appearance.caption,
                              ),
                              SizedBox(height: appearance.gap),
                              ?first,
                            ],
                          ),
                        ),
                      ],
                    )
                  else ...[
                    intro,
                    SizedBox(height: appearance.gap),
                    Text(state.periodLabel, style: appearance.caption),
                    ?first,
                  ],
                  SizedBox(height: appearance.gap),
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
