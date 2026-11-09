import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/champion/champion_screen_state.dart';
import 'package:tournament_app/presentation/screens/champion/champion_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';

class ChampionScreen extends StatelessWidget {
  const ChampionScreen({
    required this.state,
    required this.onBack,
    required this.onShare,
    required this.onResults,
    super.key,
  });
  final ChampionScreenState state;
  final VoidCallback? onBack, onShare, onResults;
  @override
  Widget build(BuildContext context) {
    final t = ChampionScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final award = Row(
      mainAxisSize: t.min,
      mainAxisAlignment: t.centerMain,
      children: [
        AppIcon(AppGlyph.trophy, color: t.accentHero.color),
        SizedBox(width: t.small),
        Text(l.screenChampion, style: t.award),
      ],
    );
    final hero = Column(
      mainAxisSize: t.min,
      mainAxisAlignment: t.centerMain,
      crossAxisAlignment: t.centerCross,
      children: [
        award,
        SizedBox(height: t.heroGap),
        AppIdentity(
          primary: state.winner.character,
          initials: state.winner.initials,
          secondary: state.winner.name,
          layout: AppIdentityLayout.stacked,
          theme: t.championIdentity,
        ),
      ],
    );
    final action = AppButton(
      label: l.screenTournamentResults,
      glyph: AppGlyph.arrow,
      onPressed: onResults,
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenFinished,
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
                ? SingleChildScrollView(
                    child: SizedBox(
                      height: t.championHeight,
                      child: Row(
                        crossAxisAlignment: t.stretch,
                        children: [
                          Expanded(
                            flex: t.homePrimaryFlex,
                            child: AppScreenTile(
                              raised: true,
                              child: Center(child: hero),
                            ),
                          ),
                          SizedBox(width: t.gap),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: t.stretch,
                              children: [
                                Expanded(
                                  flex: t.homePrimaryFlex,
                                  child: AppScreenTile(
                                    child: Align(
                                      alignment: t.contextAlignment,
                                      child: Text(state.title, style: t.contextTitle),
                                    ),
                                  ),
                                ),
                                SizedBox(height: t.gap),
                                Expanded(
                                  child: Align(
                                    alignment: t.bottomAlign,
                                    child: action,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Column(
                    crossAxisAlignment: t.stretch,
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: t.min,
                              children: [
                                hero,
                                SizedBox(height: t.heroGap),
                                Text(state.title, style: t.caption),
                              ],
                            ),
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
