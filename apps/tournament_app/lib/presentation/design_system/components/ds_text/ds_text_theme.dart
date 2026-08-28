import 'package:flutter/material.dart';

class DsTextTheme extends ThemeExtension<DsTextTheme> {
  const DsTextTheme({
    required this.display,
    required this.heading,
    required this.title,
    required this.body,
    required this.secondary,
    required this.label,
  });

  final TextStyle display;
  final TextStyle heading;
  final TextStyle title;
  final TextStyle body;
  final TextStyle secondary;
  final TextStyle label;

  @override
  DsTextTheme copyWith({
    TextStyle? display,
    TextStyle? heading,
    TextStyle? title,
    TextStyle? body,
    TextStyle? secondary,
    TextStyle? label,
  }) {
    return DsTextTheme(
      display: display ?? this.display,
      heading: heading ?? this.heading,
      title: title ?? this.title,
      body: body ?? this.body,
      secondary: secondary ?? this.secondary,
      label: label ?? this.label,
    );
  }

  @override
  DsTextTheme lerp(covariant DsTextTheme? other, double t) {
    if (other == null) return this;
    return DsTextTheme(
      display: TextStyle.lerp(display, other.display, t)!,
      heading: TextStyle.lerp(heading, other.heading, t)!,
      title: TextStyle.lerp(title, other.title, t)!,
      body: TextStyle.lerp(body, other.body, t)!,
      secondary: TextStyle.lerp(secondary, other.secondary, t)!,
      label: TextStyle.lerp(label, other.label, t)!,
    );
  }
}
