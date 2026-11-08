import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';

class ProfileScreenTheme extends AppScreenLayoutTheme {
  ProfileScreenTheme.of(super.context) : super.of() {
    name = desktop ? heading.copyWith(fontSize: profileNameSize) : heading;
  }
  late final TextStyle name;
}
