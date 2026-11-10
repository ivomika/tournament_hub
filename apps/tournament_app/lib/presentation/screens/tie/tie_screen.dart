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
    final appearance = TieScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final table = AppDataTable(
      caption: localizations.tableCaption,
      columns: state.columns,
      rows: state.rows,
    );
    final intro = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.stretch,
      children: [
        Text(localizations.screenMainFinished, style: appearance.caption),
        SizedBox(height: appearance.small),
        Text(localizations.screenReplayPlaces, style: appearance.heading),
        SizedBox(height: appearance.small),
        Text(state.note, style: appearance.caption),
      ],
    );
    final rules = AppDisclosure(
      title: localizations.screenReplayRules,
      expanded: state.rulesExpanded,
      onToggle: onToggleRules,
      child: Text(
        localizations.screenReplayRulesCopy,
        style: appearance.caption,
      ),
    );
    final action = AppButton(
      label: localizations.screenStartReplay,
      glyph: AppGlyph.arrow,
      onPressed: onStart,
    );
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenReplay,
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
                          child: SingleChildScrollView(child: table),
                        ),
                      ),
                      SizedBox(width: appearance.gap),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: appearance.stretch,
                          children: [
                            AppSurface(
                              tone: AppSurfaceTone.surface,
                              child: intro,
                            ),
                            SizedBox(height: appearance.gap),
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
                    crossAxisAlignment: appearance.stretch,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: appearance.stretch,
                            children: [
                              table,
                              SizedBox(height: appearance.gap),
                              intro,
                              SizedBox(height: appearance.gap),
                              rules,
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
