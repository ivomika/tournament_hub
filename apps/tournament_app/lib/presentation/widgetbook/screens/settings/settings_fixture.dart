import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/screens/settings/settings_screen.dart';
import 'package:tournament_app/presentation/screens/settings/settings_screen_state.dart';

class SettingsFixture extends StatelessWidget {
  const SettingsFixture({super.key});
  static void action() {}
  static void appearance(AppearanceChoice value) {}
  static void language(LanguageChoice value) {}
  @override
  Widget build(BuildContext context) => SettingsScreen(
    state: const SettingsScreenState(
      appearance: AppearanceChoice.dark,
      language: LanguageChoice.russian,
    ),
    onBack: action,
    onAppearanceChanged: appearance,
    onLanguageChanged: language,
  );
}
