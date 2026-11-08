import 'package:flutter/foundation.dart';

enum AppearanceChoice { dark, light, system }

enum LanguageChoice { russian, english }

@immutable
class SettingsScreenState {
  const SettingsScreenState({required this.appearance, required this.language});
  final AppearanceChoice appearance;
  final LanguageChoice language;
}
