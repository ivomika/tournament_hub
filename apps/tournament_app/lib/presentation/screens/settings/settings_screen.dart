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
    final screenTheme = SettingsScreenTheme.of(context),
        localizations = FoundationLocalizations.of(context);
    final hero = Column(
      mainAxisSize: screenTheme.min,
      mainAxisAlignment: screenTheme.centerMain,
      crossAxisAlignment: screenTheme.start,
      children: [
        Text(localizations.screenSettingsHero, style: screenTheme.heroHeading),
        Text(
          localizations.screenSettingsAccent,
          style: screenTheme.heroHeading,
        ),
      ],
    );
    final appearance = AppSelect(
      label: localizations.screenAppearance,
      options: [
        AppSelectOption(
          value: AppearanceChoice.dark,
          label: localizations.screenDark,
        ),
        AppSelectOption(
          value: AppearanceChoice.light,
          label: localizations.screenLight,
        ),
        AppSelectOption(
          value: AppearanceChoice.system,
          label: localizations.screenSystem,
        ),
      ],
      value: state.appearance,
      sheetDescription: localizations.screenAppearance,
      closeLabel: localizations.screenClose,
      onChanged: onAppearanceChanged,
    );
    final language = AppSelect(
      label: localizations.screenLanguage,
      options: [
        AppSelectOption(
          value: LanguageChoice.russian,
          label: localizations.screenRussian,
        ),
        AppSelectOption(
          value: LanguageChoice.english,
          label: localizations.screenEnglish,
        ),
      ],
      value: state.language,
      sheetDescription: localizations.screenLanguage,
      closeLabel: localizations.screenClose,
      onChanged: onLanguageChanged,
    );
    return AppScreenCanvas(
      child: Column(
        crossAxisAlignment: screenTheme.stretch,
        children: [
          AppSectionHeader(
            title: localizations.screenSettings,
            backLabel: localizations.screenBack,
            onBack: onBack,
          ),
          SizedBox(height: screenTheme.gap),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: screenTheme.stretch,
                children: [
                  if (screenTheme.desktop)
                    SizedBox(
                      height:
                          screenTheme.settingsHeight *
                          screenTheme.textScaleFactor,
                      child: Row(
                        crossAxisAlignment: screenTheme.stretch,
                        children: [
                          Expanded(child: AppScreenTile(child: hero)),
                          SizedBox(width: screenTheme.gap),
                          Expanded(
                            child: Column(
                              children: [
                                Expanded(
                                  child: AppScreenTile(
                                    child: Center(child: appearance),
                                  ),
                                ),
                                SizedBox(height: screenTheme.gap),
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
                    SizedBox(height: screenTheme.gap),
                    appearance,
                    SizedBox(height: screenTheme.gap),
                    language,
                  ],
                  SizedBox(height: screenTheme.gap),
                  AppScreenTile(
                    child: Column(
                      crossAxisAlignment: screenTheme.start,
                      children: [
                        Text(
                          localizations.screenSettingsNote,
                          style: screenTheme.caption,
                        ),
                        SizedBox(height: screenTheme.small),
                        Text(
                          localizations.screenSettingsTournamentNote,
                          style: screenTheme.muted,
                        ),
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
