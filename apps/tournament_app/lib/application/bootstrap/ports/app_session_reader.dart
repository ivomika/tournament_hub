import '../models/active_tournament_projection.dart';
import '../models/local_profile_projection.dart';

abstract interface class AppSessionReader {
  Future<void> validateAvailability();

  Future<LocalProfileProjection?> readLocalProfile();

  Future<ActiveTournamentProjection?> readActiveTournament({
    required String localProfileId,
  });
}
