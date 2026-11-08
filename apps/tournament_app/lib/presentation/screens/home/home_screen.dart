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
    final t = HomeScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final active = state.active;
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          Row(
            mainAxisAlignment: t.spaceBetween,
            children: [
              AppButton(
                label: l.screenHistory,
                fill: false,
                kind: AppButtonKind.secondary,
                glyph: AppGlyph.history,
                glyphLeading: true,
                onPressed: onHistory,
              ),
              AppButton(
                label: l.screenProfile,
                kind: AppButtonKind.icon,
                glyph: AppGlyph.person,
                onPressed: onProfile,
              ),
            ],
          ),
          SizedBox(height: t.homeGap),
          if (active != null) ...[
            Row(
              mainAxisAlignment: t.spaceBetween,
              children: [
                Text(l.screenTournaments, style: t.body),
                AppButton(
                  label: l.screenNew,
                  glyphLeading: true,
                  fill: false,
                  kind: AppButtonKind.dialogCancel,
                  glyph: AppGlyph.plus,
                  onPressed: onCreate,
                ),
              ],
            ),
            SizedBox(height: t.homeGap),
          ],
          Expanded(
            child: active == null
                ? Stack(
                    children: [
                      Positioned.fill(
                        child: AppScreenTile(
                          child: Column(
                            mainAxisAlignment: t.centerMain,
                            crossAxisAlignment: t.start,
                            children: [
                              Text(l.screenYourNext, style: t.hero),
                              Text(
                                l.screenTournamentAccent,
                                style: t.accentHero,
                              ),
                              SizedBox(height: t.homeGap),
                              AppIcon(
                                AppGlyph.trophy,
                                color: t.accentHero.color,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: t.bottomAlign,
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: t.desktop ? t.formWidth : t.fullWidth,
                          ),
                          child: Column(
                            mainAxisSize: t.min,
                            crossAxisAlignment: t.stretch,
                            children: [
                              Text(l.screenNoActive, style: t.muted),
                              SizedBox(height: t.homeGap),
                              AppButton(
                                label: l.screenCreate,
                                glyph: AppGlyph.arrow,
                                onPressed: onCreate,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                : t.desktop
                ? Row(
                    crossAxisAlignment: t.stretch,
                    children: [
                      Expanded(
                        flex: t.homePrimaryFlex,
                        child: AppScreenTile(
                          padding: t.heroPadding,
                          child: Column(
                            crossAxisAlignment: t.start,
                            children: [
                              AppStatusLabel(text: l.screenLive),
                              const Spacer(),
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: t.homeTitleWidth,
                                ),
                                child: Text(active.name, style: t.hero),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: t.homeGap),
                      Expanded(
                        flex: t.homeSecondaryFlex,
                        child: Column(
                          crossAxisAlignment: t.stretch,
                          children: [
                            Expanded(
                              child: AppScreenTile(
                                raised: true,
                                child: Align(
                                  alignment: t.centerAlign,
                                  child: Column(
                                    mainAxisSize: t.min,
                                    crossAxisAlignment: t.start,
                                    children: [
                                      Text(active.formatLabel, style: t.meta),
                                      SizedBox(height: t.small),
                                      Text(
                                        active.participantCountLabel,
                                        style: t.meta,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: t.homeGap),
                            Expanded(
                              child: AppScreenTile(
                                child: Column(
                                  crossAxisAlignment: t.stretch,
                                  children: [
                                    AppStageProgress(
                                      highlights: active.stageHighlights,
                                    ),
                                    const Spacer(),
                                    Text(active.stage, style: t.stageStyle),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: t.homeGap),
                            SizedBox(
                              height: t.homeActionHeight,
                              child: AppButton(
                                label: l.screenContinue,
                                glyph: AppGlyph.arrow,
                                onPressed: onContinue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: AppSurface(
                      child: Column(
                        crossAxisAlignment: t.stretch,
                        children: [
                          AppStatusLabel(text: l.screenLive),
                          SizedBox(height: t.small),
                          Text(active.name, style: t.heading),
                          SizedBox(height: t.small),
                          Text(active.formatLabel, style: t.muted),
                          Text(active.participantCountLabel, style: t.muted),
                          SizedBox(height: t.homeGap),
                          Text(active.stage, style: t.stageStyle),
                          SizedBox(height: t.homeGap),
                          AppButton(
                            label: l.screenContinue,
                            glyph: AppGlyph.arrow,
                            onPressed: onContinue,
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
