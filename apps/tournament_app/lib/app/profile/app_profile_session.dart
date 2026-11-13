import 'package:tournament_app/domain/identifiers/identifier_generator.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_repository.dart';
import 'package:tournament_app/domain/profile/register_profile_use_case.dart';
import 'package:flutter/foundation.dart';
import 'package:tournament_app/domain/logging/profile_logger.dart';
import 'package:tournament_app/domain/operations/managed_operation.dart';
import 'package:tournament_app/domain/operations/operation_outcome.dart';
import 'package:tournament_app/domain/operations/operation_scope.dart';
import 'package:tournament_app/domain/operations/operation_sequence.dart';
import 'package:tournament_app/domain/profile/update_profile_name_use_case.dart';

/// App-снимок только успешно прочитанного/сохранённого профиля.
final class AppProfileSession implements Listenable {
  factory AppProfileSession({
    required LocalProfile? profile,
    required ProfileRepository repository,
    required IdentifierGenerator identifiers,
    required ProfileLogger logger,
  }) => AppProfileSession._(profile, repository, identifiers, logger);

  AppProfileSession._(
    LocalProfile? profile,
    ProfileRepository repository,
    IdentifierGenerator identifiers,
    ProfileLogger logger,
  ) : _profile = ValueNotifier(profile) {
    final observed = _ObservedProfileRepository(
      repository,
      _operations,
      _accept,
    );
    registration = RegisterProfileUseCase(
      repository: observed,
      identifiers: identifiers,
    );
    updateName = UpdateProfileNameUseCase(
      repository: observed,
      identifiers: identifiers,
      logger: logger,
    );
  }

  final ValueNotifier<LocalProfile?> _profile;
  final OperationScope _operations = OperationScope();
  Future<void>? _closing;
  late final RegisterProfileUseCase registration;
  late final UpdateProfileNameUseCase updateName;

  LocalProfile? get profile => _profile.value;

  void _accept(LocalProfile? profile) => _profile.value = profile;

  @override
  void addListener(VoidCallback listener) => _profile.addListener(listener);

  @override
  void removeListener(VoidCallback listener) =>
      _profile.removeListener(listener);

  Future<void> close() => _closing ??= _close();

  Future<void> _close() async {
    try {
      await _operations.close();
    } finally {
      _profile.dispose();
    }
  }
}

final class _ObservedProfileRepository implements ProfileRepository {
  const _ObservedProfileRepository(
    this.repository,
    this.operations,
    this.accept,
  );

  final ProfileRepository repository;
  final OperationScope operations;
  final void Function(LocalProfile? profile) accept;

  @override
  OperationRequest<LocalProfile?> read() {
    final reading = operations.run(
      request: repository.read,
      onResult: accept,
      onError: _observe,
    );
    return OperationRequest(result: _value(reading), onCancel: reading.cancel);
  }

  @override
  OperationRequest<void> save(LocalProfile profile) {
    final saving = operations.run<void>(
      request: () => repository.save(profile),
      onResult: (_) => accept(profile),
      onError: _observe,
    );
    return OperationRequest(result: _value(saving), onCancel: saving.cancel);
  }

  static Future<Result> _value<Result>(
    ManagedOperation<Result> operation,
  ) async => switch (await operation.result) {
    OperationCompleted<Result>(:final value) => value,
    OperationFailed<Result>(:final error, :final stackTrace) =>
      Error.throwWithStackTrace(error, stackTrace),
    OperationCancelled<Result>(:final reason) => throw OperationAborted(reason),
  };

  static void _observe(Object error, StackTrace stackTrace) {}
}
