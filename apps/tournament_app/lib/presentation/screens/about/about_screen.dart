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
    final t = AboutScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final hero = Column(
      mainAxisSize: t.min,
      crossAxisAlignment: t.start,
      mainAxisAlignment: t.centerMain,
      children: [
        AppAvatar(initials: l.screenAboutMark),
        SizedBox(height: t.gap),
        Text(l.screenAboutProduct, style: t.heading),
        Text(
          l.screenAboutAccent,
          style: t.heading.copyWith(color: t.accentHero.color),
        ),
        SizedBox(height: t.gap),
        Text(l.screenAboutDescription, style: t.caption),
      ],
    );
    final version = Text(state.version, style: t.caption);
    final rules = AppDisclosure(
      title: l.screenRules,
      expanded: state.rulesExpanded,
      onToggle: onToggleRules,
      child: Text(l.screenRulesCopy, style: t.body),
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenAbout,
            backLabel: l.screenBack,
            onBack: onBack,
          ),
          SizedBox(height: t.gap),
          Expanded(
            child: SingleChildScrollView(
              child: t.desktop
                  ? SizedBox(
                      height: t.aboutHeight,
                      child: Row(
                        crossAxisAlignment: t.stretch,
                        children: [
                          Expanded(
                            flex: t.primaryFlex,
                            child: AppScreenTile(child: hero),
                          ),
                          SizedBox(width: t.gap),
                          Expanded(
                            flex: t.secondaryFlex,
                            child: Column(
                              crossAxisAlignment: t.stretch,
                              children: [
                                SizedBox(
                                  height: t.aboutVersionHeight,
                                  child: AppScreenTile(
                                    child: Center(child: version),
                                  ),
                                ),
                                SizedBox(height: t.gap),
                                SizedBox(
                                  height: t.aboutRulesHeight,
                                  child: AppScreenTile(child: rules),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  : Column(
                      crossAxisAlignment: t.stretch,
                      children: [
                        hero,
                        SizedBox(height: t.gap),
                        AppSurface(
                          child: Column(
                            crossAxisAlignment: t.stretch,
                            children: [
                              version,
                              SizedBox(height: t.gap),
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
