import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/tie/tie_screen_state.dart';
import 'package:tournament_app/presentation/screens/tie/tie_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/disclosure/app_disclosure.dart';
import 'package:tournament_app/presentation/design_system/widgets/data_table/app_data_table.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface_theme.dart';

class TieScreen extends StatelessWidget {
  const TieScreen({
    required this.state,
    required this.onBack,
    required this.onShare,
    required this.onToggleRules,
    required this.onStart,
    super.key,
  });
  final TieScreenState state;
  final VoidCallback? onBack, onShare, onToggleRules, onStart;
  @override
  Widget build(BuildContext context) {
    final t = TieScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final table = AppDataTable(
      caption: l.tableCaption,
      columns: state.columns,
      rows: state.rows,
    );
    final intro = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.stretch,
      children: [
        Text(l.screenMainFinished, style: t.caption),
        SizedBox(height: t.small),
        Text(l.screenReplayPlaces, style: t.heading),
        SizedBox(height: t.small),
        Text(state.note, style: t.caption),
      ],
    );
    final rules = AppDisclosure(
      title: l.screenReplayRules,
      expanded: state.rulesExpanded,
      onToggle: onToggleRules,
      child: Text(l.screenReplayRulesCopy, style: t.caption),
    );
    final action = AppButton(
      label: l.screenStartReplay,
      glyph: AppGlyph.arrow,
      onPressed: onStart,
    );
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenReplay,
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
                          child: SingleChildScrollView(child: table),
                        ),
                      ),
                      SizedBox(width: t.gap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: t.stretch,
                          children: [
                            AppSurface(
                              tone: AppSurfaceTone.surface,
                              child: intro,
                            ),
                            SizedBox(height: t.gap),
                            AppSurface(
                              tone: AppSurfaceTone.surface,
                              child: rules,
                            ),
                            const Spacer(),
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
                              table,
                              SizedBox(height: t.gap),
                              intro,
                              SizedBox(height: t.gap),
                              rules,
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
