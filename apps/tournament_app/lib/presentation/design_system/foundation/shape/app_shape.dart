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
  AppShape lerp(covariant AppShape? other, double t) {
    if (other == null) return this;
    return AppShape(
      control: BorderRadius.lerp(control, other.control, t)!,
      nested: BorderRadius.lerp(nested, other.nested, t)!,
      desktopSurface: BorderRadius.lerp(
        desktopSurface,
        other.desktopSurface,
        t,
      )!,
      avatarTile: BorderRadius.lerp(avatarTile, other.avatarTile, t)!,
      surface: BorderRadius.lerp(surface, other.surface, t)!,
      panel: BorderRadius.lerp(panel, other.panel, t)!,
      pill: BorderRadius.lerp(pill, other.pill, t)!,
      sheet: BorderRadius.lerp(sheet, other.sheet, t)!,
    );
  }
}
