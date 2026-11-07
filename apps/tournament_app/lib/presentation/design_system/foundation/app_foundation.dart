import 'package:flutter/material.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';

/// Compatibility assembly facade. Не используется внутри production widgets.
class AppFoundation {
  const AppFoundation.dark();
  ThemeData get materialTheme => AppTheme.dark();
}
