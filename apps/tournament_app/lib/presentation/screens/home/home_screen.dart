import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/components/stage_progress/app_stage_progress.dart';
import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/home/home_screen_state.dart';
import 'package:tournament_app/presentation/screens/home/home_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button_theme.dart';
import 'package:tournament_app/presentation/design_system/components/status_label/app_status_label.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_icon.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.state,
    required this.onHistory,
    required this.onProfile,
    required this.onCreate,
    required this.onContinue,
    super.key,
  });
  final HomeScreenState state;
  final VoidCallback? onHistory, onProfile, onCreate, onContinue;
  @override
  Widget build(BuildContext context) {
    final appearance = HomeScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final active = state.active;
    final Widget? responsiveContent;
    if (active == null) {
      responsiveContent = Stack(
        children: [
          Positioned.fill(
            child: AppScreenTile(
              padding: appearance.emptyPadding,
              child: Column(
                mainAxisAlignment: appearance.centerMain,
                crossAxisAlignment: appearance.start,
                children: [
                  Text(localizations.screenYourNext, style: appearance.hero),
                  Text(
                    localizations.screenTournamentAccent,
                    style: appearance.accentHero,
                  ),
                  SizedBox(height: appearance.homeGap),
                  Row(
                    mainAxisSize: appearance.min,
                    children: [
                      SizedBox(
                        width: appearance.ornamentLine,
                        child: Divider(color: appearance.ornamentColor),
                      ),
                      SizedBox(width: appearance.small),
                      AppIcon(
                        AppGlyph.trophy,
                        size: appearance.trophySize,
                        color: appearance.accentHero.color,
                      ),
                      SizedBox(width: appearance.small),
                      SizedBox(
                        width: appearance.ornamentLine,
                        child: Divider(color: appearance.ornamentColor),
                      ),
                    ],
                  ),
                  SizedBox(height: appearance.homeGap),
                  Text(localizations.screenNoActive, style: appearance.muted),
                ],
              ),
            ),
          ),
          Align(
            alignment: appearance.bottomAlign,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: appearance.desktop
                    ? appearance.formWidth
                    : appearance.fullWidth,
              ),
              child: Padding(
                padding: appearance.emptyActionPadding,
                child: AppButton(
                  label: localizations.screenCreate,
                  glyph: AppGlyph.plus,
                  onPressed: onCreate,
                ),
              ),
            ),
          ),
        ],
      );
    } else {
      if (appearance.desktop) {
        responsiveContent = Row(
          crossAxisAlignment: appearance.stretch,
          children: [
            Expanded(
              flex: appearance.homePrimaryFlex,
              child: AppScreenTile(
                padding: appearance.heroPadding,
                child: Column(
                  crossAxisAlignment: appearance.start,
                  children: [
                    AppStatusLabel(text: localizations.screenLive),
                    const Spacer(),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: appearance.homeTitleWidth,
                      ),
                      child: Text(active.name, style: appearance.hero),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: appearance.homeGap),
            Expanded(
              flex: appearance.homeSecondaryFlex,
              child: Column(
                crossAxisAlignment: appearance.stretch,
                children: [
                  Expanded(
                    child: AppScreenTile(
                      raised: true,
                      child: Align(
                        alignment: appearance.centerAlign,
                        child: Column(
                          mainAxisSize: appearance.min,
                          crossAxisAlignment: appearance.start,
                          children: [
                            Text(active.formatLabel, style: appearance.meta),
                            SizedBox(height: appearance.small),
                            Text(
                              active.participantCountLabel,
                              style: appearance.meta,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: appearance.homeGap),
                  Expanded(
                    child: AppScreenTile(
                      child: Column(
                        crossAxisAlignment: appearance.stretch,
                        children: [
                          AppStageProgress(highlights: active.stageHighlights),
                          const Spacer(),
                          Text(active.stage, style: appearance.stageStyle),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: appearance.homeGap),
                  SizedBox(
                    height: appearance.homeActionHeight,
                    child: AppButton(
                      label: localizations.screenContinue,
                      glyph: AppGlyph.arrow,
                      onPressed: onContinue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      } else {
        responsiveContent = SingleChildScrollView(
          child: AppSurface(
            child: Column(
              crossAxisAlignment: appearance.stretch,
              children: [
                AppStatusLabel(text: localizations.screenLive),
                SizedBox(height: appearance.small),
                Text(active.name, style: appearance.heading),
                SizedBox(height: appearance.small),
                Text(active.formatLabel, style: appearance.muted),
                Text(active.participantCountLabel, style: appearance.muted),
                SizedBox(height: appearance.homeGap),
                Text(active.stage, style: appearance.stageStyle),
                SizedBox(height: appearance.homeGap),
                AppButton(
                  label: localizations.screenContinue,
                  glyph: AppGlyph.arrow,
                  onPressed: onContinue,
                ),
              ],
            ),
          ),
        );
      }
    }
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          Row(
            mainAxisAlignment: appearance.spaceBetween,
            children: [
              AppButton(
                label: localizations.screenHistory,
                fill: false,
                kind: AppButtonKind.secondary,
                glyph: AppGlyph.history,
                glyphLeading: true,
                onPressed: onHistory,
              ),
              AppButton(
                label: localizations.screenProfile,
                kind: AppButtonKind.icon,
                glyph: AppGlyph.person,
                onPressed: onProfile,
              ),
            ],
          ),
          SizedBox(height: appearance.homeGap),
          if (active != null) ...[
            Row(
              mainAxisAlignment: appearance.spaceBetween,
              children: [
                Text(localizations.screenTournaments, style: appearance.body),
                AppButton(
                  label: localizations.screenNew,
                  glyphLeading: true,
                  fill: false,
                  kind: AppButtonKind.dialogCancel,
                  glyph: AppGlyph.plus,
                  onPressed: onCreate,
                ),
              ],
            ),
            SizedBox(height: appearance.homeGap),
          ],
          Expanded(child: responsiveContent),
        ],
      ),
    );
  }
}
