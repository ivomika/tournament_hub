import '../../application/bootstrap/errors/app_session_read_failure.dart';
import '../../application/bootstrap/models/app_session_projection.dart';
import '../../application/bootstrap/ports/app_session_reader.dart';
import '../lifecycle/app_state.dart';
import '../lifecycle/app_state_writer.dart';

final class AppBootstrap {
  AppBootstrap(this._sessionReader, this._stateWriter);

  final AppSessionReader _sessionReader;
  final AppStateWriter _stateWriter;
  int _generation = 0;
  bool _isDisposed = false;

  Future<void> start() => _run();

  Future<void> retry() => _run();

  Future<void> _run() async {
    if (_isDisposed) return;
    final generation = ++_generation;

    try {
      _publishStage(AppBootstrapStage.dependencies, generation);
      await _sessionReader.validateAvailability();
      if (!_isCurrent(generation)) return;

      _publishStage(AppBootstrapStage.profile, generation);
      final profile = await _sessionReader.readLocalProfile();
      if (!_isCurrent(generation)) return;
      if (profile == null) {
        _stateWriter.publish(const AppProfileRequired());
        return;
      }

      _publishStage(AppBootstrapStage.activeTournament, generation);
      final activeTournament = await _sessionReader.readActiveTournament(
        localProfileId: profile.id,
      );
      if (!_isCurrent(generation)) return;

      if (activeTournament != null &&
          activeTournament.localProfileId != profile.id) {
        _stateWriter.publish(
          const AppRecoverableFailure(
            problem: AppProblemCode.inconsistentSession,
          ),
        );
        return;
      }

      _stateWriter.publish(
        AppOperational(
          AppSessionProjection(
            profile: profile,
            activeTournament: activeTournament,
          ),
        ),
      );
    } on AppSessionReadFailure catch (failure) {
      if (!_isCurrent(generation)) return;
      final problem = _mapFailure(failure.code);
      if (failure.recoverable) {
        _stateWriter.publish(AppRecoverableFailure(problem: problem));
      } else {
        _stateWriter.publish(AppFatalFailure(problem: problem));
      }
    } on Object {
      if (!_isCurrent(generation)) return;
      _stateWriter.publish(
        const AppFatalFailure(problem: AppProblemCode.unexpectedFailure),
      );
    }
  }

  void _publishStage(AppBootstrapStage stage, int generation) {
    if (!_isCurrent(generation)) return;
    _stateWriter.publish(
      AppBootstrapping(stage: stage, generation: generation),
    );
  }

  bool _isCurrent(int generation) => !_isDisposed && generation == _generation;

  AppProblemCode _mapFailure(AppSessionReadFailureCode code) => switch (code) {
    AppSessionReadFailureCode.dependencyUnavailable =>
      AppProblemCode.dependencyUnavailable,
    AppSessionReadFailureCode.profileReadFailed =>
      AppProblemCode.profileReadFailed,
    AppSessionReadFailureCode.activeTournamentReadFailed =>
      AppProblemCode.activeTournamentReadFailed,
  };

  void dispose() {
    if (_isDisposed) return;
    _isDisposed = true;
    _generation++;
  }
}
