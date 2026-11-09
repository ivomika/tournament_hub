import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen_state.dart';
import 'package:tournament_app/presentation/screens/profile/profile_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/identity/app_identity.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar_size.dart';
import 'package:tournament_app/presentation/design_system/components/metric/app_metric.dart';
import 'package:tournament_app/presentation/design_system/components/navigation_item/app_navigation_item.dart';
import 'package:tournament_app/presentation/design_system/components/button/app_button.dart';
import 'package:tournament_app/presentation/design_system/foundation/icons/app_glyph.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    required this.state,
    required this.onBack,
    required this.onEdit,
    required this.onCreate,
    required this.onRecent,
    required this.onSettings,
    required this.onAbout,
    required this.onContact,
    super.key,
  });
  final ProfileScreenState state;
  final VoidCallback? onBack,
      onEdit,
      onCreate,
      onRecent,
      onSettings,
      onAbout,
      onContact;
  @override
  Widget build(BuildContext context) {
    final t = ProfileScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final statistics = state.statistics, recent = state.recent;
    final identity = Column(
      mainAxisSize: t.desktop ? t.max : t.min,
      mainAxisAlignment: t.desktop ? t.spaceBetween : t.centerMain,
      crossAxisAlignment: t.desktop ? t.start : t.centerCross,
      children: [
        AppAvatar(
          initials: state.initials,
          size: AppAvatarSize.profile,
          shape: t.desktop ? AppAvatarShape.tile : AppAvatarShape.round,
          foreground: t.muted.color,
        ),
        SizedBox(height: t.gap),
        Text(state.name, style: t.name),
      ],
    );
    final achievement = statistics == null
        ? null
        : AppMetric(
            value: statistics.wins,
            label: l.screenWins,
            semanticLabel: l.screenWins,
            kind: AppMetricKind.achievement,
          );
    final tournaments = statistics == null
        ? null
        : AppMetric(
            value: statistics.tournaments,
            label: l.screenTournamentCount,
            semanticLabel: l.screenTournamentCount,
          );
    final matches = statistics == null
        ? null
        : AppMetric(
            value: statistics.matches,
            label: l.screenMatches,
            semanticLabel: l.screenMatches,
          );
    final latest = recent == null
        ? null
        : InkWell(
            onTap: onRecent,
            child: AppScreenTile(
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: t.min,
                          crossAxisAlignment: t.start,
                          children: [
                            Text(l.screenLastTournament, style: t.caption),
                            SizedBox(height: t.small),
                            Text(recent.name, style: t.title),
                            SizedBox(height: t.small),
                            AppIdentity(
                              primary: recent.character,
                              initials: recent.initials,
                              secondary: state.name,
                              size: AppAvatarSize.small,
                            ),
                            SizedBox(height: t.small),
                            Text(recent.date, style: t.caption),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: t.small),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text: recent.place, style: t.accentHero),
                        TextSpan(text: l.screenPlace, style: t.caption),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
    final empty = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.start,
      mainAxisAlignment: t.centerMain,
      children: [
        Text(l.screenAhead, style: t.heading),
        SizedBox(height: t.small),
        Text(l.screenAheadNote, style: t.muted),
        SizedBox(height: t.gap),
        AppButton(
          label: l.screenCreate,
          glyph: AppGlyph.arrow,
          onPressed: onCreate,
        ),
      ],
    );
    final settings = AppNavigationItem(
      label: l.screenSettings,
      glyph: AppGlyph.settings,
      onPressed: onSettings,
    );
    final about = AppNavigationItem(
      label: l.screenAbout,
      glyph: AppGlyph.info,
      onPressed: onAbout,
    );
    final contact = AppNavigationItem(
      label: l.screenContact,
      glyph: AppGlyph.contact,
      onPressed: onContact,
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenProfileTitle,
            backLabel: l.screenBack,
            onBack: onBack,
            action: AppHeaderAction(
              kind: AppHeaderActionKind.edit,
              label: l.screenEditName,
              onPressed: onEdit,
            ),
          ),
          SizedBox(height: t.gap),
          Expanded(
            child: t.desktop
                ? Column(
                    crossAxisAlignment: t.stretch,
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: t.stretch,
                          children: [
                            Expanded(child: AppScreenTile(child: identity)),
                            SizedBox(width: t.gap),
                            Expanded(
                              flex: t.homePrimaryFlex,
                              child: statistics == null
                                  ? AppScreenTile(child: empty)
                                  : Column(
                                      crossAxisAlignment: t.stretch,
                                      children: [
                                        Expanded(
                                          child: Row(
                                            crossAxisAlignment: t.stretch,
                                            children: [
                                              Expanded(
                                                flex: t.homePrimaryFlex,
                                                child: achievement!,
                                              ),
                                              SizedBox(width: t.gap),
                                              Expanded(child: tournaments!),
                                              SizedBox(width: t.gap),
                                              Expanded(child: matches!),
                                            ],
                                          ),
                                        ),
                                        if (latest != null) ...[
                                          SizedBox(height: t.gap),
                                          Expanded(child: latest),
                                        ],
                                      ],
                                    ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: t.gap),
                      SizedBox(
                        height: t.profileLinkHeight,
                        child: Row(
                          crossAxisAlignment: t.stretch,
                          children: [
                            Expanded(child: settings),
                            SizedBox(width: t.gap),
                            Expanded(child: about),
                            SizedBox(width: t.gap),
                            Expanded(child: contact),
                          ],
                        ),
                      ),
                    ],
                  )
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: t.stretch,
                      children: [
                        identity,
                        SizedBox(height: t.gap),
                        if (statistics != null) ...[
                          achievement!,
                          SizedBox(height: t.gap),
                          Row(
                            children: [
                              Expanded(child: tournaments!),
                              SizedBox(width: t.gap),
                              Expanded(child: matches!),
                            ],
                          ),
                        ] else
                          empty,
                        if (latest != null) ...[
                          SizedBox(height: t.gap),
                          latest,
                        ],
                        SizedBox(height: t.gap),
                        settings,
                        about,
                        contact,
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
