import 'package:flutter/material.dart';

class AppTableMetrics extends ThemeExtension<AppTableMetrics> {
  const AppTableMetrics({
    required this.trailing,
    required this.verticalAlignment,
  });
  final TextAlign trailing;
  final TableCellVerticalAlignment verticalAlignment;
  @override
  AppTableMetrics copyWith({
    TextAlign? trailing,
    TableCellVerticalAlignment? verticalAlignment,
  }) => AppTableMetrics(
    trailing: trailing ?? this.trailing,
    verticalAlignment: verticalAlignment ?? this.verticalAlignment,
  );
  @override
  AppTableMetrics lerp(covariant AppTableMetrics? other, double t) =>
      other == null
      ? this
      : AppTableMetrics(
          trailing: t < .5 ? trailing : other.trailing,
          verticalAlignment: t < .5
              ? verticalAlignment
              : other.verticalAlignment,
        );
}
