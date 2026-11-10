import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/roster/roster_screen_state.dart';
import 'package:tournament_app/presentation/screens/roster/roster_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/roster_row/app_roster_row.dart';
import 'package:tournament_app/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid.dart';

class RosterScreen extends StatelessWidget {
  const RosterScreen({
    required this.state,
    required this.onBack,
    required this.onAdd,
    required this.onConnect,
    required this.onDeal,
    super.key,
  });
  final RosterScreenState state;
  final VoidCallback? onBack, onAdd, onConnect, onDeal;
  @override
  Widget build(BuildContext context) {
    final appearance = RosterScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final list = AppAdaptiveGrid(
      columns: appearance.desktop
          ? appearance.gridColumns
          : appearance.stackColumns,
      children: [
        for (final guest in state.guests)
          AppRosterRow(
            name: guest.name,
            initials: guest.initials,
            onRemove: guest.onRemove,
          ),
      ],
    );
    final contextCard = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.start,
      children: [
        Text(localizations.screenWhoPlays, style: appearance.heading),
        SizedBox(height: appearance.gap),
        Text(state.contextLabel, style: appearance.muted),
        SizedBox(height: appearance.gap),
        Text(localizations.screenNoCharacters, style: appearance.caption),
      ],
    );
    final actions = Row(
      children: [
        AppButton(
          label: localizations.screenConnectParticipants,
          kind: AppButtonKind.icon,
          glyph: AppGlyph.qr,
          onPressed: onConnect,
        ),
        SizedBox(width: appearance.small),
        Expanded(
          child: AppButton(
            label: localizations.screenDeal,
            glyph: AppGlyph.arrow,
            onPressed: onDeal,
          ),
        ),
      ],
    );
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenParticipants,
            backLabel: localizations.screenBack,
            onBack: onBack,
            action: AppHeaderAction(
              kind: AppHeaderActionKind.add,
              label: localizations.screenAddGuest,
              onPressed: onAdd,
            ),
          ),
          SizedBox(height: appearance.gap),
          Expanded(
            child: appearance.desktop
                ? Row(
                    crossAxisAlignment: appearance.start,
                    children: [
                      Expanded(
                        flex: appearance.homePrimaryFlex,
                        child: SingleChildScrollView(child: list),
                      ),
                      SizedBox(width: appearance.gap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: appearance.stretch,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: appearance.rosterContextHeight,
                              ),
                              child: AppScreenTile(child: contextCard),
                            ),
                            SizedBox(height: appearance.gap),
                            actions,
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: appearance.stretch,
                    children: [
                      Expanded(child: SingleChildScrollView(child: list)),
                      SizedBox(height: appearance.gap),
                      actions,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
