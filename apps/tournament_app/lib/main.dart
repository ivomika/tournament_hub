import 'package:flutter/widgets.dart';
import 'package:tournament_app/app/tournament_hub_app.dart';
import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/profile/data/repositories/drift_local_profile_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  runApp(
    TournamentHubApp(profileRepository: DriftLocalProfileRepository(database)),
  );
}
