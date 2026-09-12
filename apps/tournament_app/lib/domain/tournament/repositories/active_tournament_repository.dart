import 'package:tournament_app/domain/tournament/entities/tournament.dart';

abstract interface class ActiveTournamentRepository {
  Future<Tournament?> current();

  Future<void> save(Tournament tournament, {required int expectedRevision});
}
