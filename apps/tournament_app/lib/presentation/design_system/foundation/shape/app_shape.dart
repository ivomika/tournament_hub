import 'package:flutter/material.dart';

class AppShape extends ThemeExtension<AppShape> {
  const AppShape({
    required this.control,
    required this.nested,
    required this.desktopSurface,
    required this.avatarTile,
    required this.surface,
    required this.panel,
    required this.pill,
    required this.sheet,
  });
  final BorderRadius control;
  final BorderRadius nested;
  final BorderRadius desktopSurface;
  final BorderRadius avatarTile;
  final BorderRadius surface;
  final BorderRadius panel;
  final BorderRadius pill;
  final BorderRadius sheet;
  @override
  AppShape copyWith({
    BorderRadius? control,
    BorderRadius? nested,
    BorderRadius? desktopSurface,
    BorderRadius? avatarTile,
    BorderRadius? surface,
    BorderRadius? panel,
    BorderRadius? pill,
    BorderRadius? sheet,
  }) => AppShape(
    control: control ?? this.control,
    nested: nested ?? this.nested,
    desktopSurface: desktopSurface ?? this.desktopSurface,
    avatarTile: avatarTile ?? this.avatarTile,
    surface: surface ?? this.surface,
    panel: panel ?? this.panel,
    pill: pill ?? this.pill,
    sheet: sheet ?? this.sheet,
  );
  @override
  AppShape lerp(covariant AppShape? other, double interpolationAmount) {
    if (other == null) return this;
    return AppShape(
      control: BorderRadius.lerp(control, other.control, interpolationAmount)!,
      nested: BorderRadius.lerp(nested, other.nested, interpolationAmount)!,
      desktopSurface: BorderRadius.lerp(
        desktopSurface,
        other.desktopSurface,
        interpolationAmount,
      )!,
      avatarTile: BorderRadius.lerp(
        avatarTile,
        other.avatarTile,
        interpolationAmount,
      )!,
      surface: BorderRadius.lerp(surface, other.surface, interpolationAmount)!,
      panel: BorderRadius.lerp(panel, other.panel, interpolationAmount)!,
      pill: BorderRadius.lerp(pill, other.pill, interpolationAmount)!,
      sheet: BorderRadius.lerp(sheet, other.sheet, interpolationAmount)!,
    );
  }
}
