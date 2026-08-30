import '../../application/bootstrap/models/active_tournament_projection.dart';
import '../../application/bootstrap/models/local_profile_projection.dart';
import '../../application/bootstrap/ports/app_session_reader.dart';

/// Transitional adapter until the persistent profile/session reader is wired.
final class EmptyAppSessionReader implements AppSessionReader {
  const EmptyAppSessionReader();

  @override
  Future<void> validateAvailability() async {}

  @override
  Future<LocalProfileProjection?> readLocalProfile() async => null;

  @override
  Future<ActiveTournamentProjection?> readActiveTournament({
    required String localProfileId,
  }) async => null;
}
