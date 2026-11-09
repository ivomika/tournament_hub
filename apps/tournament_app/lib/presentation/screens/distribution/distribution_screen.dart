import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/distribution/distribution_screen_state.dart';
import 'package:tournament_app/presentation/screens/distribution/distribution_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_centered_screen.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/components/progress_indicator/app_progress_indicator.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface_theme.dart';

class DistributionScreen extends StatelessWidget {
  const DistributionScreen({
    required this.state,
    required this.onBack,
    required this.onShare,
    required this.onStart,
    super.key,
  });
  final DistributionScreenState state;
  final VoidCallback? onBack, onShare, onStart;
  @override
  Widget build(BuildContext context) {
    final t = DistributionScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final header = AppSectionHeader(
      title: l.screenDistribution,
      backLabel: l.screenBack,
      onBack: onBack,
      action: state.phase == DistributionPhase.ready
          ? AppHeaderAction(
              kind: AppHeaderActionKind.share,
              label: l.screenSpectators,
              onPressed: onShare,
            )
          : null,
    );
    if (state.phase == DistributionPhase.working) {
      return AppCenteredScreen(
        header: header,
        child: Column(
          mainAxisSize: t.min,
          crossAxisAlignment: t.start,
          mainAxisAlignment: t.centerMain,
          children: [
            AppProgressIndicator(semanticLabel: l.screenDealing),
            SizedBox(height: t.gap),
            Text(l.screenWhoCharacter, style: t.heading),
            SizedBox(height: t.gap),
            Text(l.screenNoRepeats, style: t.muted),
          ],
        ),
      );
    }
    final intro = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.start,
      children: [
        Text(l.screenRosterReady, style: t.heading),
        SizedBox(height: t.gap),
        Text(l.screenEachCharacter, style: t.caption),
      ],
    );
    final list = t.desktop
        ? AppAdaptiveGrid(
            columns: t.gridColumns,
            children: [
              for (final player in state.players)
                AppSurface(
                  tone: AppSurfaceTone.surface,
                  child: AppIdentity(
                    primary: player.character,
                    initials: player.initials,
                    secondary: player.name,
                    layout: AppIdentityLayout.stacked,
                    size: AppAvatarSize.large,
                  ),
                ),
            ],
          )
        : AppSurface(
            child: Column(
              crossAxisAlignment: t.stretch,
              children: [
                for (final (index, player) in state.players.indexed) ...[
                  if (index > 0) SizedBox(height: t.small),
                  AppIdentity(
                    primary: player.character,
                    initials: player.initials,
                    secondary: player.name,
                  ),
                ],
              ],
            ),
          );
    final start = AppButton(
      label: l.screenStartTournament,
      glyph: AppGlyph.arrow,
      onPressed: onStart,
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          header,
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
                            AppScreenTile(child: intro),
                            SizedBox(height: t.gap),
                            start,
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
                              intro,
                              SizedBox(height: t.gap),
                              list,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: t.gap),
                      start,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
