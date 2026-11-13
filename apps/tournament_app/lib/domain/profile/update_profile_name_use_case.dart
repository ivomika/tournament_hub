import 'package:tournament_app/domain/identifiers/identifier_generator.dart';
import 'package:tournament_app/domain/logging/profile_logger.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/operations/operation_sequence.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_exception.dart';
import 'package:tournament_app/domain/profile/profile_name.dart';
import 'package:tournament_app/domain/profile/profile_repository.dart';
import 'package:tournament_app/domain/profile/profile_update_trace.dart';

final class UpdateProfileNameUseCase {
  const UpdateProfileNameUseCase({
    required this.repository,
    required this.logger,
    required this.identifiers,
  });

  final ProfileRepository repository;
  final ProfileLogger logger;
  final IdentifierGenerator identifiers;

  OperationRequest<LocalProfile> start(String input, {int attempt = 1}) {
    final trace = ProfileUpdateTrace(
      logger: logger,
      execution: identifiers.generate(),
      attempt: attempt,
    );
    return OperationSequence().start(
      (sequence) => _update(sequence, input, trace),
    );
  }

  Future<LocalProfile> _update(
    OperationSequence sequence,
    String input,
    ProfileUpdateTrace trace,
  ) async {
    trace.started();
    try {
      final name = ProfileName(input);
      final existing = await sequence.run(() {
        trace.reading();
        return repository.read();
      });
      trace.readCompleted(found: existing != null);
      if (existing == null) {
        throw const ProfileException(ProfileFailureReason.notFound);
      }
      if (name == existing.name) {
        trace.succeeded(changed: false);
        return existing;
      }
      final updated = LocalProfile(id: existing.id, name: name);
      await sequence.run(() {
        trace.writing();
        return repository.save(updated);
      });
      trace.succeeded(changed: true);
      return updated;
    } on OperationAborted {
      trace.cancelled();
      rethrow;
    } catch (error, stackTrace) {
      if (error is ProfileException &&
          (error.reason == ProfileFailureReason.invalidName ||
              error.reason == ProfileFailureReason.notFound)) {
        trace.rejected(error.reason);
      } else {
        trace.failed(error, stackTrace);
      }
      rethrow;
    }
  }
}
