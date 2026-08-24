import 'dart:async';

import 'package:tournament_app/features/tournament/domain/entities/tournament_draft.dart';
import 'package:tournament_app/features/tournament/domain/repositories/tournament_repository.dart';

final class FakeTournamentRepository implements TournamentRepository {
  TournamentDraft? draft;
  Object? saveError;
  Completer<void>? saveCompleter;
  var saveCalls = 0;

  @override
  Future<TournamentDraft?> getActiveDraft() async => draft;

  @override
  Future<void> saveActiveDraft(TournamentDraft draft) async {
    saveCalls += 1;
    if (saveError case final error?) throw error;
    await saveCompleter?.future;
    this.draft = draft;
  }
}
