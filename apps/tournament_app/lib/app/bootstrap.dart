import 'package:flutter/widgets.dart';
import 'package:tournament_app/app/tournament_app.dart';
import 'package:tournament_app/presentation/design_system/foundation/theme/app_theme.dart';

abstract final class AppBootstrap {
  static void run() => runApp(TournamentApp(theme: AppTheme.dark()));
}
