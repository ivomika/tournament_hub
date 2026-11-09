import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/widgets/screen_layout/app_screen_layout_theme.dart';

class BracketScreenTheme extends AppScreenLayoutTheme {
  BracketScreenTheme.of(super.context) : super.of();
  Alignment get bottomRight => Alignment(rightAlign.x, bottomAlign.y);
}
