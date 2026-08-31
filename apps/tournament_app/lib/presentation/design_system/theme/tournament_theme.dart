import 'package:flutter/material.dart';

import '../components/action_dock/action_dock_theme.dart';
import '../components/adaptive_split/adaptive_split_theme.dart';
import '../components/app_shell/app_shell_theme.dart';
import '../components/bracket/bracket_theme.dart';
import '../components/champion_hero/champion_hero_theme.dart';
import '../components/confirmation/confirmation_theme.dart';
import '../components/connection_banner/connection_banner_theme.dart';
import '../components/connection_qr_card/connection_qr_card_theme.dart';
import '../components/danger_zone/danger_zone_theme.dart';
import '../components/ds_action/ds_action_theme.dart';
import '../components/ds_field/ds_field_theme.dart';
import '../components/ds_flow/ds_flow_theme.dart';
import '../components/ds_info_row/ds_info_row_theme.dart';
import '../components/ds_progress/ds_progress_theme.dart';
import '../components/ds_section/ds_section_theme.dart';
import '../components/ds_select/ds_select_theme.dart';
import '../components/ds_spacing/ds_spacing_theme.dart';
import '../components/ds_surface/ds_surface_theme.dart';
import '../components/ds_text/ds_text_theme.dart';
import '../components/double_elimination_bracket/double_elimination_bracket_theme.dart';
import '../components/empty_state/empty_state_theme.dart';
import '../components/fighter_avatar/fighter_avatar_theme.dart';
import '../components/history_snapshot_card/history_snapshot_card_theme.dart';
import '../components/host_open_connection_summary/host_open_connection_summary_theme.dart';
import '../components/match_card/match_card_theme.dart';
import '../components/match_list/match_list_theme.dart';
import '../components/outcome_picker/outcome_picker_theme.dart';
import '../components/page_header/page_header_theme.dart';
import '../components/page_layout/page_layout_theme.dart';
import '../components/participant_identity/participant_identity_theme.dart';
import '../components/participant_invite_card/participant_invite_card_theme.dart';
import '../components/participant_join_panel/participant_join_panel_theme.dart';
import '../components/profile_summary/profile_summary_theme.dart';
import '../components/qr_code/qr_code_theme.dart';
import '../components/qr_quiet_zone/qr_quiet_zone_theme.dart';
import '../components/responsive_actions/responsive_actions_theme.dart';
import '../components/standings/standings_theme.dart';
import '../components/status_badge/status_badge_theme.dart';
import '../components/spectator_access_dialog/spectator_access_dialog_theme.dart';
import '../components/token_showcase/token_showcase_theme.dart';
import '../components/tournament_summary/tournament_summary_theme.dart';
import '../components/tournament_stage/tournament_stage_theme.dart';
import '../tokens/tokens.g.dart';

