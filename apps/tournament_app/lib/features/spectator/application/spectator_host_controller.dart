import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:tournament_app/core/networking/spectator_envelope.dart';
import 'package:tournament_app/core/server/spectator_server.dart';
import 'package:tournament_app/features/spectator/application/spectator_publisher.dart';
import 'package:tournament_app/features/spectator/data/mappers/spectator_snapshot_mapper.dart';
import 'package:tournament_app/features/standings/domain/entities/finished_tournament_snapshot.dart';
import 'package:tournament_app/features/standings/domain/entities/tournament_outcome.dart';
import 'package:tournament_app/features/tournament/domain/entities/active_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/double_elimination_tournament.dart';
import 'package:tournament_app/features/tournament/domain/entities/finished_double_elimination_snapshot.dart';

final class SpectatorHostController extends ChangeNotifier
    implements SpectatorPublisher {
  SpectatorHostController(this._server, this._mapper);

  final SpectatorServer _server;
  final SpectatorSnapshotMapper _mapper;

  StreamSubscription<int>? _clientCountSubscription;
  Uri? _publicUri;
  String? _errorMessage;
  int _clientCount = 0;
  int _revision = 0;
  bool _isStarting = false;

  Uri? get publicUri => _publicUri;
  String? get errorMessage => _errorMessage;
  int get clientCount => _clientCount;
  bool get isStarting => _isStarting;
  bool get isRunning => _publicUri != null;

  Future<void> start() async {
    if (_isStarting || isRunning) return;
    _isStarting = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _publicUri = await _server.start();
      _clientCount = _server.clientCount;
      _clientCountSubscription ??= _server.clientCountChanges.listen((count) {
        _clientCount = count;
        notifyListeners();
      });
    } on Object catch (error, stackTrace) {
      debugPrint('Не удалось запустить Spectator Host: $error\n$stackTrace');
      _errorMessage = 'Не удалось запустить Spectator в локальной сети.';
    } finally {
      _isStarting = false;
      notifyListeners();
    }
  }

  @override
  Future<void> publishRoundRobin(
    ActiveTournament tournament,
    TournamentOutcome outcome,
  ) {
    return _publish(
      tournament.draft.id.value,
      _mapper.activeRoundRobin(tournament, outcome),
    );
  }

  @override
  Future<void> publishFinishedRoundRobin(FinishedTournamentSnapshot snapshot) {
    return _publish(
      snapshot.tournament.draft.id.value,
      _mapper.finishedRoundRobin(snapshot),
    );
  }

  @override
  Future<void> publishDoubleElimination(
    DoubleEliminationTournament tournament,
  ) {
    return _publish(
      tournament.draft.id.value,
      _mapper.activeDoubleElimination(tournament),
    );
  }

  @override
  Future<void> publishFinishedDoubleElimination(
    FinishedDoubleEliminationSnapshot snapshot,
  ) {
    return _publish(
      snapshot.tournament.draft.id.value,
      _mapper.finishedDoubleElimination(snapshot),
    );
  }

  Future<void> _publish(
    String tournamentId,
    Map<String, Object?> payload,
  ) async {
    try {
      await _server.publish(
        SpectatorEnvelope(
          tournamentId: tournamentId,
          revision: ++_revision,
          payload: payload,
        ).encode(),
      );
    } on Object catch (error, stackTrace) {
      debugPrint(
        'Не удалось опубликовать spectator snapshot: $error\n$stackTrace',
      );
      _errorMessage = 'Spectator временно не получает обновления.';
      notifyListeners();
    }
  }

  Future<void> stop() async {
    await _clientCountSubscription?.cancel();
    _clientCountSubscription = null;
    await _server.stop();
    _publicUri = null;
    _clientCount = 0;
  }

  @override
  void dispose() {
    unawaited(stop());
    super.dispose();
  }
}
