import 'package:flutter_test/flutter_test.dart';
import 'package:tournament_hub_app/application/history/history_service.dart';
import 'package:tournament_hub_app/application/tournament/host_tournament_service.dart';
import 'package:tournament_hub_app/application/tournament/models/host_tournament_session.dart';
import 'package:tournament_hub_app/domain/game/fighter.dart';
import 'package:tournament_hub_app/domain/game/game_definition.dart';
import 'package:tournament_hub_app/domain/profile/local_profile.dart';
import 'package:tournament_hub_app/domain/tournament/engine/tournament_engines.dart';
import 'package:tournament_hub_app/infrastructure/database/tournament_hub_database.dart'
    hide LocalProfile;
import 'package:tournament_hub_app/infrastructure/persistence/drift_active_tournament_store.dart';
import 'package:tournament_hub_app/infrastructure/persistence/drift_tournament_history_store.dart';

void main() {
  late TournamentHubDatabase database;
  late HostTournamentService tournaments;
  late HistoryService history;
  var id = 0;
  final profile = LocalProfile(id: 'profile-1', nickname: 'Host');

  setUp(() {
    database = TournamentHubDatabase.memory();
    final historyStore = DriftTournamentHistoryStore(database);
    final engines = createTournamentFormatEngineRegistryV1();
    tournaments = HostTournamentService(
      DriftActiveTournamentStore(database),
      historyStore,
      engines,
      _game(),
      () => DateTime.utc(2026, 8, 30, 12, 0, id),
      (prefix) => '$prefix-${++id}',
    );
    history = HistoryService(historyStore, engines);
  });

  tearDown(() => database.close());

  test(
    'history изолирована и исключает technical results из win rate',
    () async {
      var technical = await _runningTournament(tournaments, profile);
      final technicalGuest = technical.tournament.participants.singleWhere(
        (participant) => participant.profileId == null,
      );
      technical = await tournaments.withdraw(
        technical,
        participantId: technicalGuest.id,
      );
      await tournaments.finish(technical);

      var normal = await _runningTournament(tournaments, profile);
      final normalMatch = normal.engineState!.currentMatch!;
      final profileParticipant = normal.tournament.participants.singleWhere(
        (participant) => participant.profileId == profile.id,
      );
      final loser = profileParticipant.id == normalMatch.firstParticipantId
          ? normalMatch.secondParticipantId
          : normalMatch.firstParticipantId;
      normal = await tournaments.submitResult(
        normal,
        result: NormalMatchResult(
          winnerId: profileParticipant.id,
          loserId: loser,
          winnerScore: normalMatch.firstTo,
          loserScore: 0,
        ),
      );
      await tournaments.finish(normal);

      var cancelled = await _runningTournament(tournaments, profile);
      final cancelledGuest = cancelled.tournament.participants.singleWhere(
        (participant) => participant.profileId == null,
      );
      cancelled = await tournaments.withdraw(
        cancelled,
        participantId: cancelledGuest.id,
      );
      await tournaments.cancel(cancelled, reason: 'Нет игроков');

      final projection = await history.read(localProfileId: profile.id);
      expect(projection.entries, hasLength(3));
      expect(projection.entries.first.tournament.lifecycle, 'cancelled');
      expect(projection.entries.first.tournament.championId, isNull);
      expect(projection.statistics.tournamentCount, 2);
      expect(projection.statistics.tournamentWins, 2);
      expect(projection.statistics.normalMatchCount, 1);
      expect(projection.statistics.normalMatchWins, 1);
      expect(projection.statistics.normalMatchWinRate, 1);
      expect(projection.statistics.bestPlace, 1);
      expect(projection.statistics.recentTournamentIds, hasLength(3));

      await tournaments.createDraft(
        profile: profile,
        title: 'Active survives clear',
        formatId: 'round-robin',
      );
      await history.clear();
      expect((await history.read(localProfileId: profile.id)).entries, isEmpty);
      expect(await tournaments.loadActive(), isNotNull);
    },
  );

  test('history восстанавливает RR points из результатов матчей', () async {
    var session = await _runningTournament(
      tournaments,
      profile,
      formatId: 'round-robin',
    );
    final match = session.engineState!.currentMatch!;
    session = await tournaments.submitResult(
      session,
      result: NormalMatchResult(
        winnerId: match.firstParticipantId,
        loserId: match.secondParticipantId,
        winnerScore: match.firstTo,
        loserScore: 1,
      ),
    );
    await tournaments.finish(session);

    final tournament = (await history.read(localProfileId: profile.id))
        .entries
        .single
        .tournament;
    expect(tournament.standings, hasLength(2));
    expect(
      tournament.standings
          .singleWhere(
            (standing) =>
                standing.participantId == match.firstParticipantId.value,
          )
          .points,
      2,
    );
    expect(
      tournament.standings
          .singleWhere(
            (standing) =>
                standing.participantId == match.secondParticipantId.value,
          )
          .points,
      1,
    );
  });
}

Future<HostTournamentSession> _runningTournament(
  HostTournamentService service,
  LocalProfile profile, {
  String formatId = 'single-elimination',
}) async {
  var session = await service.createDraft(
    profile: profile,
    title: 'Cup',
    formatId: formatId,
  );
  session = await service.open(session);
  session = await service.addLocalProfile(session, profile: profile);
  session = await service.addGuest(session, nickname: 'Guest');
  session = await service.startDistribution(session, assignmentSeed: 1);
  return service.startRunning(session, bracketSeed: 1);
}

GameDefinition _game() => GameDefinition(
  gameId: 'mk11-ultimate',
  rosterName: 'Test roster',
  fighters: [
    for (var index = 0; index < 4; index++)
      Fighter(
        id: FighterId('fighter-$index'),
        displayName: 'Fighter $index',
        assetPath: 'assets/fighters/fighter-$index.png',
      ),
  ],
);
