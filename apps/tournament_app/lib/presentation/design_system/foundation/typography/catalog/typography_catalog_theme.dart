import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/app_foundation.dart';
import 'package:tournament_app/presentation/design_system/foundation/colors/app_colors.dart';
import 'package:tournament_app/presentation/design_system/foundation/layout/foundation_layout.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_typography.dart';

class TypographyCatalogTheme {
  const TypographyCatalogTheme(this.foundation);

  final AppFoundation foundation;

  AppColors get colors => foundation.colors;
  FoundationLayout get layout => foundation.layout;
  TextStyle get heading =>
      AppTypography.heading.copyWith(color: colors.textPrimary);
  TextStyle get description =>
      AppTypography.body.copyWith(color: colors.textSecondary);
  TextStyle get label => AppTypography.label.copyWith(color: colors.accent);
  TextStyle get details =>
      AppTypography.caption.copyWith(color: colors.textSecondary);
  TextStyle sampleStyle(TextStyle base) =>
      base.copyWith(color: colors.textPrimary);
}
