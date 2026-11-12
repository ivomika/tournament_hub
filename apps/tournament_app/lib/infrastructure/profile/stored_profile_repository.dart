import 'package:tournament_app/domain/operations/operation_request.dart';
import 'package:tournament_app/domain/operations/operation_sequence.dart';
import 'package:tournament_app/domain/profile/local_profile.dart';
import 'package:tournament_app/domain/profile/profile_exception.dart';
import 'package:tournament_app/domain/profile/profile_repository.dart';
import 'package:tournament_app/infrastructure/profile/profile_codec.dart';
import 'package:tournament_app/infrastructure/storage/key_value_storage.dart';

final class StoredProfileRepository implements ProfileRepository {
  const StoredProfileRepository({required this.storage});

  final KeyValueStorage storage;

  @override
  OperationRequest<LocalProfile?> read() => OperationSequence().start(_read);

  Future<LocalProfile?> _read(OperationSequence sequence) async {
    final String? payload;
    try {
      payload = await sequence.run(() => storage.read(StorageKey.localProfile));
    } on OperationAborted {
      rethrow;
    } catch (error) {
      throw ProfileException(ProfileFailureReason.read, cause: error);
    }
    return payload == null ? null : ProfileCodec.decode(payload);
  }

  @override
  OperationRequest<void> save(LocalProfile profile) =>
      OperationSequence().start((sequence) => _save(sequence, profile));

  Future<void> _save(OperationSequence sequence, LocalProfile profile) async {
    try {
      await sequence.run(
        () => storage.write(
          StorageKey.localProfile,
          ProfileCodec.encode(profile),
        ),
      );
    } on OperationAborted {
      rethrow;
    } catch (error) {
      throw ProfileException(ProfileFailureReason.write, cause: error);
    }
  }
}
