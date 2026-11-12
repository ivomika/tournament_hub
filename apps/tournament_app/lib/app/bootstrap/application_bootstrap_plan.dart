import 'package:tournament_app/app/bootstrap/bootstrap_plan.dart';
import 'package:tournament_app/app/bootstrap/steps/initialize_logging_step.dart';
import 'package:tournament_app/app/bootstrap/steps/initialize_navigation_step.dart';
import 'package:tournament_app/app/bootstrap/steps/initialize_profile_step.dart';
import 'package:tournament_app/domain/identifiers/identifier_generator.dart';
import 'package:tournament_app/domain/profile/profile_repository.dart';
import 'package:tournament_app/infrastructure/identifiers/uuid_identifier_generator.dart';
import 'package:tournament_app/infrastructure/profile/stored_profile_repository.dart';
import 'package:tournament_app/infrastructure/storage/preferences_key_value_storage.dart';
import 'package:tournament_app/app/logging/app_loggers.dart';
import 'package:tournament_app/app/navigation/app_navigation_session.dart';

abstract final class ApplicationBootstrapPlan {
  static BootstrapPlan<AppNavigationSession> create({
    AppLoggers? loggers,
    ProfileRepository? profileRepository,
    IdentifierGenerator? identifierGenerator,
  }) => BootstrapPlan.seed(const BootstrapStart())
      .then(InitializeLoggingStep(loggers: loggers))
      .then(
        InitializeProfileStep(
          repository:
              profileRepository ??
              StoredProfileRepository(storage: PreferencesKeyValueStorage()),
          identifiers: identifierGenerator ?? UuidIdentifierGenerator(),
        ),
      )
      .then(const InitializeNavigationStep());
}
