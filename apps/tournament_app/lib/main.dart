import 'package:flutter/material.dart';

import 'app/composition/app_composition.dart';
import 'app/host/tournament_hub_app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final composition = AppComposition.production();
  runApp(TournamentHubApp(runtime: composition));
}
