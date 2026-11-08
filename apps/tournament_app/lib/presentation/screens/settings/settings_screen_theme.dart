import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';

class SettingsScreenTheme extends AppScreenLayoutTheme {
  SettingsScreenTheme.of(super.context) : super.of() {
    heroHeading = desktop
        ? heading.copyWith(fontSize: secondaryHeroSize)
        : heading;
  }
  late final TextStyle heroHeading;
}
