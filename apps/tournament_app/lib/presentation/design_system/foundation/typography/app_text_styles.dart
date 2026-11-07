import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_type_roles.dart';
import 'package:tournament_app/presentation/design_system/foundation/typography/app_text_metrics.dart';

/// Runtime semantic roles; all source values originate in the current main theme.
class AppTextStyles {
  const AppTextStyles(this.theme);
  final ThemeData theme;
  AppTypeRoles get _roles => theme.extension<AppTypeRoles>()!;
  TextStyle get display => theme.textTheme.displayLarge!;
  TextStyle get heading => theme.textTheme.headlineLarge!;
  TextStyle get title => _roles.interfaceStyle(theme.textTheme.titleLarge!);
  TextStyle get bodyLarge => _interface(theme.textTheme.bodyLarge!);
  TextStyle get body => _interface(theme.textTheme.bodyMedium!);
  TextStyle get label => _interface(theme.textTheme.labelLarge!);
  TextStyle get caption => _interface(theme.textTheme.bodySmall!);
  TextStyle get score => _roles.score;
  TextStyle get compactHeader => _interface(
    theme.textTheme.labelLarge!.copyWith(
      height: theme.extension<AppTextMetrics>()!.compactHeaderLine,
    ),
  );
  TextStyle get comfortableHeader => _interface(
    theme.textTheme.labelLarge!.copyWith(
      fontSize: theme.textTheme.bodyLarge!.fontSize,
      height: theme.extension<AppTextMetrics>()!.comfortableHeaderLine,
    ),
  );
  TextStyle _interface(TextStyle value) => _roles.interfaceStyle(value);
}
