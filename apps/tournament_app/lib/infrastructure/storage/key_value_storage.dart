import 'package:tournament_app/domain/operations/operation_request.dart';

enum StorageKey { localProfile }

abstract interface class KeyValueStorage {
  OperationRequest<String?> read(StorageKey key);

  OperationRequest<void> write(StorageKey key, String value);
}
