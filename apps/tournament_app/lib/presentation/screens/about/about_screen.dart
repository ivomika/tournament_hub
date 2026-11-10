import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/screens/about/about_screen_state.dart';
import 'package:tournament_app/presentation/screens/about/about_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/widgets/disclosure/app_disclosure.dart';
import 'package:tournament_app/presentation/design_system/components/avatar/app_avatar.dart';
import 'package:tournament_app/presentation/design_system/components/surface/app_surface.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({
    required this.state,
    required this.onBack,
    required this.onToggleRules,
    super.key,
  });
  final AboutScreenState state;
  final VoidCallback? onBack, onToggleRules;
  @override
  Widget build(BuildContext context) {
    final appearance = AboutScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final hero = Column(
      mainAxisSize: appearance.min,
      crossAxisAlignment: appearance.start,
      mainAxisAlignment: appearance.centerMain,
      children: [
        AppAvatar(initials: localizations.screenAboutMark),
        SizedBox(height: appearance.gap),
        Text(localizations.screenAboutProduct, style: appearance.heading),
        Text(
          localizations.screenAboutAccent,
          style: appearance.heading.copyWith(
            color: appearance.accentHero.color,
          ),
        ),
        SizedBox(height: appearance.gap),
        Text(localizations.screenAboutDescription, style: appearance.caption),
      ],
    );
    final version = Text(state.version, style: appearance.caption);
    final rules = AppDisclosure(
      title: localizations.screenRules,
      expanded: state.rulesExpanded,
      onToggle: onToggleRules,
      child: Text(localizations.screenRulesCopy, style: appearance.body),
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: appearance.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenAbout,
            backLabel: localizations.screenBack,
            onBack: onBack,
          ),
          SizedBox(height: appearance.gap),
          Expanded(
            child: SingleChildScrollView(
              child: appearance.desktop
                  ? SizedBox(
                      height: appearance.aboutHeight,
                      child: Row(
                        crossAxisAlignment: appearance.stretch,
                        children: [
                          Expanded(
                            flex: appearance.primaryFlex,
                            child: AppScreenTile(child: hero),
                          ),
                          SizedBox(width: appearance.gap),
                          Expanded(
                            flex: appearance.secondaryFlex,
                            child: Column(
                              crossAxisAlignment: appearance.stretch,
                              children: [
                                SizedBox(
                                  height: appearance.aboutVersionHeight,
                                  child: AppScreenTile(
                                    child: Center(child: version),
                                  ),
                                ),
                                SizedBox(height: appearance.gap),
                                SizedBox(
                                  height: appearance.aboutRulesHeight,
                                  child: AppScreenTile(
                                    child: SingleChildScrollView(child: rules),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: appearance.stretch,
                      children: [
                        hero,
                        SizedBox(height: appearance.gap),
                        AppSurface(
                          child: Column(
                            crossAxisAlignment: appearance.stretch,
                            children: [
                              version,
                              SizedBox(height: appearance.gap),
                              rules,
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