abstract final class TournamentTheme {
  static ThemeData get dark {
    final text = _text;
    final primaryButton = ElevatedButton.styleFrom(
      minimumSize: const Size(
        TournamentTokens.controlTouchTargetPreferred,
        TournamentTokens.controlHeightLargeMin,
      ),
      backgroundColor: TournamentTokens.colorAccentPrimary,
      foregroundColor: TournamentTokens.colorBackgroundCanvas,
      textStyle: text.label,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TournamentTokens.radiusMd),
      ),
    );
    final secondaryButton = OutlinedButton.styleFrom(
      minimumSize: const Size(
        TournamentTokens.controlTouchTargetPreferred,
        TournamentTokens.controlHeightLargeMin,
      ),
      foregroundColor: TournamentTokens.colorTextPrimary,
      textStyle: text.label,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TournamentTokens.radiusMd),
      ),
    );
    final textButton = TextButton.styleFrom(
      foregroundColor: TournamentTokens.colorAccentPrimary,
      textStyle: text.label,
    );
    final dangerButton = OutlinedButton.styleFrom(
      minimumSize: const Size(
        TournamentTokens.controlTouchTargetPreferred,
        TournamentTokens.controlHeightStandardMin,
      ),
      foregroundColor: TournamentTokens.colorStatusDanger,
      side: const BorderSide(color: TournamentTokens.colorStatusDanger),
      textStyle: text.label,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(TournamentTokens.radiusMd),
      ),
    );
    final fieldDecoration = InputDecoration(
      filled: true,
      fillColor: TournamentTokens.colorSurfaceSecondary,
      labelStyle: text.secondary,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(TournamentTokens.radiusMd),
      ),
    );
    final fieldTheme = InputDecorationTheme(
      filled: fieldDecoration.filled,
      fillColor: fieldDecoration.fillColor,
      labelStyle: fieldDecoration.labelStyle,
      border: fieldDecoration.border,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: TournamentTokens.colorBackgroundCanvas,
      colorScheme: ColorScheme.fromSeed(
        seedColor: TournamentTokens.colorAccentPrimary,
        brightness: Brightness.dark,
        surface: TournamentTokens.colorSurfacePrimary,
        error: TournamentTokens.colorStatusDanger,
      ),
      textTheme: TextTheme(
        displayLarge: text.display,
        headlineLarge: text.heading,
        titleLarge: text.title,
        bodyLarge: text.body,
        bodyMedium: text.secondary,
        labelLarge: text.label,
      ),
      inputDecorationTheme: fieldTheme,
      extensions: [
        text,
        const ActionDockTheme(
          background: TournamentTokens.colorBackgroundSubtle,
          divider: TournamentTokens.colorSurfaceTertiary,
          foreground: TournamentTokens.colorTextPrimary,
          danger: TournamentTokens.colorStatusDanger,
          padding: TournamentTokens.spaceV3,
          gap: TournamentTokens.spaceV2,
          radius: TournamentTokens.radiusMd,
          minimumHeight: TournamentTokens.controlHeightLargeMin,
          overflowSize: TournamentTokens.controlTouchTargetPreferred,
          portraitMaxFraction: 0.25,
          landscapeMaxFraction: 0.20,
        ),
        const AdaptiveSplitTheme(
          breakpoint: TournamentTokens.breakpointExpandedMin,
          gap: TournamentTokens.spaceV6,
          primaryFlex: 3,
          secondaryFlex: 2,
        ),
        const PageLayoutTheme(
          expandedBreakpoint: TournamentTokens.breakpointExpandedMin,
          panelGap: TournamentTokens.spaceV6,
          supportingGap: TournamentTokens.spaceV6,
          focusedMaxWidth: TournamentTokens.breakpointCompactMax,
          splitPrimaryFlex: 2,
          splitSecondaryFlex: 1,
          workspacePrimaryFlex: 3,
          workspaceSecondaryFlex: 2,
          archivePrimaryFlex: 3,
          archiveSecondaryFlex: 1,
          heroPrimaryFlex: 2,
          heroSecondaryFlex: 1,
          flowPrimaryFlex: 2,
          flowSecondaryFlex: 1,
        ),
        const DsSpacingTheme(
          xs: TournamentTokens.spaceV1,
          sm: TournamentTokens.spaceV2,
          md: TournamentTokens.spaceV4,
          lg: TournamentTokens.spaceV6,
          xl: TournamentTokens.spaceV12,
          page: TournamentTokens.layoutPagePaddingCompact,
        ),
        const DsSurfaceTheme(
          background: TournamentTokens.colorSurfacePrimary,
          elevatedBackground: TournamentTokens.colorSurfaceSecondary,
          accentBackground: TournamentTokens.colorBackgroundElevated,
          border: TournamentTokens.colorSurfaceTertiary,
          accentBorder: TournamentTokens.colorAccentPrimary,
          radius: TournamentTokens.radiusLg,
          compactPadding: TournamentTokens.spaceV4,
          padding: TournamentTokens.spaceV6,
          presentationPadding: TournamentTokens.spaceV8,
        ),
        DsActionTheme(
          primary: primaryButton,
          secondary: secondaryButton,
          text: textButton,
          danger: dangerButton,
          contentGap: TournamentTokens.spaceV2,
          success: TournamentTokens.colorStatusSuccess,
          indicatorSize: TournamentTokens.fontSizeV18,
          indicatorStrokeWidth: TournamentTokens.spaceV1,
        ),
        const DangerZoneTheme(
          gap: TournamentTokens.spaceV4,
          iconColor: TournamentTokens.colorStatusDanger,
        ),
        DsFieldTheme(
          decoration: fieldDecoration,
          success: TournamentTokens.colorStatusSuccess,
          indicatorSize: TournamentTokens.fontSizeV18,
          indicatorStrokeWidth: TournamentTokens.spaceV1,
        ),
        DsSelectTheme(
          decoration: fieldDecoration,
          menuMaxHeight: TournamentTokens.breakpointCompactMax,
        ),
        const DsFlowTheme(gap: TournamentTokens.spaceV3),
        const FighterAvatarTheme(
          background: TournamentTokens.colorSurfaceTertiary,
          prominentBackground: TournamentTokens.colorBackgroundElevated,
          foreground: TournamentTokens.colorTextPrimary,
          border: TournamentTokens.colorSurfaceHover,
          prominentBorder: TournamentTokens.colorAccentPrimary,
          compactSize: TournamentTokens.artworkSizeCompact,
          standardSize: TournamentTokens.artworkSizeStandard,
          matchupSize: TournamentTokens.artworkSizeMatchup,
          heroSize: TournamentTokens.artworkSizeHero,
          compactPlaceholderSize: TournamentTokens.fontSizeV24,
          standardPlaceholderSize: TournamentTokens.fontSizeV40,
          matchupPlaceholderSize: TournamentTokens.fontSizeV56,
          heroPlaceholderSize: TournamentTokens.spaceV24,
          radius: TournamentTokens.radiusXl,
        ),
        const ParticipantIdentityTheme(
          compactGap: TournamentTokens.spaceV3,
          standardGap: TournamentTokens.spaceV4,
          prominentGap: TournamentTokens.spaceV6,
        ),
        const HistorySnapshotCardTheme(
          compactGap: TournamentTokens.spaceV2,
          gap: TournamentTokens.spaceV4,
          presentationGap: TournamentTokens.spaceV6,
          compactContentPadding: TournamentTokens.spaceV0,
          contentPadding: TournamentTokens.spaceV1,
          presentationContentPadding: TournamentTokens.spaceV4,
          compactBreakpoint: TournamentTokens.breakpointMediumMin,
          radius: TournamentTokens.radiusLg,
          iconColor: TournamentTokens.colorTextSecondary,
        ),
        const HostOpenConnectionSummaryTheme(gap: TournamentTokens.spaceV3),
        const ProfileSummaryTheme(
          gap: TournamentTokens.spaceV4,
          iconSize: TournamentTokens.artworkSizeStandard,
          iconColor: TournamentTokens.colorBackgroundCanvas,
          iconBackground: TournamentTokens.colorAccentPrimary,
          compactBreakpoint: TournamentTokens.breakpointMediumMin,
        ),
        const StatusBadgeTheme(
          background: TournamentTokens.colorSurfaceSecondary,
          success: TournamentTokens.colorStatusSuccess,
          danger: TournamentTokens.colorStatusDanger,
          warning: TournamentTokens.colorStatusWarning,
          info: TournamentTokens.colorStatusInfo,
          neutral: TournamentTokens.colorTextSecondary,
          radius: TournamentTokens.radiusFull,
          horizontalPadding: TournamentTokens.spaceV2,
          verticalPadding: TournamentTokens.spaceV1,
          gap: TournamentTokens.spaceV1,
          iconSize: TournamentTokens.fontSizeV14,
        ),
        const ConnectionBannerTheme(
          gap: TournamentTokens.spaceV2,
          compactWidth: TournamentTokens.breakpointCompactMax,
        ),
        ConnectionQrCardTheme(
          background: TournamentTokens.colorBackgroundElevated,
          border: TournamentTokens.colorSurfaceTertiary,
          accent: TournamentTokens.colorAccentPrimary,
          info: TournamentTokens.colorStatusInfo,
          success: TournamentTokens.colorStatusSuccess,
          warning: TournamentTokens.colorStatusWarning,
          danger: TournamentTokens.colorStatusDanger,
          neutral: TournamentTokens.colorTextSecondary,
          addressStyle: text.title.copyWith(
            fontFamily: 'monospace',
            color: TournamentTokens.colorTextPrimary,
          ),
          padding: TournamentTokens.spaceV6,
          gap: TournamentTokens.spaceV6,
          compactGap: TournamentTokens.spaceV2,
          radius: TournamentTokens.radiusXl,
          compactBreakpoint: TournamentTokens.breakpointMediumMin,
          accentWidth: TournamentTokens.borderWidthBase,
        ),
        ParticipantInviteCardTheme(
          background: TournamentTokens.colorBackgroundElevated,
          border: TournamentTokens.colorSurfaceTertiary,
          accent: TournamentTokens.colorAccentPrimary,
          warning: TournamentTokens.colorStatusWarning,
          danger: TournamentTokens.colorStatusDanger,
          radius: TournamentTokens.radiusXl,
          padding: TournamentTokens.spaceV6,
          gap: TournamentTokens.spaceV6,
          compactGap: TournamentTokens.spaceV2,
          compactBreakpoint: TournamentTokens.breakpointMediumMin,
          codeStyle: text.heading.copyWith(
            fontFamily: 'monospace',
            color: TournamentTokens.colorTextPrimary,
          ),
        ),
        const ParticipantJoinPanelTheme(
          scannerBackground: TournamentTokens.colorBackgroundElevated,
          scannerBorder: TournamentTokens.colorAccentPrimary,
          radius: TournamentTokens.radiusXl,
          padding: TournamentTokens.spaceV6,
          gap: TournamentTokens.spaceV4,
          scannerHeight:
              TournamentTokens.artworkSizeHero + TournamentTokens.spaceV12,
        ),
        const SpectatorAccessDialogTheme(
          background: TournamentTokens.colorBackgroundCanvas,
          maxContentWidth: TournamentTokens.layoutHostContentMaxMax,
          gap: TournamentTokens.spaceV6,
        ),
        const QrQuietZoneTheme(
          background: TournamentTokens.colorTextPrimary,
          modules: 4,
          radius: TournamentTokens.radiusLg,
        ),
        const QrCodeTheme(
          foreground: TournamentTokens.colorBackgroundCanvas,
          fallbackBackground: TournamentTokens.colorSurfaceSecondary,
          fallbackForeground: TournamentTokens.colorTextSecondary,
          moduleRoundFactor: 0.72,
          finderOuterRadiusFactor: 1.65,
          finderCenterRadiusFactor: 0.82,
          compactSize: TournamentTokens.artworkSizeHero,
          standardSize:
              TournamentTokens.artworkSizeHero + TournamentTokens.spaceV16,
          largeSize:
              TournamentTokens.artworkSizeHero + TournamentTokens.spaceV16 * 3,
          minimumModulePitch: TournamentTokens.spaceV1,
          fallbackIconSize: TournamentTokens.spaceV16,
        ),
        const MatchCardTheme(
          gap: TournamentTokens.spaceV6,
          divider: TournamentTokens.colorSurfaceTertiary,
          accent: TournamentTokens.colorAccentPrimary,
          versusBackground: TournamentTokens.colorSurfaceTertiary,
          compactBreakpoint: TournamentTokens.breakpointMediumMin,
          versusSize: TournamentTokens.spaceV12,
        ),
        const OutcomePickerTheme(
          gap: TournamentTokens.spaceV4,
          compactBreakpoint: TournamentTokens.breakpointMediumMin,
        ),
        const StandingsTheme(
          gap: TournamentTokens.spaceV4,
          rankWidth: TournamentTokens.spaceV6,
          desktopBreakpoint: TournamentTokens.breakpointMediumMin,
          divider: TournamentTokens.colorSurfaceTertiary,
        ),
        const BracketTheme(gap: TournamentTokens.spaceV4),
        const MatchListTheme(gap: TournamentTokens.spaceV4),
        const DoubleEliminationBracketTheme(
          connector: TournamentTokens.colorTextSecondary,
          winnerConnector: TournamentTokens.colorStatusSuccess,
          loserConnector: TournamentTokens.colorStatusWarning,
          canvasWidth: TournamentTokens.layoutHostContentMaxMax,
          canvasHeight:
              TournamentTokens.breakpointXlargeMin +
              TournamentTokens.artworkSizeHero,
          viewportHeight: TournamentTokens.breakpointMediumMax,
          nodeWidth: TournamentTokens.artworkSizeHero,
          nodeHeight:
              TournamentTokens.artworkSizeHero +
              TournamentTokens.spaceV16 +
              TournamentTokens.spaceV24 +
              TournamentTokens.spaceV12,
          columnGap: TournamentTokens.spaceV12,
          rowGap: TournamentTokens.spaceV12,
          losersOffset: TournamentTokens.breakpointExpandedMax,
          padding: TournamentTokens.spaceV4,
          lineWidth: TournamentTokens.spaceV1,
          minScale: 1,
          maxScale: 2,
        ),
        const EmptyStateTheme(
          foreground: TournamentTokens.colorTextSecondary,
          error: TournamentTokens.colorStatusDanger,
          iconSize: TournamentTokens.spaceV12,
          maxWidth: TournamentTokens.breakpointCompactMax,
          gap: TournamentTokens.spaceV4,
        ),
        const ConfirmationTheme(
          background: TournamentTokens.colorSurfacePrimary,
          radius: TournamentTokens.radiusLg,
          padding: TournamentTokens.spaceV6,
          gap: TournamentTokens.spaceV4,
        ),
        const ChampionHeroTheme(
          iconColor: TournamentTokens.colorAccentPrimary,
          iconSize: TournamentTokens.spaceV16,
          gap: TournamentTokens.spaceV4,
          desktopBreakpoint: TournamentTokens.breakpointExpandedMin,
          contentMaxWidth: TournamentTokens.breakpointMediumMax,
        ),
        const DsSectionTheme(
          compactGap: TournamentTokens.spaceV3,
          gap: TournamentTokens.spaceV6,
          presentationGap: TournamentTokens.spaceV8,
        ),
        const DsProgressTheme(
          color: TournamentTokens.colorAccentPrimary,
          size: TournamentTokens.spaceV12,
        ),
        const DsInfoRowTheme(
          gap: TournamentTokens.spaceV3,
          iconColor: TournamentTokens.colorTextSecondary,
        ),
        const AppShellTheme(
          background: TournamentTokens.colorBackgroundCanvas,
          elevatedBackground: TournamentTokens.colorBackgroundElevated,
          navigationBackground: TournamentTokens.colorBackgroundSubtle,
          divider: TournamentTokens.colorSurfaceTertiary,
          desktopBreakpoint: TournamentTokens.breakpointExpandedMin,
          contentMaxWidth: TournamentTokens.layoutHostContentMaxMax,
          pagePaddingCompact: TournamentTokens.layoutPagePaddingCompact,
          mediumBreakpoint: TournamentTokens.breakpointMediumMin,
          pagePaddingMedium: TournamentTokens.layoutPagePaddingMediumMin,
          pagePaddingDesktop: TournamentTokens.layoutPagePaddingDesktopMax,
          contentGap: TournamentTokens.spaceV6,
          navigationHeight:
              TournamentTokens.spaceV16 + TournamentTokens.spaceV4,
          actionDockEstimatedHeight:
              TournamentTokens.spaceV16 + TournamentTokens.spaceV3,
          portraitFixedStackMaxFraction: 0.25,
          landscapeFixedStackMaxFraction: 0.20,
          navigationWithDockMaxTextScale: 1.5,
        ),
        const ResponsiveActionsTheme(
          background: TournamentTokens.colorBackgroundSubtle,
          divider: TournamentTokens.colorSurfaceTertiary,
          gap: TournamentTokens.spaceV3,
          sectionGap: TournamentTokens.spaceV6,
          padding: TournamentTokens.spaceV4,
          horizontalBreakpoint: TournamentTokens.breakpointCompactMax,
        ),
        const PageHeaderTheme(
          accent: TournamentTokens.colorAccentPrimary,
          gap: TournamentTokens.spaceV3,
          labelGap: TournamentTokens.spaceV2,
          markerWidth: TournamentTokens.spaceV1,
          markerHeight: TournamentTokens.spaceV6,
          trailingBreakpoint: TournamentTokens.breakpointExpandedMin,
          trailingTopPadding: TournamentTokens.spaceV6,
        ),
        const TournamentSummaryTheme(
          gap: TournamentTokens.spaceV6,
          compactBreakpoint: TournamentTokens.breakpointExpandedMin,
          accent: TournamentTokens.colorAccentPrimary,
          divider: TournamentTokens.colorSurfaceTertiary,
        ),
        const TournamentStageTheme(
          gap: TournamentTokens.spaceV4,
          compactGap: TournamentTokens.spaceV2,
          accent: TournamentTokens.colorAccentPrimary,
          divider: TournamentTokens.colorSurfaceTertiary,
        ),
        const TokenShowcaseTheme(
          colors: [
            TokenColorSample(
              'background.canvas',
              TournamentTokens.colorBackgroundCanvas,
            ),
            TokenColorSample(
              'background.subtle',
              TournamentTokens.colorBackgroundSubtle,
            ),
            TokenColorSample(
              'background.elevated',
              TournamentTokens.colorBackgroundElevated,
            ),
            TokenColorSample(
              'surface.primary',
              TournamentTokens.colorSurfacePrimary,
            ),
            TokenColorSample(
              'surface.secondary',
              TournamentTokens.colorSurfaceSecondary,
            ),
            TokenColorSample(
              'surface.tertiary',
              TournamentTokens.colorSurfaceTertiary,
            ),
            TokenColorSample(
              'surface.hover',
              TournamentTokens.colorSurfaceHover,
            ),
            TokenColorSample('text.primary', TournamentTokens.colorTextPrimary),
            TokenColorSample(
              'text.secondary',
              TournamentTokens.colorTextSecondary,
            ),
            TokenColorSample(
              'text.tertiary',
              TournamentTokens.colorTextTertiary,
            ),
            TokenColorSample(
              'text.disabled',
              TournamentTokens.colorTextDisabled,
            ),
            TokenColorSample(
              'accent.primary',
              TournamentTokens.colorAccentPrimary,
            ),
            TokenColorSample(
              'status.success',
              TournamentTokens.colorStatusSuccess,
            ),
            TokenColorSample(
              'status.danger',
              TournamentTokens.colorStatusDanger,
            ),
            TokenColorSample(
              'status.warning',
              TournamentTokens.colorStatusWarning,
            ),
            TokenColorSample('status.info', TournamentTokens.colorStatusInfo),
          ],
          spacing: [
            TokenMetricSample('space.0', TournamentTokens.spaceV0, 'px'),
            TokenMetricSample('space.1', TournamentTokens.spaceV1, 'px'),
            TokenMetricSample('space.2', TournamentTokens.spaceV2, 'px'),
            TokenMetricSample('space.3', TournamentTokens.spaceV3, 'px'),
            TokenMetricSample('space.4', TournamentTokens.spaceV4, 'px'),
            TokenMetricSample('space.5', TournamentTokens.spaceV5, 'px'),
            TokenMetricSample('space.6', TournamentTokens.spaceV6, 'px'),
            TokenMetricSample('space.8', TournamentTokens.spaceV8, 'px'),
            TokenMetricSample('space.10', TournamentTokens.spaceV10, 'px'),
            TokenMetricSample('space.12', TournamentTokens.spaceV12, 'px'),
            TokenMetricSample('space.16', TournamentTokens.spaceV16, 'px'),
            TokenMetricSample('space.20', TournamentTokens.spaceV20, 'px'),
            TokenMetricSample('space.24', TournamentTokens.spaceV24, 'px'),
          ],
          radii: [
            TokenMetricSample('radius.sm', TournamentTokens.radiusSm, 'px'),
            TokenMetricSample('radius.md', TournamentTokens.radiusMd, 'px'),
            TokenMetricSample('radius.lg', TournamentTokens.radiusLg, 'px'),
            TokenMetricSample('radius.xl', TournamentTokens.radiusXl, 'px'),
            TokenMetricSample('radius.full', TournamentTokens.radiusFull, 'px'),
          ],
          typography: [
            TokenMetricSample(
              'font.size.12',
              TournamentTokens.fontSizeV12,
              'px',
            ),
            TokenMetricSample(
              'font.size.14',
              TournamentTokens.fontSizeV14,
              'px',
            ),
            TokenMetricSample(
              'font.size.16',
              TournamentTokens.fontSizeV16,
              'px',
            ),
            TokenMetricSample(
              'font.size.18',
              TournamentTokens.fontSizeV18,
              'px',
            ),
            TokenMetricSample(
              'font.size.20',
              TournamentTokens.fontSizeV20,
              'px',
            ),
            TokenMetricSample(
              'font.size.24',
              TournamentTokens.fontSizeV24,
              'px',
            ),
            TokenMetricSample(
              'font.size.28',
              TournamentTokens.fontSizeV28,
              'px',
            ),
            TokenMetricSample(
              'font.size.32',
              TournamentTokens.fontSizeV32,
              'px',
            ),
            TokenMetricSample(
              'font.size.40',
              TournamentTokens.fontSizeV40,
              'px',
            ),
            TokenMetricSample(
              'font.size.48',
              TournamentTokens.fontSizeV48,
              'px',
            ),
            TokenMetricSample(
              'font.size.56',
              TournamentTokens.fontSizeV56,
              'px',
            ),
            TokenMetricSample(
              'font.lineHeight.16',
              TournamentTokens.fontLineHeightV16,
              'px',
            ),
            TokenMetricSample(
              'font.lineHeight.20',
              TournamentTokens.fontLineHeightV20,
              'px',
            ),
            TokenMetricSample(
              'font.lineHeight.24',
              TournamentTokens.fontLineHeightV24,
              'px',
            ),
            TokenMetricSample(
              'font.lineHeight.28',
              TournamentTokens.fontLineHeightV28,
              'px',
            ),
            TokenMetricSample(
              'font.lineHeight.32',
              TournamentTokens.fontLineHeightV32,
              'px',
            ),
            TokenMetricSample(
              'font.lineHeight.36',
              TournamentTokens.fontLineHeightV36,
              'px',
            ),
            TokenMetricSample(
              'font.lineHeight.40',
              TournamentTokens.fontLineHeightV40,
              'px',
            ),
            TokenMetricSample(
              'font.lineHeight.48',
              TournamentTokens.fontLineHeightV48,
              'px',
            ),
            TokenMetricSample(
              'font.lineHeight.56',
              TournamentTokens.fontLineHeightV56,
              'px',
            ),
            TokenMetricSample(
              'font.lineHeight.64',
              TournamentTokens.fontLineHeightV64,
              'px',
            ),
            TokenMetricSample(
              'font.weight.regular',
              TournamentTokens.fontWeightRegular,
              '',
            ),
            TokenMetricSample(
              'font.weight.medium',
              TournamentTokens.fontWeightMedium,
              '',
            ),
            TokenMetricSample(
              'font.weight.semibold',
              TournamentTokens.fontWeightSemibold,
              '',
            ),
            TokenMetricSample(
              'font.weight.bold',
              TournamentTokens.fontWeightBold,
              '',
            ),
          ],
          breakpoints: [
            TokenMetricSample(
              'compact.max',
              TournamentTokens.breakpointCompactMax,
              'px',
            ),
            TokenMetricSample(
              'medium.max',
              TournamentTokens.breakpointMediumMax,
              'px',
            ),
            TokenMetricSample(
              'medium.min',
              TournamentTokens.breakpointMediumMin,
              'px',
            ),
            TokenMetricSample(
              'expanded.max',
              TournamentTokens.breakpointExpandedMax,
              'px',
            ),
            TokenMetricSample(
              'expanded.min',
              TournamentTokens.breakpointExpandedMin,
              'px',
            ),
            TokenMetricSample(
              'large.max',
              TournamentTokens.breakpointLargeMax,
              'px',
            ),
            TokenMetricSample(
              'large.min',
              TournamentTokens.breakpointLargeMin,
              'px',
            ),
            TokenMetricSample(
              'xlarge.min',
              TournamentTokens.breakpointXlargeMin,
              'px',
            ),
          ],
          layout: [
            TokenMetricSample(
              'page.compact',
              TournamentTokens.layoutPagePaddingCompact,
              'px',
            ),
            TokenMetricSample(
              'page.minimum',
              TournamentTokens.layoutPagePaddingMinimum,
              'px',
            ),
            TokenMetricSample(
              'page.medium.min',
              TournamentTokens.layoutPagePaddingMediumMin,
              'px',
            ),
            TokenMetricSample(
              'page.medium.max',
              TournamentTokens.layoutPagePaddingMediumMax,
              'px',
            ),
            TokenMetricSample(
              'page.desktop.min',
              TournamentTokens.layoutPagePaddingDesktopMin,
              'px',
            ),
            TokenMetricSample(
              'page.desktop.max',
              TournamentTokens.layoutPagePaddingDesktopMax,
              'px',
            ),
            TokenMetricSample(
              'host.max.min',
              TournamentTokens.layoutHostContentMaxMin,
              'px',
            ),
            TokenMetricSample(
              'host.max.max',
              TournamentTokens.layoutHostContentMaxMax,
              'px',
            ),
            TokenMetricSample(
              'spectator.max.min',
              TournamentTokens.layoutSpectatorContentMaxMin,
              'px',
            ),
            TokenMetricSample(
              'spectator.max.max',
              TournamentTokens.layoutSpectatorContentMaxMax,
              'px',
            ),
          ],
          controls: [
            TokenMetricSample(
              'touch.min',
              TournamentTokens.controlTouchTargetMin,
              'px',
            ),
            TokenMetricSample(
              'touch.preferred',
              TournamentTokens.controlTouchTargetPreferred,
              'px',
            ),
            TokenMetricSample(
              'height.compact.min',
              TournamentTokens.controlHeightCompactMin,
              'px',
            ),
            TokenMetricSample(
              'height.compact.max',
              TournamentTokens.controlHeightCompactMax,
              'px',
            ),
            TokenMetricSample(
              'height.standard.min',
              TournamentTokens.controlHeightStandardMin,
              'px',
            ),
            TokenMetricSample(
              'height.standard.max',
              TournamentTokens.controlHeightStandardMax,
              'px',
            ),
            TokenMetricSample(
              'height.large.min',
              TournamentTokens.controlHeightLargeMin,
              'px',
            ),
            TokenMetricSample(
              'height.large.max',
              TournamentTokens.controlHeightLargeMax,
              'px',
            ),
          ],
          artwork: [
            TokenMetricSample(
              'artwork.size.compact',
              TournamentTokens.artworkSizeCompact,
              'px',
            ),
            TokenMetricSample(
              'artwork.size.standard',
              TournamentTokens.artworkSizeStandard,
              'px',
            ),
            TokenMetricSample(
              'artwork.size.matchup',
              TournamentTokens.artworkSizeMatchup,
              'px',
            ),
            TokenMetricSample(
              'artwork.size.hero',
              TournamentTokens.artworkSizeHero,
              'px',
            ),
          ],
          borders: [
            TokenMetricSample(
              'border.width.base',
              TournamentTokens.borderWidthBase,
              'px',
            ),
          ],
          motion: [
            TokenMetricSample('motion.fast', TournamentTokens.motionFast, 'ms'),
            TokenMetricSample(
              'motion.normal',
              TournamentTokens.motionNormal,
              'ms',
            ),
            TokenMetricSample('motion.slow', TournamentTokens.motionSlow, 'ms'),
            TokenMetricSample(
              'motion.presentation',
              TournamentTokens.motionPresentation,
              'ms',
            ),
          ],
          gap: TournamentTokens.spaceV4,
          swatchSize: TournamentTokens.spaceV12,
          swatchRadius: TournamentTokens.radiusMd,
        ),
      ],
    );
  }

  static const _text = DsTextTheme(
    display: TextStyle(
      color: TournamentTokens.colorTextPrimary,
      fontSize: TournamentTokens.fontSizeV56,
      height: TournamentTokens.fontLineHeightV64 / TournamentTokens.fontSizeV56,
      fontWeight: TournamentTokens.fontWeightBold,
    ),
    heading: TextStyle(
      color: TournamentTokens.colorTextPrimary,
      fontSize: TournamentTokens.fontSizeV32,
      height: TournamentTokens.fontLineHeightV40 / TournamentTokens.fontSizeV32,
      fontWeight: TournamentTokens.fontWeightBold,
    ),
    title: TextStyle(
      color: TournamentTokens.colorTextPrimary,
      fontSize: TournamentTokens.fontSizeV24,
      height: TournamentTokens.fontLineHeightV32 / TournamentTokens.fontSizeV24,
      fontWeight: TournamentTokens.fontWeightSemibold,
    ),
    body: TextStyle(
      color: TournamentTokens.colorTextPrimary,
      fontSize: TournamentTokens.fontSizeV18,
      height: TournamentTokens.fontLineHeightV28 / TournamentTokens.fontSizeV18,
    ),
    secondary: TextStyle(
      color: TournamentTokens.colorTextSecondary,
      fontSize: TournamentTokens.fontSizeV16,
      height: TournamentTokens.fontLineHeightV24 / TournamentTokens.fontSizeV16,
    ),
    label: TextStyle(
      color: TournamentTokens.colorTextPrimary,
      fontSize: TournamentTokens.fontSizeV16,
      height: TournamentTokens.fontLineHeightV20 / TournamentTokens.fontSizeV16,
      fontWeight: TournamentTokens.fontWeightSemibold,
    ),
  );
}
