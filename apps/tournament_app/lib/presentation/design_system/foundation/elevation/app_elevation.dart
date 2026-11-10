import 'package:flutter/material.dart';

class AppElevation extends ThemeExtension<AppElevation> {
  const AppElevation({
    required this.floating,
    required this.sheet,
    required this.dialog,
  });
  final BoxShadow floating;
  final BoxShadow sheet;
  final BoxShadow dialog;
  @override
  AppElevation copyWith({
    BoxShadow? floating,
    BoxShadow? sheet,
    BoxShadow? dialog,
  }) => AppElevation(
    floating: floating ?? this.floating,
    sheet: sheet ?? this.sheet,
    dialog: dialog ?? this.dialog,
  );
  @override
  AppElevation lerp(covariant AppElevation? other, double interpolationAmount) {
    if (other == null) return this;
    return AppElevation(
      floating: BoxShadow.lerp(floating, other.floating, interpolationAmount)!,
      sheet: BoxShadow.lerp(sheet, other.sheet, interpolationAmount)!,
      dialog: BoxShadow.lerp(dialog, other.dialog, interpolationAmount)!,
    );
  }
}
