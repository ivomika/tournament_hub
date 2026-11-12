import 'package:tournament_app/domain/identifiers/identifier_generator.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_repository.dart';
import 'package:tournament_app/domain/profile/register_profile_use_case.dart';

/// App-снимок только успешно прочитанного/сохранённого профиля.
final class AppProfileSession {
  factory AppProfileSession({
    required LocalProfile? profile,
    required ProfileRepository repository,
    required IdentifierGenerator identifiers,
  }) => AppProfileSession._(profile, repository, identifiers);

  AppProfileSession._(
    this._profile,
    ProfileRepository repository,
    IdentifierGenerator identifiers,
  ) {
    registration = RegisterProfileUseCase(
      repository: _ObservedProfileRepository(repository, _accept),
      identifiers: identifiers,
    );
  }

  LocalProfile? _profile;
  late final RegisterProfileUseCase registration;

  LocalProfile? get profile => _profile;

  void _accept(LocalProfile? profile) => _profile = profile;
}

final class _ObservedProfileRepository implements ProfileRepository {
  const _ObservedProfileRepository(this.repository, this.accept);

  final ProfileRepository repository;
  final void Function(LocalProfile? profile) accept;

  @override
  OperationRequest<LocalProfile?> read() {
    final reading = repository.read();
    return OperationRequest(
      result: reading.result.then((profile) {
        accept(profile);
        return profile;
      }),
      onCancel: reading.onCancel,
    );
  }

  @override
  OperationRequest<void> save(LocalProfile profile) {
    final saving = repository.save(profile);
    return OperationRequest(
      result: saving.result.then((_) => accept(profile)),
      onCancel: saving.onCancel,
    );
  }
}
