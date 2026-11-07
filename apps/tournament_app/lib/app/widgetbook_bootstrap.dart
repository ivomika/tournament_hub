import 'package:flutter/widgets.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/widgetbook_app.dart';

void bootstrapWidgetbook() {
  runApp(TournamentWidgetbookApp(theme: AppTheme.dark()));
}
