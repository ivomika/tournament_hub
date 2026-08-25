import 'package:flutter/widgets.dart';
import 'package:tournament_app/app/tournament_hub_app.dart';
import 'package:tournament_app/core/common/data/uuid_id_generator.dart';
import 'package:tournament_app/core/database/app_database.dart';
import 'package:tournament_app/core/server/dart_io_spectator_server.dart';
import 'package:tournament_app/features/fighters/data/repositories/mk11_ultimate_fighter_registry.dart';
import 'package:tournament_app/features/profile/data/repositories/drift_local_profile_repository.dart';
import 'package:tournament_app/features/spectator/application/spectator_host_controller.dart';
import 'package:tournament_app/features/spectator/data/mappers/spectator_snapshot_mapper.dart';
import 'package:tournament_app/features/tournament/data/repositories/drift_tournament_repository.dart';
import 'package:tournament_app/features/tournament/data/repositories/drift_double_elimination_tournament_repository.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final database = AppDatabase();
  final tournamentRepository = DriftTournamentRepository(database);
  final fighterRegistry = Mk11UltimateFighterRegistry();
  final spectatorHostController = SpectatorHostController(
    DartIoSpectatorServer(),
    SpectatorSnapshotMapper(fighterRegistry),
  );
  runApp(
    TournamentHubApp(
      profileRepository: DriftLocalProfileRepository(database),
      tournamentRepository: tournamentRepository,
      tournamentCompletionRepository: tournamentRepository,
      tournamentHistoryRepository: tournamentRepository,
      doubleEliminationTournamentRepository:
          DriftDoubleEliminationTournamentRepository(database),
      idGenerator: const UuidIdGenerator(),
      fighterRegistry: fighterRegistry,
      spectatorHostController: spectatorHostController,
    ),
  );
}
