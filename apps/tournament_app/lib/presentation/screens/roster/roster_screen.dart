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
    final t = RosterScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final list = AppAdaptiveGrid(
      columns: t.desktop ? t.gridColumns : t.stackColumns,
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
      mainAxisSize: t.min,
      crossAxisAlignment: t.start,
      children: [
        Text(l.screenWhoPlays, style: t.heading),
        SizedBox(height: t.gap),
        Text(state.contextLabel, style: t.muted),
        SizedBox(height: t.gap),
        Text(l.screenNoCharacters, style: t.caption),
      ],
    );
    final actions = Row(
      children: [
        AppButton(
          label: l.screenConnectParticipants,
          kind: AppButtonKind.icon,
          glyph: AppGlyph.qr,
          onPressed: onConnect,
        ),
        SizedBox(width: t.small),
        Expanded(
          child: AppButton(
            label: l.screenDeal,
            glyph: AppGlyph.arrow,
            onPressed: onDeal,
          ),
        ),
      ],
    );
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenParticipants,
            backLabel: l.screenBack,
            onBack: onBack,
            action: AppHeaderAction(
              kind: AppHeaderActionKind.add,
              label: l.screenAddGuest,
              onPressed: onAdd,
            ),
          ),
          SizedBox(height: t.gap),
          Expanded(
            child: t.desktop
                ? Row(
                    crossAxisAlignment: t.start,
                    children: [
                      Expanded(
                        flex: t.homePrimaryFlex,
                        child: SingleChildScrollView(child: list),
                      ),
                      SizedBox(width: t.gap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: t.stretch,
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                minHeight: t.rosterContextHeight,
                              ),
                              child: AppScreenTile(child: contextCard),
                            ),
                            SizedBox(height: t.gap),
                            actions,
                          ],
                        ),
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: t.stretch,
                    children: [
                      Expanded(child: SingleChildScrollView(child: list)),
                      SizedBox(height: t.gap),
                      actions,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
