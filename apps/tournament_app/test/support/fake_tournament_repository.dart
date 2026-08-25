import 'dart:async';

import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/standings/domain/repositories/tournament_completion_repository.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';

final class FakeTournamentRepository
    implements TournamentRepository, TournamentCompletionRepository {
  ActiveTournament? activeTournament;
  FinishedTournamentSnapshot? finishedTournament;
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
    activeTournament = null;
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
