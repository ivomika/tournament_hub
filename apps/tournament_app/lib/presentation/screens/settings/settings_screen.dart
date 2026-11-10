import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/l10n/generated/foundation_localizations.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout.dart';
import 'package:tournament_app/presentation/screens/settings/settings_screen_state.dart';
import 'package:tournament_app/presentation/screens/settings/settings_screen_theme.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_canvas.dart';
import 'package:tournament_app/presentation/design_system/widgets/section_header/app_section_header.dart';
import 'package:tournament_app/presentation/design_system/components/select/app_select.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.state,
    required this.onBack,
    required this.onAppearanceChanged,
    required this.onLanguageChanged,
    super.key,
  });
  final SettingsScreenState state;
  final VoidCallback? onBack;
  final ValueChanged<AppearanceChoice>? onAppearanceChanged;
  final ValueChanged<LanguageChoice>? onLanguageChanged;
  @override
  Widget build(BuildContext context) {
    final t = SettingsScreenTheme.of(context),
        l = FoundationLocalizations.of(context);
    final hero = Column(
      mainAxisSize: t.min,
      mainAxisAlignment: t.centerMain,
      crossAxisAlignment: t.start,
      children: [
        Text(l.screenSettingsHero, style: t.heroHeading),
        Text(l.screenSettingsAccent, style: t.heroHeading),
      ],
    );
    final appearance = AppSelect(
      label: l.screenAppearance,
      options: [
        AppSelectOption(value: AppearanceChoice.dark, label: l.screenDark),
        AppSelectOption(value: AppearanceChoice.light, label: l.screenLight),
        AppSelectOption(value: AppearanceChoice.system, label: l.screenSystem),
      ],
      value: state.appearance,
      sheetDescription: l.screenAppearance,
      closeLabel: l.screenClose,
      onChanged: onAppearanceChanged,
    );
    final language = AppSelect(
      label: l.screenLanguage,
      options: [
        AppSelectOption(value: LanguageChoice.russian, label: l.screenRussian),
        AppSelectOption(value: LanguageChoice.english, label: l.screenEnglish),
      ],
      value: state.language,
      sheetDescription: l.screenLanguage,
      closeLabel: l.screenClose,
      onChanged: onLanguageChanged,
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: t.stretch,
        children: [
          AppSectionHeader(
            title: l.screenSettings,
            backLabel: l.screenBack,
            onBack: onBack,
          ),
          SizedBox(height: t.gap),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: t.stretch,
                children: [
                  if (t.desktop)
                    SizedBox(
                      height: t.settingsHeight * t.textScaleFactor,
                      child: Row(
                        crossAxisAlignment: t.stretch,
                        children: [
                          Expanded(child: AppScreenTile(child: hero)),
                          SizedBox(width: t.gap),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: AppScreenTile(
                                    child: Center(child: appearance),
                                  ),
                                ),
                                SizedBox(height: t.gap),
                                Expanded(
                                  child: AppScreenTile(
                                    child: Center(child: language),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  else ...[
                    hero,
                    SizedBox(height: t.gap),
                    appearance,
                    SizedBox(height: t.gap),
                    language,
                  ],
                  SizedBox(height: t.gap),
                  AppScreenTile(
                    child: Column(
                      crossAxisAlignment: t.start,
                      children: [
                        Text(l.screenSettingsNote, style: t.caption),
                        SizedBox(height: t.small),
                        Text(l.screenSettingsTournamentNote, style: t.muted),
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
