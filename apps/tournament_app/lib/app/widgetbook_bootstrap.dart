import 'package:flutter/widgets.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';
import 'package:tournament_app/presentation/widgetbook/widgetbook_app.dart';

abstract final class WidgetbookBootstrap {
  static void run() {
    runApp(TournamentWidgetbookApp(theme: AppTheme.dark()));
  }
}
