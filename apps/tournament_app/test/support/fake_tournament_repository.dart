import 'dart:async';

import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/history/domain/entities/tournament_history_summary.dart';
import 'package:tournament_app/features/history/domain/repositories/tournament_history_repository.dart';
import 'package:tournament_app/features/standings/domain/repositories/tournament_completion_repository.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';
import 'package:tournament_app/features/tournament/domain/value_objects/tournament_id.dart';

final class FakeTournamentRepository
    implements
        TournamentRepository,
        TournamentCompletionRepository,
        TournamentHistoryRepository {
  ActiveTournament? activeTournament;
  FinishedTournamentSnapshot? finishedTournament;
  final List<FinishedTournamentSnapshot> finishedTournaments = [];
  TournamentDraft? draft;
  Object? saveError;
  Completer<void>? saveCompleter;
  var saveCalls = 0;
  var draftSaveCalls = 0;
  var activeTournamentSaveCalls = 0;
  var finishedTournamentSaveCalls = 0;

  @override
  Future<FinishedTournamentSnapshot?> getFinishedTournament() async =>
      finishedTournament;

  @override
  Future<void> saveFinishedTournament(
    FinishedTournamentSnapshot snapshot,
  ) async {
    saveCalls += 1;
    finishedTournamentSaveCalls += 1;
    if (saveError case final error?) throw error;
    await saveCompleter?.future;
    finishedTournament = snapshot;
    if (!finishedTournaments.any(
      (item) => item.tournament.draft.id == snapshot.tournament.draft.id,
    )) {
      finishedTournaments.add(snapshot);
    }
    activeTournament = null;
  }

  @override
  Future<List<TournamentHistorySummary>> getHistory() async {
    return [
      for (final (index, snapshot) in finishedTournaments.reversed.indexed)
        TournamentHistorySummary(
          tournamentId: snapshot.tournament.draft.id,
          name: snapshot.tournament.draft.name.value,
          championNickname: snapshot.tournament.draft.participants
              .firstWhere(
                (participant) => participant.id == snapshot.outcome.championId,
              )
              .nickname
              .value,
          championFighterName: _championFighterName(snapshot),
          participantCount: snapshot.tournament.draft.participants.length,
          rulesetId: snapshot.outcome.rulesetId,
          rulesetVersion: snapshot.outcome.rulesetVersion,
          completionOrder: finishedTournaments.length - index,
          format: snapshot.tournament.draft.format,
        ),
    ];
  }

  String _championFighterName(FinishedTournamentSnapshot snapshot) {
    final assignment = snapshot.tournament.setup.fighterAssignments.firstWhere(
      (item) => item.participantId == snapshot.outcome.championId,
    );
    return snapshot.fighterNamesById[assignment.fighterId] ??
        assignment.fighterId.value;
  }

  @override
  Future<FinishedTournamentSnapshot?> getTournamentById(TournamentId id) async {
    for (final snapshot in finishedTournaments) {
      if (snapshot.tournament.draft.id == id) return snapshot;
    }
    return null;
  }

  @override
  Future<TournamentDraft?> getActiveDraft() async => draft;

  @override
  Future<void> saveActiveDraft(TournamentDraft draft) async {
    saveCalls += 1;
    draftSaveCalls += 1;
    if (saveError case final error?) throw error;
    await saveCompleter?.future;
    this.draft = draft;
  }

  @override
  Future<ActiveTournament?> getActiveTournament() async => activeTournament;

  @override
  Future<void> saveActiveTournament(ActiveTournament tournament) async {
    saveCalls += 1;
    activeTournamentSaveCalls += 1;
    if (saveError case final error?) throw error;
    await saveCompleter?.future;
    activeTournament = tournament;
    draft = tournament.draft;
  }
}
