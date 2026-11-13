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
import 'package:tournament_app/presentation/design_system/components/navigation_item/app_navigation_item.dart';
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
    final appearance = ProfileScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final recent = state.recent;
    final identity = Column(
      mainAxisSize: appearance.desktop ? appearance.max : appearance.min,
      mainAxisAlignment: appearance.centerMain,
      crossAxisAlignment: appearance.centerCross,
      children: [
        AppAvatar(
          initials: state.initials,
          size: AppAvatarSize.profile,
          shape: appearance.desktop
              ? AppAvatarShape.tile
              : AppAvatarShape.round,
          foreground: appearance.muted.color,
        ),
        SizedBox(height: appearance.gap),
        Text(state.name, style: appearance.name),
      ],
    );
    Widget? latest;
    if (recent != null) {
      latest = ClipRRect(
        borderRadius: appearance.recentRadius,
        child: Material(
          color: appearance.desktop
              ? appearance.surface
              : appearance.background,
          child: InkWell(
            hoverColor: appearance.recentHover,
            highlightColor: appearance.recentHover,
            borderRadius: appearance.recentRadius,
            onTap: onRecent,
            child: Padding(
              padding: appearance.tileInset,
              child: Row(
                children: [
                  Expanded(
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: appearance.min,
                          crossAxisAlignment: appearance.start,
                          children: [
                            Text(
                              localizations.screenLastTournament,
                              style: appearance.caption,
                            ),
                            SizedBox(height: appearance.small),
                            Text(recent.name, style: appearance.title),
                            SizedBox(height: appearance.small),
                            AppIdentity(
                              primary: recent.character,
                              initials: recent.initials,
                              secondary: state.name,
                              size: AppAvatarSize.small,
                            ),
                            SizedBox(height: appearance.small),
                            Text(recent.date, style: appearance.caption),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: appearance.small),
                  Column(
                    mainAxisSize: appearance.min,
                    children: [
                      Text(recent.place, style: appearance.accentHero),
                      Text(
                        localizations.screenPlace,
                        style: appearance.caption,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    final settings = AppNavigationItem(
      label: localizations.screenSettings,
      glyph: AppGlyph.settings,
      onPressed: onSettings,
    );
    final about = AppNavigationItem(
      label: localizations.screenAbout,
      glyph: AppGlyph.info,
      onPressed: onAbout,
    );
    final contact = AppNavigationItem(
      label: localizations.screenContact,
      glyph: AppGlyph.contact,
      onPressed: onContact,
    );
    final Widget? responsiveContent;
    if (appearance.desktop) {
      responsiveContent = Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: appearance.stretch,
              children: [
                Expanded(child: AppScreenTile(child: identity)),
                if (latest != null) ...[
                  SizedBox(width: appearance.gap),
                  Expanded(child: latest),
                ],
              ],
            ),
          ),
          SizedBox(height: appearance.gap),
          SizedBox(
            height: appearance.profileLinkHeight,
            child: Row(
              crossAxisAlignment: appearance.stretch,
              children: [
                Expanded(child: settings),
                SizedBox(width: appearance.gap),
                Expanded(child: about),
                SizedBox(width: appearance.gap),
                Expanded(child: contact),
              ],
            ),
          ),
        ],
      );
    } else {
      responsiveContent = SingleChildScrollView(
        child: Column(
          crossAxisAlignment: appearance.stretch,
          children: [
            identity,
            SizedBox(height: appearance.gap),
            if (latest != null) ...[SizedBox(height: appearance.gap), latest],
            SizedBox(height: appearance.gap),
            settings,
            about,
            contact,
          ],
        ),
      );
    }
    return AppScreenCanvas(
      scrollDesktop: true,
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenProfileTitle,
            backLabel: localizations.screenBack,
            onBack: onBack,
            action: AppHeaderAction(
              kind: AppHeaderActionKind.edit,
              label: localizations.screenEditName,
              onPressed: onEdit,
            ),
          ),
          SizedBox(height: appearance.gap),
          Expanded(child: responsiveContent),
        ],
      ),
    );
  }
}
