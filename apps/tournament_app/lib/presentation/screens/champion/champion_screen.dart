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
    final appearance = ChampionScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final award = Row(
      mainAxisSize: appearance.min,
      mainAxisAlignment: appearance.centerMain,
      children: [
        AppIcon(AppGlyph.trophy, color: appearance.accentHero.color),
        SizedBox(width: appearance.small),
        Text(localizations.screenChampion, style: appearance.award),
      ],
    );
    final hero = Column(
      mainAxisSize: appearance.min,
      mainAxisAlignment: appearance.centerMain,
      crossAxisAlignment: appearance.centerCross,
      children: [
        award,
        SizedBox(height: appearance.heroGap),
        AppIdentity(
          primary: state.winner.character,
          initials: state.winner.initials,
          secondary: state.winner.name,
          layout: AppIdentityLayout.stacked,
          theme: appearance.championIdentity,
        ),
      ],
    );
    final action = AppButton(
      label: localizations.screenTournamentResults,
      glyph: AppGlyph.arrow,
      onPressed: onResults,
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenFinished,
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
                ? SingleChildScrollView(
                    child: SizedBox(
                      height: appearance.championHeight,
                      child: Row(
                        crossAxisAlignment: appearance.stretch,
                        children: [
                          Expanded(
                            flex: appearance.homePrimaryFlex,
                            child: AppScreenTile(
                              raised: true,
                              child: Center(child: hero),
                            ),
                          ),
                          SizedBox(width: appearance.gap),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: appearance.stretch,
                              children: [
                                Expanded(
                                  flex: appearance.homePrimaryFlex,
                                  child: AppScreenTile(
                                    child: Align(
                                      alignment: appearance.contextAlignment,
                                      child: Text(
                                        state.title,
                                        style: appearance.contextTitle,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: appearance.gap),
                                Expanded(
                                  child: Align(
                                    alignment: appearance.bottomAlign,
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
                    crossAxisAlignment: appearance.stretch,
                    children: [
                      Expanded(
                        child: Center(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: appearance.min,
                              children: [
                                hero,
                                SizedBox(height: appearance.heroGap),
                                Text(state.title, style: appearance.caption),
                              ],
                            ),
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
