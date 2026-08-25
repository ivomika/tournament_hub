import 'package:flutter/widgets.dart';
import 'package:tournament_app/app/tournament_hub_app.dart';
import 'package:tournament_app/core/common/data/uuid_id_generator.dart';
import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/features/profile/data/repositories/drift_local_profile_repository.dart';
import 'package:tournament_app/features/tournament/data/repositories/drift_tournament_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  final tournamentRepository = DriftTournamentRepository(database);
  runApp(
    TournamentHubApp(
      profileRepository: DriftLocalProfileRepository(database),
      tournamentRepository: tournamentRepository,
      tournamentCompletionRepository: tournamentRepository,
      idGenerator: const UuidIdGenerator(),
    ),
  );
}
