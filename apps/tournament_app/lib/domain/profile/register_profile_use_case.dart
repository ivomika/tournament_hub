import 'package:tournament_app/domain/identifiers/identifier_generator.dart';
import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/operations/operation_sequence.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_id.dart';
import 'package:tournament_app/domain/profile/profile_name.dart';
import 'package:tournament_app/domain/profile/profile_repository.dart';

final class RegisterProfileUseCase {
  const RegisterProfileUseCase({
    required this.repository,
    required this.identifiers,
  });

  final ProfileRepository repository;
  final IdentifierGenerator identifiers;

  OperationRequest<LocalProfile> start(String name) =>
      OperationSequence().start((sequence) => _register(sequence, name));

  Future<LocalProfile> _register(
    OperationSequence sequence,
    String input,
  ) async {
    final name = ProfileName(input);
    final existing = await sequence.run(repository.read);
    if (existing != null && existing.isComplete) return existing;

    // Генерация и начало записи принадлежат следующему шагу scope: отмена
    // между чтением и этим шагом не создаёт новый ID и не начинает запись.
    return sequence.run(() {
      final profile = LocalProfile(
        id: existing?.id ?? ProfileId(identifiers.generate()),
        name: name,
      );
      final saving = repository.save(profile);
      return OperationRequest(
        result: saving.result.then((_) => profile),
        onCancel: saving.onCancel,
      );
    });
  }
}
