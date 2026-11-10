import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';
import 'package:tournament_app/presentation/screens/distribution/distribution_screen_state.dart';
import 'package:tournament_app/presentation/screens/distribution/distribution_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/adaptive_grid/app_adaptive_grid.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
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
    final appearance = DistributionScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final header = AppSectionHeader(
      title: localizations.screenDistribution,
      backLabel: localizations.screenBack,
      onBack: onBack,
      action: AppHeaderAction(
        kind: AppHeaderActionKind.share,
        label: localizations.screenSpectators,
        onPressed: onShare,
      ),
    );
    final intro = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.start,
      children: [
        Text(localizations.screenRosterReady, style: appearance.heading),
        SizedBox(height: appearance.gap),
        Text(localizations.screenEachCharacter, style: appearance.caption),
      ],
    );
    final list = appearance.desktop
        ? AppAdaptiveGrid(
            columns: appearance.gridColumns,
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
              crossAxisAlignment: appearance.stretch,
              children: [
                for (final (index, player) in state.players.indexed) ...[
                  if (index > 0) SizedBox(height: appearance.small),
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
      label: localizations.screenStartTournament,
      glyph: AppGlyph.arrow,
      onPressed: onStart,
    );
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          header,
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
                            AppScreenTile(child: intro),
                            SizedBox(height: appearance.gap),
                            start,
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
                              intro,
                              SizedBox(height: appearance.gap),
                              list,
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: appearance.gap),
                      start,
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
