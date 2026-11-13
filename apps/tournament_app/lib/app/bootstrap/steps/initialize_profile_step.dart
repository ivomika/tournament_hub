import 'package:tournament_app/app/bootstrap/bootstrap_failure.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_resource.dart';
import 'package:tournament_app/app/bootstrap/bootstrap_step.dart';
import 'package:tournament_app/app/bootstrap/profile_bootstrap_context.dart';
import 'package:tournament_app/app/logging/app_loggers.dart';
import 'package:tournament_app/app/profile/app_profile_session.dart';
import 'package:tournament_app/domain/identifiers/identifier_generator.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/operations/operation_sequence.dart';
import 'package:tournament_app/domain/profile/load_profile_use_case.dart';
import 'package:tournament_app/domain/profile/profile_exception.dart';
import 'package:tournament_app/domain/profile/profile_repository.dart';

final class InitializeProfileStep
    implements BootstrapStep<AppLoggers, ProfileBootstrapContext> {
  const InitializeProfileStep({
    required this.repository,
    required this.identifiers,
  });

  final ProfileRepository repository;
  final IdentifierGenerator identifiers;

  @override
  BootstrapPlacement get placement => BootstrapPlacement.afterApplication;

  @override
  OperationRequest<BootstrapResource<ProfileBootstrapContext>> start(
    AppLoggers input,
  ) => OperationSequence().start((sequence) => _load(sequence, input));

  Future<BootstrapResource<ProfileBootstrapContext>> _load(
    OperationSequence sequence,
    AppLoggers loggers,
  ) async {
    try {
      final profile = await sequence.run(LoadProfileUseCase(repository).start);
      final session = AppProfileSession(
        profile: profile,
        repository: repository,
        identifiers: identifiers,
        logger: loggers.profile,
      );
      return BootstrapResource(
        value: ProfileBootstrapContext(loggers: loggers, profile: session),
        onClose: session.close,
      );
    } on ProfileException catch (error) {
      throw BootstrapStepException(
        BootstrapFailureReason.dependencyUnavailable,
        retryAllowed: true,
        cause: error,
      );
    }
  }
}
